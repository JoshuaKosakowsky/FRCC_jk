Option Explicit

Sub CFL_Formatting()
    Dim ws As Worksheet
    Dim lastRow As Long, lastCol As Long
    Dim missing As Collection
    Dim zoomLvl As Long: zoomLvl = 130
    
    Set ws = ActiveSheet
    
    Application.ScreenUpdating = False
    Application.EnableEvents = False
    Application.Calculation = xlCalculationManual
    
    '--- Delete blank header row
    ws.Rows("1:1").Delete Shift:=xlUp
    
    '--- Determine the column after deletion
    lastCol = LastColInRow(ws, 1)
    
    '--- Header rename mapping:
    ' Overwrite A1 rather than search for it due to the unique character it exports with
    ws.Range("A1").Value = "COLLEGE"
    
    
    '    Add/remove pairs here as needed
    Dim renameMap As Object: Set renameMap = CreateObject("Scripting.Dictionary")
    renameMap.CompareMode = vbTextCompare  ' case-insensitive
    
    ' Mapping:
    renameMap("SSBSECT_TERM_CODE") = "TERM"
    renameMap("SSBSECT_CRN") = "CRN"
    renameMap("SSBSECT_SUBJ_CODE") = "SUBJECT"
    renameMap("SSBSECT_CRSE_NUMB") = "COURSE NUMBER"
    renameMap("SSBSECT_SEQ_NUMB") = "SECTION"
    renameMap("SSBSECT_CAMP_CODE") = "CAMPUS"
    renameMap("SSBSECT_CREDIT_HRS") = "CREDIT HRS"
    renameMap("SSBSECT_BILL_HRS") = "BILL HRS"
    renameMap("SSRATTR_ATTR_CODE") = "ATTRIBUTE"
    renameMap("SSRATTR_ACTIVITY_DATE") = "ACTIVITY DATE"
    renameMap("SSRFEES_DETL_CODE") = "DETAIL CODE"
    renameMap("SSRFEES_AMOUNT") = "FEE"
    renameMap("SSRFEES_LEVL_CODE") = "LEVEL CODE"
    renameMap("SSRFEES_FTYP_CODE") = "CODE TYPE"
    
    '--- Perform rename
    Set missing = New Collection
    Call RenameHeadersByName(ws, 1, lastCol, renameMap, missing)
    
    '--- Overwrite A2 with A3 value (Again, funky Banner export issue)
    If ws.Range("A3").Value <> "" Then
        ws.Range("A2").Value = ws.Range("A3").Value
    End If
    
    '--- Header formatting
    With ws.Range(ws.Cells(1, 1), ws.Cells(1, Application.WorksheetFunction.Max(LastColInRow(ws, 1), lastCol)))
        .Font.Bold = True
        .Interior.Color = 15773696
    End With
    
    '--- Autofilter applied to full header row
    ws.Range(ws.Cells(1, 1), ws.Cells(1, LastColInRow(ws, 1))).AutoFilter
    
    '--- Autofit
    ws.Cells.EntireColumn.AutoFit
    ws.Cells.EntireRow.AutoFit
    
    '--- Hide columns (keep only these headers)
    Dim keepHeaders As Variant
    keepHeaders = Array( _
        "COLLEGE", "TERM", "CRN", "SUBJECT", "COURSE NUMBER", "SECTION", "CAMPUS", _
        "CREDIT HRS", "BILL HRS", "ATTRIBUTE", "ACTIVITY DATE", "DETAIL CODE", _
        "FEE", "LEVEL CODE", "CODE TYPE" _
    )
    HideAllExceptHeaders ws, keepHeaders

    '--- Freeze top row
    With ActiveWindow
        .SplitRow = 1
        .FreezePanes = True
    End With
    
    '--- Sort by header names (find columns dynamically)
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row
    Call SortByHeaders(ws, lastRow, Array("SUBJECT", "COURSE NUMBER", "SECTION", "CAMPUS"))
    
    '--- Optional zoom
    ActiveWindow.Zoom = zoomLvl
    
    '--- Report any headers that weren't found for renaming
    If missing.Count > 0 Then
        Dim itm As Variant
        Debug.Print "Headers not found (rename skipped):"
        For Each itm In missing
            Debug.Print "  - " & CStr(itm)
        Next itm
    End If
    
