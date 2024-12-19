Sub TSAAREV_Balance()
    ' Add headers for Charges, Payments, Difference, and Total in AB1, AC1, AD1, and AE1
    Range("AB1").Value = "Balance Breakdown"
    Range("AC1").Value = "Charges"
    Range("AD1").Value = "Payments"
    Range("AE1").Value = "Difference"

    ' Set "Total" label in AB2
    Range("AB2").Value = "Total"

    ' Perform SUM functions in AC2 and AD2, and AC2 - AD2 in AE2
    Range("AC2").Formula = "=SUM(D:D)"
    Range("AD2").Formula = "=SUM(E:E)"
    Range("AE2").Formula = "=AC2-AD2"

    ' Format columns D, E, F, AC, AD, and AE to Accounting format, leaving AB as General
    Columns("D:E").NumberFormat = "_($* #,##0.00_);_($* (#,##0.00);_($* ""-""??_);_(@_)"
    Columns("F:F").NumberFormat = "_($* #,##0.00_);_($* (#,##0.00);_($* ""-""??_);_(@_)"
    Columns("AC:AE").NumberFormat = "_($* #,##0.00_);_($* (#,##0.00);_($* ""-""??_);_(@_)"

    ' Get unique values from Column C, sort them in descending order, and add them under "Total" in AB column
    Dim uniqueValues As Collection
    Set uniqueValues = New Collection
    Dim cell As Range
    Dim outputRow As Integer
    outputRow = 3 ' Start from row 3 under "Total"

    ' Loop through Column C to get unique values
    On Error Resume Next ' Ignore errors for duplicate entries
    For Each cell In Range("C2:C" & Cells(Rows.Count, "C").End(xlUp).Row)
        If cell.Value <> "" Then
            uniqueValues.Add cell.Value, CStr(cell.Value)
        End If
    Next cell
    On Error GoTo 0 ' Resume normal error handling

    ' Sort unique values in descending order using an array
    Dim uniqueArray() As Variant
    ReDim uniqueArray(1 To uniqueValues.Count)

    ' Copy items from Collection to Array
    Dim i As Integer, j As Integer
    For i = 1 To uniqueValues.Count
        uniqueArray(i) = uniqueValues(i)
    Next i

    ' Sort the array in descending order
    Dim temp As Variant
    For i = LBound(uniqueArray) To UBound(uniqueArray) - 1
        For j = i + 1 To UBound(uniqueArray)
            If uniqueArray(i) < uniqueArray(j) Then
                temp = uniqueArray(i)
                uniqueArray(i) = uniqueArray(j)
                uniqueArray(j) = temp
            End If
        Next j
    Next i

    ' Place unique values in Column AB starting from AB3
    For i = LBound(uniqueArray) To UBound(uniqueArray)
        Cells(outputRow, "AB").Value = uniqueArray(i)
        
        ' Insert SUMIF formulas in AC, AD, and calculate Difference in AE
        Cells(outputRow, "AC").Formula = "=SUMIF(C:C, AB" & outputRow & ", D:D)"
        Cells(outputRow, "AD").Formula = "=SUMIF(C:C, AB" & outputRow & ", E:E)"
        Cells(outputRow, "AE").Formula = "=AC" & outputRow & "-AD" & outputRow
        
        outputRow = outputRow + 1
    Next i

    ' Make headers bold for Charges, Payments, Difference, and Total
    Range("AB1:AE1").Font.Bold = True

    ' Autofit all columns near the end
    Cells.EntireColumn.AutoFit

    ' Finally, hide columns G to Z
    Columns("G:Z").EntireColumn.Hidden = True
End Sub
