Option Explicit

Public Const SHEET_INSTR As String = "Instructions"
Public Const SHEET_DATA  As String = "Data Entry"

Public Sub TSPCSTU()
    On Error GoTo CleanFail
    
    Dim wsI As Worksheet, wsD As Worksheet
    Dim vpdi As String, userId As String
    Dim colID As Long, colAmt As Long
    Dim rLast As Long, r As Long
    Dim tmpAmt As Double
    Dim dupVal As String
    Dim csvName As String, csvPath As String
    
    ' quiet mode
    Dim su As Boolean, ea As Boolean, da As Boolean, calcPrev As XlCalculation
    su = Application.ScreenUpdating: Application.ScreenUpdating = False
    ea = Application.EnableEvents:    Application.EnableEvents = False
    da = Application.DisplayAlerts:   Application.DisplayAlerts = False
    calcPrev = Application.Calculation: Application.Calculation = xlCalculationManual
    
    Set wsI = ThisWorkbook.Worksheets(SHEET_INSTR)
    Set wsD = ThisWorkbook.Worksheets(SHEET_DATA)
    
    ' ---- Inputs ----
    vpdi = Trim$(CStr(wsI.Range("C4").Value))
    userId = Trim$(CStr(wsI.Range("C5").Value))
    If vpdi = "" Or userId = "" Then
        Dim msg As String
        If vpdi = "" Then msg = msg & "- VPDI (Instructions!C4) is required." & vbCrLf
        If userId = "" Then msg = msg & "- User ID (Instructions!C5) is required." & vbCrLf
        MsgBox "Cannot continue:" & vbCrLf & msg, vbCritical, "Missing Inputs"
        GoTo CleanExit
    End If
    
    ' ---- Identify columns on Data Entry ----
    colID = FindHeaderColumn(wsD, "StudentID", 1, 2)
    colAmt = FindHeaderColumn(wsD, "Amts", 1, 2)
    If colID = 0 Or colAmt = 0 Then
        MsgBox "Could not find headers 'StudentID' and 'Amts' on the 'Data Entry' sheet (row 1–2).", vbCritical, "Missing Headers"
        GoTo CleanExit
    End If
    
    ' ---- No data check ----
    rLast = LastUsedRow(wsD, colID)
    If rLast < 2 Then
        MsgBox "No data found on 'Data Entry' (no rows below the header).", vbCritical, "No Data"
        GoTo CleanExit
    End If
    
    ' ---- Duplicate StudentID check ----
    If HasDuplicateInColumn(wsD, colID, 2, rLast, dupVal) Then
        MsgBox "Duplicate StudentID detected: " & dupVal & vbCrLf & _
               "Please remove duplicates and try again.", vbCritical, "Duplicate StudentID"
        GoTo CleanExit
    End If
    
    ' ---- Temporary workbook for CSV (no tabs added to template) ----
    Dim tmpWb As Workbook, tmpWs As Worksheet
    Set tmpWb = Application.Workbooks.Add(xlWBATWorksheet)
    Set tmpWs = tmpWb.Worksheets(1)
    
    ' Headers A:J
    tmpWs.Range("A1:J1").Value = Array( _
        "StudentID", "SSN", "LastName", "FirstName", "RollStudent", _
        "ExpireTerm", "Authorize", "AuthNumber", "MaxAmount", "SponsorReference" _
    )
    
    ' Data rows: A = StudentID, I = MaxAmount (amount × 100, no decimals)
    Dim outRow As Long: outRow = 2
    For r = 2 To rLast
        Dim sid As String
        Dim amtCents As Long  ' integer cents
        sid = Trim$(CStr(wsD.Cells(r, colID).Value))
        If sid <> "" And TryParseAmount(wsD.Cells(r, colAmt).Value, tmpAmt) Then
            amtCents = CLng(CDec(tmpAmt) * 100@)
            tmpWs.Cells(outRow, 1).Value = sid          ' A: StudentID
            tmpWs.Cells(outRow, 9).Value = amtCents     ' I: MaxAmount (no decimal)
            outRow = outRow + 1
        End If
    Next r
    
    If outRow = 2 Then
        tmpWb.Close False
        MsgBox "All rows were blank or had non-numeric amounts. Nothing to export.", vbCritical, "No Valid Rows"
        GoTo CleanExit
    End If
    
    ' ---- Save CSV to Downloads with required name pattern ----
    csvName = SafeSlug(vpdi) & "_" & Format(Now, "yyyymmdd_HHMMSS") & ".csv"
    csvPath = GetDownloadsPath() & csvName
    tmpWb.SaveAs Filename:=csvPath, FileFormat:=xlCSVUTF8
    tmpWb.Close SaveChanges:=False
    
    ' ---- Confirm to the user ----
    MsgBox csvName & " created and saved to the Downloads Folder", vbInformation, "Export Complete"
    
    ' ---- Clear Data Entry rows 2+ ----
    wsD.Rows("2:" & rLast).ClearContents
    
    ' ---- Clear VPDI and User ID for reuse ----
    wsI.Range("C4:C5").ClearContents
    
