Option Explicit

' ===== CONFIG =====
Private Const SHEET_VENDOR As String = "Vendor Info"
Private Const SHEET_STUDENTS As String = "Students and Amounts"

' ===== VENDOR LOOKUP (edit these pairs as needed) =====
Private VENDOR_LOOKUP_IDS As Variant
Private VENDOR_LOOKUP_NAMES As Variant

Private Sub InitVendorLookup()
    ' Edit the two arrays in parallel (same order, same length)
    VENDOR_LOOKUP_IDS = Array( _
        "S01850571", _
        "S01480021", _
        "S01912060", _
        "S01832028" _
    )

    VENDOR_LOOKUP_NAMES = Array( _
        "Adams 12 Five Star Schools CE", _
        "Adams-Weld School District 27J", _
        "LC Colorado Early Colleges Fort Collins", _
        "Thompson SD CE" _
    )
End Sub

Private Function GetVendorName(ByVal vendorSid As String) As String
    Dim i As Long
    If IsEmpty(VENDOR_LOOKUP_IDS) Then InitVendorLookup
    For i = LBound(VENDOR_LOOKUP_IDS) To UBound(VENDOR_LOOKUP_IDS)
        If StrComp(Trim$(vendorSid), Trim$(VENDOR_LOOKUP_IDS(i)), vbTextCompare) = 0 Then
            GetVendorName = VENDOR_LOOKUP_NAMES(i)
            Exit Function
        End If
    Next i
    GetVendorName = "Not in list for lookup"
End Function