Cleanup:
    Application.Calculation = xlCalculationAutomatic
    Application.EnableEvents = True
    Application.ScreenUpdating = True
End Sub

'==================== Helpers ====================

Private Function LastColInRow(ws As Worksheet, headerRow As Long) As Long
    LastColInRow = ws.Cells(headerRow, ws.Columns.Count).End(xlToLeft).Column
End Function

Private Function FindHeaderCol(ws As Worksheet, headerRow As Long, headerText As String) As Long
    ' Case-insensitive, trim-aware match across the header row.
    Dim c As Range, rng As Range
    Dim txt As String
    
    Set rng = ws.Range(ws.Cells(headerRow, 1), ws.Cells(headerRow, LastColInRow(ws, headerRow)))
    For Each c In rng.Cells
        txt = Trim(CStr(c.Value))
        If StrComp(txt, Trim(headerText), vbTextCompare) = 0 Then
            FindHeaderCol = c.Column
            Exit Function
        End If
    Next c
    FindHeaderCol = 0
End Function

Private Sub RenameHeadersByName(ws As Worksheet, headerRow As Long, lastCol As Long, ByVal map As Object, ByRef missing As Collection)
    Dim key As Variant
    Dim colIdx As Long
    For Each key In map.Keys
        colIdx = FindHeaderCol(ws, headerRow, CStr(key))
        If colIdx > 0 Then
            ws.Cells(headerRow, colIdx).Value = map(key)
        Else
            missing.Add CStr(key)
        End If
    Next key
End Sub

Private Sub HideColumnsByHeader(ws As Worksheet, headersToHide As Variant)
    Dim i As Long, colIdx As Long, h As String
    For i = LBound(headersToHide) To UBound(headersToHide)
        h = CStr(headersToHide(i))
        If Len(h) > 0 Then
            colIdx = FindHeaderCol(ws, 1, h)
            If colIdx > 0 Then ws.Columns(colIdx).EntireColumn.Hidden = True
        End If
    Next i
End Sub

Private Sub SortByHeaders(ws As Worksheet, lastRow As Long, sortHeaders As Variant)
    Dim i As Long, colIdx As Long
    With ws.Sort
        .SortFields.Clear
        For i = LBound(sortHeaders) To UBound(sortHeaders)
            colIdx = FindHeaderCol(ws, 1, CStr(sortHeaders(i)))
            If colIdx > 0 Then
                .SortFields.Add2 key:=ws.Range(ws.Cells(2, colIdx), ws.Cells(lastRow, colIdx)), Order:=xlAscending
            Else
                Debug.Print "Sort header not found (skipped): " & CStr(sortHeaders(i))
            End If
        Next i
        .SetRange ws.Range(ws.Cells(1, 1), ws.Cells(lastRow, LastColInRow(ws, 1)))
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
End Sub

Private Sub HideAllExceptHeaders(ws As Worksheet, keepHeaders As Variant)
    Dim lastCol As Long, col As Long, keep As Object, hdr As String
    Set keep = CreateObject("Scripting.Dictionary")
    keep.CompareMode = vbTextCompare
    Dim i As Long
    For i = LBound(keepHeaders) To UBound(keepHeaders)
        keep(Trim(CStr(keepHeaders(i)))) = True
    Next i
    
    lastCol = ws.Cells(1, ws.Columns.Count).End(xlToLeft).Column
    ' Unhide all first
    ws.Columns.Hidden = False
    
    ' Hide any column whose header is NOT in keep list
    For col = 1 To lastCol
        hdr = Trim(CStr(ws.Cells(1, col).Value))
        If Len(hdr) > 0 Then
            If Not keep.Exists(hdr) Then
                ws.Columns(col).Hidden = True
            End If
        Else
            ' No header text: hide
            ws.Columns(col).Hidden = True
        End If
    Next col
End Sub