CleanExit:
    Application.ScreenUpdating = su
    Application.EnableEvents = ea
    Application.DisplayAlerts = da
    Application.Calculation = calcPrev
    Exit Sub

CleanFail:
    MsgBox "Unexpected error " & Err.Number & ": " & Err.Description, vbCritical, "TSPCSTU"
    Resume CleanExit
End Sub

'=================== Helpers ===================

Private Function FindHeaderColumn(ws As Worksheet, header As String, firstRow As Long, lastRow As Long) As Long
    Dim r As Long, c As Long, lastCol As Long
    lastCol = ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column
    For r = firstRow To lastRow
        For c = 1 To lastCol
            If StrComp(Trim$(CStr(ws.Cells(r, c).Value)), header, vbTextCompare) = 0 Then
                FindHeaderColumn = c
                Exit Function
            End If
        Next c
    Next r
End Function

Private Function LastUsedRow(ws As Worksheet, col As Long) As Long
    If ws Is Nothing Then
        LastUsedRow = 1
    Else
        LastUsedRow = ws.Cells(ws.Rows.Count, col).End(xlUp).Row
    End If
End Function

Private Function HasDuplicateInColumn(ws As Worksheet, col As Long, startRow As Long, lastRow As Long, _
                                      Optional ByRef firstDupValue As String) As Boolean
    Dim dict As Object, r As Long, key As String
    Set dict = CreateObject("Scripting.Dictionary")
    For r = startRow To lastRow
        key = Trim$(CStr(ws.Cells(r, col).Value))
        If key <> "" Then
            If dict.Exists(key) Then
                HasDuplicateInColumn = True
                firstDupValue = key
                Exit Function
            Else
                dict.Add key, 1
            End If
        End If
    Next r
    HasDuplicateInColumn = False
End Function

Private Function TryParseAmount(v As Variant, ByRef outAmt As Double) As Boolean
    Dim s As String
    s = Trim$(CStr(v))
    If s = "" Then Exit Function
    s = Replace$(s, "$", "")
    s = Replace$(s, ",", "")
    s = Replace$(s, " ", "")
    If IsNumeric(s) Then
        outAmt = CDbl(s)
        TryParseAmount = True
    End If
End Function

Private Function SafeSlug(s As String) As String
    Dim bad As Variant, i As Long
    bad = Array("\", "/", ":", "*", "?", """", "<", ">", "|")
    For i = LBound(bad) To UBound(bad)
        s = Replace$(s, bad(i), "_")
    Next i
    SafeSlug = Trim$(s)
End Function

Private Function GetDownloadsPath() As String
    Dim base As String
    base = Environ$("USERPROFILE")
    If Right$(base, 1) <> "\" Then base = base & "\"
    GetDownloadsPath = base & "Downloads\"
End Function


