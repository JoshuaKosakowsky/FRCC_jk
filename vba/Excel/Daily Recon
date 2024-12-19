Sub Daily_Recon()
    Dim wbNetwork As Workbook
    Dim wsNetwork As Worksheet
    Dim wsYesterday As Worksheet, wsToday As Worksheet, wsDest As Worksheet
    Dim lastRowYesterday As Long, lastRowToday As Long, lastCol As Long, i As Long, j As Long
    Dim colValues As New Collection
    Dim value As Variant
    Dim sheetName As String
    Dim networkPath As String
    
    ' Folder path to DNR excel file
    Path = "C:\Users\S03112819\OneDrive - Colorado Community College System\Refunds\Auto and Manual Refunds\Reversals- DO NOT REFUND PA.xlsx"
    
    ' Open DNR and set source worksheet
    Set wbNetwork = Workbooks.Open(Path)
    Set wsNetwork = wbNetwork.Sheets("DNR List")
    
    ' Ensure "DNR" and "FSA" sheets exist in workbook
    On Error Resume Next
    Set wsDNR = ThisWorkbook.Sheets("DNR")
    Set wsFSA = ThisWorkbook.Sheets("FSA")
    If wsDNR Is Nothing Then
        Set wsDNR = ThisWorkbook.Sheets.Add(After:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count))
        wsDNR.Name = "DNR"
    End If
    If wsFSA Is Nothing Then
        Set wsFSA = ThisWorkbook.Sheets.Add(After:=wsDNR)
    End If
    On Error GoTo 0
    
    ' Clear existing contents in "DNR" and copy info from DNR list and close without saving
    wsDNR.Cells.Clear
    wsNetwork.Cells.Copy Destination:=wsDNR.Cells(1, 1)
    wbNetwork.Close SaveChanges:=False
    
    ' Set the source worksheets
    Set wsYesterday = ThisWorkbook.Sheets("Net Credit Yesterday") ' Yesterday's data
    Set wsToday = ThisWorkbook.Sheets("Net Credit Today")         ' Today's data

    ' Determine the last row in column D in both sheets
    lastRowYesterday = wsYesterday.Cells(wsYesterday.Rows.Count, "D").End(xlUp).Row
    lastRowToday = wsToday.Cells(wsToday.Rows.Count, "D").End(xlUp).Row

    ' Collect unique values from column D in yesterday's data sheet
    On Error Resume Next ' Ignore errors if trying to add a duplicate item to the collection
    For i = 2 To lastRowYesterday ' Assume row 1 has headers
        colValues.Add wsYesterday.Cells(i, "D").value, CStr(wsYesterday.Cells(i, "D").value)
    Next i
    On Error GoTo 0 ' Turn back on regular error handling

    ' Sort collection in descending order
    Dim sortedValues() As Variant
    ReDim sortedValues(1 To colValues.Count)
    
    i = 1
    For Each value In colValues
        sortedValues(i) = value
        i = i + 1
    Next value
    
    ' Simple bubble sort
    Dim temp As Variant
    For i = 1 To UBound(sortedValues) - 1
        For j = i + 1 To UBound(sortedValues)
            If sortedValues(i) < sortedValues(j) Then
                temp = sortedValues(i)
                sortedValues(i) = sortedValues(j)
                sortedValues(j) = temp
            End If
        Next j
    Next i
    
    ' Create new sheets and copy corresponding rows from both sources
    For Each value In sortedValues
        sheetName = "Term " & value
        On Error Resume Next ' Ignore error if sheet already exists
        Set wsDest = ThisWorkbook.Sheets.Add(After:=ThisWorkbook.Sheets(ThisWorkbook.Sheets.Count))
        wsDest.Name = sheetName
        On Error GoTo 0
        
        ' Copy headers from the source
        wsYesterday.Rows(1).Copy Destination:=wsDest.Rows(1)
        
        ' Add "DNR" and "Notes" columns at the end
        lastCol = wsDest.Cells(1, Columns.Count).End(xlToLeft).Column
        wsDest.Cells(1, lastCol + 1).value = "DNR"
        wsDest.Cells(1, lastCol + 2).value = "HS"
        wsDest.Cells(1, lastCol + 3).value = "Notes"
        
        j = 2 ' Start from row 2 in destination sheet
        ' Copy from yesterday's source
        For i = 2 To lastRowYesterday
            If wsYesterday.Cells(i, "D").value = value Then
                wsYesterday.Rows(i).Copy Destination:=wsDest.Rows(j)
                j = j + 1
            End If
        Next i
        
        ' Insert a row to signify new data
        wsDest.Cells(j, 1).value = "New Data Below"
        j = j + 1
        
        ' Copy from today's data source
        For i = 2 To lastRowToday
            If wsToday.Cells(i, "D").value = value Then
                wsToday.Rows(i).Copy Destination:=wsDest.Rows(j)
                j = j + 1
            End If
        Next i
        
        ' Autofit columns for the entire sheet
        wsDest.Columns.AutoFit
        
        ' VLOOKUP to check for "ID" in "DNR"
        Dim lastRowDest As Long
        lastRowDest = wsDest.Cells(wsDest.Rows.Count, "B").End(xlUp).Row
        wsDest.Range(wsDest.Cells(2, lastCol + 1), wsDest.Cells(lastRowDest, lastCol + 1)).Formula = _
        "=IF(ISNA(VLOOKUP(B2, '" & wsDNR.Name & "'!B:B, 1, FALSE)), ""No"", ""Yes"")"
        
        ' VLOOKUP to check for HS/VA Attribute from "FSA"
        wsDest.Range(wsDest.Cells(2, lastCol + 2), wsDest.Cells(lastRowDest, lastCol + 2)).Formula = _
        "=VLOOKUP(B2, '" & wsFSA.Name & "'!B:E, 4, FALSE)"
        
        ' Add conditional formatting for duplicates in Column B ("ID")
        With wsDest.Range("B2:B" & lastRowDest)
            .FormatConditions.Add Type:=xlExpression, Formula1:="=COUNTIF($B$2:$B$" & lastRowDest & ", B2)>1"
            .FormatConditions(.FormatConditions.Count).Interior.Color = 13551615 ' Light pink
        End With
        
        ' Add conditional formatting for negative values in Column F ("Balance")
        With wsDest.Range("F2:F" & lastRowDest)
            .FormatConditions.Add Type:=xlExpression, Formula1:="=F2<0"
            .FormatConditions(.FormatConditions.Count).Interior.Color = RGB(144, 238, 144)  ' Light green
        End With

    Next value
    
    MsgBox "Sheets created and data appended for each term!" & vbCrLf & vbCrLf & _
           "If ID is not a duplicate (not highlighted red) and Balance is less than 0 (highlighted green) " & vbCrLf & vbCrLf & _
           "Research the account in TSAAREV and find why there is now a Credit on the account.            " & VBA.String$(25, 32), vbInformation, "Daily Recon ran, research necessary accounts."
End Sub