' ===== ENTRY POINT =====
Public Sub AR_CreateVendorCSV()
    On Error GoTo CleanFail
    Application.ScreenUpdating = False
    Application.EnableEvents = False

    Dim wb As Workbook: Set wb = ActiveWorkbook
    Dim wsVendor As Worksheet, wsStud As Worksheet
    Set wsVendor = wb.Worksheets(SHEET_VENDOR)
    Set wsStud = wb.Worksheets(SHEET_STUDENTS)

    ' Read vendor info
    Dim vendorSid As String, contractNum As String, termStr As String
    vendorSid = Trim$(CStr(wsVendor.Range("B2").Value))   ' A2 label "SID" / B2 value
    contractNum = Trim$(CStr(wsVendor.Range("B3").Value)) ' A3 label "Contract Number" / B3 value
    termStr = Trim$(CStr(wsVendor.Range("B4").Value))     ' A4 label "Term" / B4 value
    
    
    ' Lookup vendor display name
    Dim vendorName As String
    vendorName = GetVendorName(vendorSid)

    ' Gather students and amounts from "Students and Amounts" (no headers)
    Dim lastRow As Long: lastRow = LastUsedRow(wsStud, 1)
    If lastRow < 1 Then Err.Raise vbObjectError + 100, , "'" & SHEET_STUDENTS & "' contains no data."

    Dim sids() As String, amts() As Currency
    Dim i As Long, r As Long, cnt As Long
    ReDim sids(1 To lastRow)
    ReDim amts(1 To lastRow)

    ' Collect, clean, count
    cnt = 0
    For r = 1 To lastRow
        Dim sid As String: sid = Trim$(CStr(wsStud.Cells(r, 1).Value))
        Dim rawAmt As String: rawAmt = Trim$(CStr(wsStud.Cells(r, 2).Value))
        If Len(sid) > 0 Then
            cnt = cnt + 1
            sids(cnt) = sid
            amts(cnt) = ParseCurrencyValue(rawAmt)  ' Currency type avoids floating errors
        End If
    Next r
    If cnt = 0 Then Err.Raise vbObjectError + 101, , "No SIDs found in column A of '" & SHEET_STUDENTS & "'."

    ' Shrink arrays to actual count
    ReDim Preserve sids(1 To cnt)
    ReDim Preserve amts(1 To cnt)

    ' Duplicate check
    Dim dupMsg As String
    If HasDuplicateSIDs(sids, dupMsg) Then
        MsgBox "Duplicate SID Found, please review data entry." & vbCrLf & vbCrLf & dupMsg, vbCritical
        GoTo CleanExit
    End If

    ' Totals
    Dim totalStudents As Long: totalStudents = cnt
    Dim totalDollars As Currency: totalDollars = 0
    For i = 1 To cnt
        totalDollars = totalDollars + amts(i)
    Next i

    ' Dates, VPDI, and User ID prompts
    Dim entryDate As Date: entryDate = Date
    Dim effDate As Date: effDate = Date

    Dim vpdi As String
    vpdi = InputBox("Enter VPDI (default FRCC):", "VPDI", "FRCC")
    vpdi = UCase$(Trim$(vpdi))
    If Len(vpdi) = 0 Then
        MsgBox "VPDI is required.", vbExclamation
        GoTo CleanExit
    End If

    Dim userId As String
    userId = InputBox("Enter User ID (e.g., JKOSAKOWSKY):", "User ID", "")
    userId = UCase$(Trim$(userId))
    If Len(userId) = 0 Then
        MsgBox "User ID is required.", vbExclamation
        GoTo CleanExit
    End If

    ' Confirmation dialog
    Dim confirm As VbMsgBoxResult
    confirm = MsgBox( _
        "Please confirm parameters:" & vbCrLf & vbCrLf & _
        "Vendor ID: " & vendorSid & vbCrLf & _
        "Vendor Name: " & vendorName & vbCrLf & vbCrLf & _
        "VPDI: " & vpdi & vbCrLf & _
        "User ID: " & userId & vbCrLf & _
        "Entry Date: " & Format$(entryDate, "m/d/yyyy") & vbCrLf & _
        "Eff Date: " & Format$(effDate, "m/d/yyyy") & vbCrLf & _
        "Total Students: " & totalStudents & vbCrLf & _
        "Total Dollars: " & FormatCurrency(totalDollars, 2), _
        vbQuestion + vbOKCancel, "Confirm & Create CSV")
    If confirm <> vbOK Then GoTo CleanExit

    ' Compose CSV lines: headers + rows
    Dim lines() As String
    ReDim lines(0 To cnt) ' header + cnt rows

    ' Headers A..J
    lines(0) = Join(Array( _
        "StudentID", "SSN", "LastName", "FirstName", "RollStudent", _
        "ExpireTerm", "Authorize", "AuthNumber", "MaxAmount", "SponsorReference" _
    ), ",")

    ' Option to include Term / Contract Number, set these here:
    Dim csvExpireTerm As String: csvExpireTerm = ""   ' e.g., termStr
    Dim csvAuthorize As String:  csvAuthorize = ""    ' e.g., ""
    Dim csvAuthNumber As String: csvAuthNumber = ""   ' e.g., contractNum
    Dim csvMaxAmount As String:  csvMaxAmount = ""    ' Blank to match your example

    ' Build data rows
    For i = 1 To cnt
        Dim sponsorRef As String
        sponsorRef = CStr(CLng(CCur(amts(i) * 100)))  ' 803.16 -> 80316
    
        Dim fields(0 To 9) As String
        fields(0) = SanitizeCSV(sids(i))     ' StudentID
        fields(1) = ""                       ' SSN
        fields(2) = ""                       ' LastName
        fields(3) = ""                       ' FirstName
        fields(4) = ""                       ' RollStudent
        fields(5) = SanitizeCSV(csvExpireTerm)  ' ExpireTerm
        fields(6) = SanitizeCSV(csvAuthorize)   ' Authorize
        fields(7) = SanitizeCSV(csvAuthNumber)  ' AuthNumber
        fields(8) = SanitizeCSV(csvMaxAmount)   ' MaxAmount
        fields(9) = sponsorRef                  ' SponsorReference
    
        lines(i) = Join(fields, ",")
    Next i

    ' Output path
    Dim outDir As String
    outDir = GetDownloadsPath()
    If Len(Dir$(outDir, vbDirectory)) = 0 Then
        outDir = Environ$("USERPROFILE") & "\Desktop\"
    End If

    Dim outName As String
    outName = vpdi & "_" & Format$(Now, "yyyymmdd_hhnnss") & ".csv"

    Dim fullPath As String
    fullPath = outDir & outName

    ' Write file
    WriteAllText fullPath, Join(lines, vbCrLf)

    MsgBox "CSV created:" & vbCrLf & fullPath, vbInformation

