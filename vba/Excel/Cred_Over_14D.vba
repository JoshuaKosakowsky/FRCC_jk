Sub Cred_Over_14D()

    ' DOES NOT WORK WITH SHORTCUT KEYS, MUST GO TO DEVELOPER TAB

    ' Define variables
    Dim wb As Workbook
    Dim ws As Worksheet
    Dim lastRow As Long
    Dim wbNetwork As Workbook
    Dim wsNetwork As Worksheet
    Dim wsDNR As Worksheet
    Dim wsRemoveDNR As Worksheet
    Dim Path As String
    Dim destWb As Workbook
    
    ' Set workbook and worksheet Page1
    Set destWb = ActiveWorkbook ' This refers to the workbook where the macro is being used
    Set ws = destWb.Sheets("Page1")
    
    ' Find the last row with data in column C (ID column)
    lastRow = ws.Cells(ws.Rows.Count, 3).End(xlUp).Row
    
    ' Add "DNR" header in column J
    ws.Cells(2, 10).Value = "DNR"
    
    ' Add "Notes" header in column K
    ws.Cells(2, 11).Value = "Notes"
    
    ' Folder path to DNR excel file
    Path = "C:\Users\" & Environ("USERNAME") & "\OneDrive - Colorado Community College System\Refunds\Auto and Manual Refunds\Reversals- DO NOT REFUND PA.xlsx"
    
    ' Path = "C:\Users\S03112819\OneDrive - Colorado Community College System\Refunds\Auto and Manual Refunds\Reversals- DO NOT REFUND PA.xlsx"
    
    ' Open the DNR file and set source worksheet
    Set wbNetwork = Workbooks.Open(Path)
    Set wsNetwork = wbNetwork.Sheets("DNR List")
    
    ' Ensure "DNR" sheet exists in the active workbook
    On Error Resume Next
    Set wsDNR = destWb.Sheets("DNR")
    
    If wsDNR Is Nothing Then
        ' Create the "DNR" sheet if it doesn't exist
        Set wsDNR = destWb.Sheets.Add(After:=destWb.Sheets(destWb.Sheets.Count))
        wsDNR.Name = "DNR"
    End If
    
    On Error GoTo 0
    
    ' Clear existing contents in the "DNR" sheet
    wsDNR.Cells.Clear
    
    ' Copy data from the DNR List and paste into the new DNR sheet as values
    wsNetwork.UsedRange.Copy
    wsDNR.Cells(1, 1).PasteSpecial Paste:=xlPasteValues
    
    ' Autofit the row heights and column widths in the DNR sheet
    wsDNR.Cells.EntireRow.AutoFit
    wsDNR.Cells.EntireColumn.AutoFit
    
    ' Ensure Clipboard is cleared after pasting
    Application.CutCopyMode = False
    
    ' Close the external workbook without saving changes
    wbNetwork.Close SaveChanges:=False
    
    ' Add VLOOKUP formula in the DNR column for each row
    For i = 3 To lastRow
        ws.Cells(i, 10).Formula = "=VLOOKUP(C" & i & ",DNR!C:F,4,FALSE)"
    Next i

    ' Unmerge all cells in Page1
    ws.Cells.UnMerge
    
    ' Apply autofilter to the headers (row 2)
    ws.Rows(2).AutoFilter
    
    ' Filter column I ("Days Old") for values >= 14
    ws.AutoFilterMode = False
    ws.Rows(2).AutoFilter Field:=9, Criteria1:=">=14"
    
    ' Filter the "DNR" column (J) to show only #N/A
    ws.Rows(2).AutoFilter Field:=10, Criteria1:="#N/A"
    
    ' Create the "Remove DNR" sheet if it doesn't exist
    On Error Resume Next
    Set wsRemoveDNR = destWb.Sheets("Remove DNR")
    
    If wsRemoveDNR Is Nothing Then
        ' Create the "Remove DNR" sheet
        Set wsRemoveDNR = destWb.Sheets.Add(After:=destWb.Sheets(destWb.Sheets.Count))
        wsRemoveDNR.Name = "Remove DNR"
    End If
    
    On Error GoTo 0
    
    ' Clear existing contents in the "Remove DNR" sheet
    wsRemoveDNR.Cells.Clear
    
    ' Copy columns C, D, E, and F from DNR to Remove DNR
    wsDNR.Range("C:F").Copy
    wsRemoveDNR.Cells(1, 1).PasteSpecial Paste:=xlPasteValues
    
    ' Add headers in the Remove DNR sheet
    wsRemoveDNR.Cells(1, 5).Value = "DNR =/= Credit"
    wsRemoveDNR.Cells(1, 6).Value = "Notes"
    
    ' Add COUNTIF formula in column E to check for matches in Page1!C:C
    lastRow = wsRemoveDNR.Cells(wsRemoveDNR.Rows.Count, 1).End(xlUp).Row
    For i = 2 To lastRow
        wsRemoveDNR.Cells(i, 5).Formula = "=COUNTIF(Page1!C:C, A" & i & ")"
    Next i
    
    ' Apply filter to show only rows where column E = 1
    wsRemoveDNR.Rows(1).AutoFilter Field:=5, Criteria1:="=0"
    
    ' Autofit the entire Remove DNR sheet
    wsRemoveDNR.Cells.EntireRow.AutoFit
    wsRemoveDNR.Cells.EntireColumn.AutoFit
    
    ' Activate Page1 sheet
    ws.Activate
    
    ' Inform the user that the task is complete
    MsgBox "Macro completed successfully." & vbNewLine & "investigate accounts over 14 days and not on DNR (Info from Page 1)" & vbNewLine & "Investigate accounts that are on the DNR but not the Net Credit Report (Info from Remove DNR where Column E = 0)", vbInformation
    
End Sub
