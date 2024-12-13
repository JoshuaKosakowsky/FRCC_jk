Sub D4C()

    Dim wsD4C As Worksheet, wsAmtTermSID As Worksheet, wsNonPymt As Worksheet, wsFSA As Worksheet
    Dim lastRow As Long, filteredData As Range, studentData As Range
    Dim newWorkbook As Workbook, studentWorkbook As Workbook
    Dim currentWorkbookPath As String
    Dim savePathCashiers As String, savePathStudents As String
    Dim newSheet As Worksheet, studentSheet As Worksheet
    Dim todayDate As String

    ' Set worksheet references
    Set wsD4C = ThisWorkbook.Sheets("D4C")
    Set wsAmtTermSID = ThisWorkbook.Sheets("AmtTermSID")
    Set wsNonPymt = ThisWorkbook.Sheets("NonPymt")
    Set wsFSA = ThisWorkbook.Sheets("FSA")
    
    ' Get today's date in MM-dd-YY format
    todayDate = Format(Date, "MM-dd-YY")
    
    ' Step 1: Auto unmerge and autofit height and width for all sheets
    Dim ws As Worksheet
    For Each ws In ThisWorkbook.Sheets
        ws.Cells.UnMerge
        ws.Cells.EntireColumn.AutoFit
        ws.Cells.EntireRow.AutoFit
    Next ws

    ' Step 2: Clear the D4C sheet to prepare for new data
    wsD4C.Cells.ClearContents

    ' Step 3: Copy data from AmtTermSID (starting from row 8 to exclude headers)
    With wsAmtTermSID
        lastRow = .Cells(.Rows.Count, "C").End(xlUp).Row ' Find the last row with data in Column C
        .Range("C8:D" & lastRow).Copy ' Skip rows 1-7
    End With
    wsD4C.Range("A2").PasteSpecial Paste:=xlPasteValues ' Paste values into D4C starting at row 2

    ' Step 4: Remove any blank rows in D4C (Columns A and B)
    lastRow = wsD4C.Cells(wsD4C.Rows.Count, "A").End(xlUp).Row ' Find the last row in Column A
    Dim i As Long
    For i = lastRow To 2 Step -1
        If wsD4C.Cells(i, "A").Value = "" And wsD4C.Cells(i, "B").Value = "" Then
            wsD4C.Rows(i).Delete
        End If
    Next i

    ' Step 5: Add VLOOKUP formula for "Phone No." in Column C
    lastRow = wsD4C.Cells(wsD4C.Rows.Count, "A").End(xlUp).Row ' Recalculate last row in Column A
    wsD4C.Range("C2:C" & lastRow).Formula = "=IFERROR(VLOOKUP(A2,NonPymt!D:E,2,FALSE),""Number Not Listed"")"

    ' Step 6: Add VLOOKUP formula for "NonPayment" in Column D
    wsD4C.Range("D2:D" & lastRow).Formula = "=VLOOKUP(A2,NonPymt!D:N,11,FALSE)"

    ' Step 7: Delete Row 1 and shift rows up
    wsD4C.Rows(1).Delete

    ' Step 8: Copy C1 and D1 and paste as values
    wsD4C.Range("C1").Value = wsD4C.Range("C1").Value ' Paste C1 as value
    wsD4C.Range("D1").Value = wsD4C.Range("D1").Value ' Paste D1 as value

    ' Step 9: Add "Attribute" header in Column E
    wsD4C.Range("E1").Value = "Attribute"

    ' Step 10: Add VLOOKUP formula for "Attribute" in Column E
    wsD4C.Range("E2:E" & lastRow).Formula = "=IFERROR(VLOOKUP(A2,FSA!B:E,4,FALSE),""None"")"

    ' Step 11: Add "Amt>500" header in Column F
    wsD4C.Range("F1").Value = "Amt>500"

    ' Step 12: Add formula for "Amt>500" in Column F
    wsD4C.Range("F2:F" & lastRow).Formula = "=IF(D2>500,""TRUE"",""FALSE"")"

    ' Step 13: Enable filtering for all rows
    wsD4C.Rows(1).AutoFilter

    ' Step 14: Apply filters to "Amt>500" and "Attribute"
    wsD4C.AutoFilterMode = False ' Clear any existing filters
    wsD4C.Rows(1).AutoFilter Field:=5, Criteria1:="None" ' Filter Attribute (Column E) for "None"
    wsD4C.Rows(1).AutoFilter Field:=6, Criteria1:="TRUE" ' Filter Amt>500 (Column F) for "TRUE"

    ' Step 15: Copy filtered data for Cashiers (Columns A:D)
    On Error Resume Next
    Set filteredData = wsD4C.Range("A1:D" & lastRow).SpecialCells(xlCellTypeVisible)
    On Error GoTo 0

    ' Step 16: Create a new workbook and paste data for Cashiers
    If Not filteredData Is Nothing Then
        Set newWorkbook = Workbooks.Add
        Set newSheet = newWorkbook.Sheets(1)
        filteredData.Copy
        newSheet.Range("A1").PasteSpecial Paste:=xlPasteValues
        
        ' Format Column D as Accounting
        newSheet.Columns("D").NumberFormat = "$#,##0.00"
        
        ' Autofit height and width
        newSheet.Cells.EntireColumn.AutoFit
        newSheet.Cells.EntireRow.AutoFit
        
        ' Save the new workbook for Cashiers
        currentWorkbookPath = ThisWorkbook.Path
        savePathCashiers = currentWorkbookPath & "\D4C Cashiers " & todayDate & ".xlsx"
        Application.DisplayAlerts = False ' Suppress overwrite warning
        newWorkbook.SaveAs Filename:=savePathCashiers, FileFormat:=xlOpenXMLWorkbook
        Application.DisplayAlerts = True
    End If

    ' Step 17: Copy filtered data for Students (Columns A:B)
    On Error Resume Next
    Set studentData = wsD4C.Range("A1:B" & lastRow).SpecialCells(xlCellTypeVisible)
    On Error GoTo 0

    ' Step 18: Create a new workbook and paste data for Students
    If Not studentData Is Nothing Then
        Set studentWorkbook = Workbooks.Add
        Set studentSheet = studentWorkbook.Sheets(1)
        studentData.Copy
        studentSheet.Range("A1").PasteSpecial Paste:=xlPasteValues
        
        ' Autofit height and width
        studentSheet.Cells.EntireColumn.AutoFit
        studentSheet.Cells.EntireRow.AutoFit
        
        ' Save the new workbook for Students
        savePathStudents = currentWorkbookPath & "\D4C Students " & todayDate & ".xlsx"
        Application.DisplayAlerts = False ' Suppress overwrite warning
        studentWorkbook.SaveAs Filename:=savePathStudents, FileFormat:=xlOpenXMLWorkbook
        Application.DisplayAlerts = True
    End If

    MsgBox "Files created successfully:" & vbCrLf & _
           "'D4C Cashiers " & todayDate & ".xlsx'" & vbCrLf & _
           "'D4C Students " & todayDate & ".xlsx'", vbInformation

End Sub