CleanExit:
    Application.EnableEvents = True
    Application.ScreenUpdating = True
    Exit Sub

CleanFail:
    MsgBox "Error " & Err.Number & ": " & Err.Description, vbCritical
    Resume CleanExit
End Sub

' ===== HELPERS =====

Private Function LastUsedRow(ws As Worksheet, col As Long) As Long
    Dim r As Range
    On Error Resume Next
    Set r = ws.Cells(ws.Rows.Count, col).End(xlUp)
    On Error GoTo 0
    If r Is Nothing Then
        LastUsedRow = 0
    Else
        ' If only A1 is selected and empty, treat as 0 rows
        If r.Row = 1 And Len(Trim$(CStr(ws.Cells(1, col).Value))) = 0 Then
            LastUsedRow = 0
        Else
            LastUsedRow = r.Row
        End If
    End If
End Function

Private Function ParseCurrencyValue(ByVal s As String) As Currency
    ' Remove commas, spaces, and leading $; handle negatives in parentheses
    Dim neg As Boolean: neg = False
    Dim t As String: t = Trim$(s)
    If Len(t) = 0 Then
        ParseCurrencyValue = 0
        Exit Function
    End If

    If Left$(t, 1) = "(" And Right$(t, 1) = ")" Then
        neg = True
        t = Mid$(t, 2, Len(t) - 2)
    End If

    t = Replace(t, "$", "")
    t = Replace(t, ",", "")
    t = Replace(t, " ", "")

    If Len(t) = 0 Or Not IsNumeric(t) Then
        ParseCurrencyValue = 0
        Exit Function
    End If

    Dim valC As Currency
    valC = CCur(t)
    If neg Then valC = -valC
    ParseCurrencyValue = valC
End Function

Private Function HasDuplicateSIDs(ByRef sids() As String, ByRef msg As String) As Boolean
    Dim dict As Object: Set dict = CreateObject("Scripting.Dictionary")
    Dim i As Long
    For i = LBound(sids) To UBound(sids)
        Dim k As String: k = UCase$(Trim$(sids(i)))
        If dict.exists(k) Then
            HasDuplicateSIDs = True
            msg = "Duplicate value: " & sids(i)
            Exit Function
        Else
            dict.Add k, True
        End If
    Next i
    HasDuplicateSIDs = False
    msg = ""
End Function

Private Function SanitizeCSV(ByVal s As String) As String
    ' Wrap in quotes if needed and escape internal quotes
    If InStr(1, s, """") > 0 Then s = Replace(s, """", """""")
    If InStr(1, s, ",") > 0 Or InStr(1, s, vbCr) > 0 Or InStr(1, s, vbLf) > 0 Then
        SanitizeCSV = """" & s & """"
    Else
        SanitizeCSV = s
    End If
End Function

Private Function GetDownloadsPath() As String
    ' Default for Windows
    Dim base As String: base = Environ$("USERPROFILE")
    If Len(base) = 0 Then base = Environ$("HOMEPATH")
    If Len(base) > 0 Then
        If Right$(base, 1) <> "\" Then base = base & "\"
        GetDownloadsPath = base & "Downloads\"
    Else
        GetDownloadsPath = "C:\Users\Public\Downloads\"
    End If
End Function

Private Sub WriteAllText(ByVal filePath As String, ByVal content As String)
    Dim f As Integer
    f = FreeFile
    Open filePath For Output As #f
    Print #f, content
    Close #f
End Sub


