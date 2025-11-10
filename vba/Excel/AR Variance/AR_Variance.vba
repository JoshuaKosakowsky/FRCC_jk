Sub AR_Variance()
    Dim wsCurrent As Worksheet
    Dim wsPrior As Worksheet
    Dim wsVariance As Worksheet
    Dim todayDate As Date
    Dim fiscalStartMonth As Integer
    Dim fiscalPeriod As Integer
    Dim priorFiscalPeriod As Integer
    Dim adjustedDate As Date
    Dim currentDay As Integer
    Dim priorPeriodData As Range
    Dim currentPeriodData As Range
    Dim currentLastRow As Long
    Dim varianceLastRow As Long
    Dim lastRowPrior As Long
    Dim lastRowCurrent As Long
    Dim pivotCache As pivotCache
    Dim pivotTable As pivotTable
    Dim pivotTableName As String
    Dim pivotStartCell As Range
    Dim pivotRange As Range
    Dim lastRowR As Long
    Dim i As Long

    ' Define FRCC's FY Start Month
    fiscalStartMonth = 7

    ' Use the current date for calculations
    todayDate = Date ' Default: current system date

    ' Get the current day of the month
    currentDay = Day(todayDate)

    ' Adjust the date for fiscal period calculation
    If currentDay <= 14 Then
        ' If today is between the 1st and 14th, consider the previous month
        If Month(todayDate) = 1 Then
            ' Handle January edge case
            adjustedDate = DateSerial(Year(todayDate) - 1, 12, 1)
        Else
            adjustedDate = DateSerial(Year(todayDate), Month(todayDate) - 1, 1)
        End If
    Else
        ' Otherwise, use the current month
        adjustedDate = DateSerial(Year(todayDate), Month(todayDate), 1)
    End If

    ' Calculate the Current Fiscal Period
    If Month(adjustedDate) >= fiscalStartMonth Then
        fiscalPeriod = ((Month(adjustedDate) - fiscalStartMonth + 12) Mod 12) + 1
    Else
        fiscalPeriod = ((Month(adjustedDate) - fiscalStartMonth + 12 + 12) Mod 12) + 1
    End If

    ' Determine the Prior Fiscal Period
    priorFiscalPeriod = fiscalPeriod - 1
    If priorFiscalPeriod = 0 Then
        priorFiscalPeriod = 12
    End If

    ' Find sheets
    On Error Resume Next
    Set wsCurrent = Worksheets("Current Period")
    Set wsPrior = Worksheets("Prior Period")
    Set wsVariance = Worksheets("Variance")
    On Error GoTo 0

    ' Validate sheets exist
    If wsCurrent Is Nothing Or wsPrior Is Nothing Or wsVariance Is Nothing Then
        MsgBox "One or more sheets ('Current Period', 'Prior Period', 'Variance') are missing.", vbExclamation
        Exit Sub
    End If

    ' Rename sheets
    wsCurrent.Name = "Period " & fiscalPeriod
    wsPrior.Name = "Period " & priorFiscalPeriod

    ' Identify the last row in the Variance sheet
    varianceLastRow = wsVariance.Cells(wsVariance.Rows.Count, "A").End(xlUp).Row + 1

    ' Copy Prior Period data (exclude header row)
    With wsPrior
        ' Identify range (exclude first 10 rows, header row, and column A)
        Set priorPeriodData = .Range("B12", .Cells(.Rows.Count, "I").End(xlUp))
        
        ' Copy data to Variance starting at the next available row
        priorPeriodData.Copy wsVariance.Cells(varianceLastRow, 1)
        
        ' Add the period number to the last column (Column I)
        lastRowPrior = varianceLastRow + priorPeriodData.Rows.Count - 1
        wsVariance.Range("I" & varianceLastRow & ":I" & lastRowPrior).Value = priorFiscalPeriod
    End With

    ' Update the last row in the Variance sheet
    varianceLastRow = wsVariance.Cells(wsVariance.Rows.Count, "A").End(xlUp).Row + 1

    ' Copy Current Period data (exclude header row and last two rows)
    With wsCurrent
        ' Identify range (exclude first 10 rows, header row, and last two rows)
        currentLastRow = .Cells(.Rows.Count, "A").End(xlUp).Row
        Set currentPeriodData = .Range("B12", .Cells(currentLastRow - 2, "I"))
        
        ' Append data to Variance starting at the next available row
        currentPeriodData.Copy wsVariance.Cells(varianceLastRow, 1)
        
        ' Add the period number to the last column (Column I)
        lastRowCurrent = varianceLastRow + currentPeriodData.Rows.Count - 1
        wsVariance.Range("I" & varianceLastRow & ":I" & lastRowCurrent).Value = fiscalPeriod
    End With

    ' Autofit columns for better readability
    wsVariance.Columns.AutoFit

    ' Create Pivot Table
    pivotTableName = "VariancePivot"
    Set pivotStartCell = wsVariance.Range("K1")
    
    ' Define PivotCache
    Set pivotCache = ThisWorkbook.PivotCaches.Create( _
        SourceType:=xlDatabase, _
        SourceData:=wsVariance.Range("A1:I" & lastRowCurrent))
    
    ' Clear existing PivotTable if it exists
    On Error Resume Next
    wsVariance.PivotTables(pivotTableName).TableRange2.Clear
    On Error GoTo 0
    
    ' Create the PivotTable
    Set pivotTable = pivotCache.CreatePivotTable( _
        TableDestination:=pivotStartCell, _
        TableName:=pivotTableName)
    
    ' Configure PivotTable fields
    With pivotTable
        ' Add rows: Fund and Acct
        .PivotFields("Fund").Orientation = xlRowField
        .PivotFields("Acct").Orientation = xlRowField
        
        ' Add columns: Period
        .PivotFields("Period").Orientation = xlColumnField
        
        ' Add values: Sum of Current_Yr_Balance
        With .PivotFields("Current_Yr_Balance")
            .Orientation = xlDataField
            .Function = xlSum
            .Name = "Sum of Current_Yr_Balance"
        End With
        
        ' Configure Subtotals & Filters for Fund and Acct
        .PivotFields("Fund").Subtotals = Array(False, False, False, False, False, False, False, False, False, False, False, False)
        .PivotFields("Acct").Subtotals = Array(False, False, False, False, False, False, False, False, False, False, False, False)
        
        ' Set Layout and Print settings for Fund and Acct
        .PivotFields("Fund").LayoutForm = xlTabular
        .PivotFields("Acct").LayoutForm = xlTabular
    End With

    ' Copy Pivot Table and Paste as Values in R1
    Set pivotRange = pivotTable.TableRange2
    pivotRange.Copy
    wsVariance.Range("R1").PasteSpecial Paste:=xlPasteValues

    ' Rename headers and clear unnecessary cells
    With wsVariance
        .Range("R1").Value = "A/R Variance Analysis"
        .Range("S1:V1").ClearContents
        .Range("R2").Value = "Fund"
        .Range("S2").Value = "Acct"
        .Range("T2").Value = "Period " & priorFiscalPeriod
        .Range("U2").Value = "Period " & fiscalPeriod
        .Range("W2").Value = "Difference"
        .Range("X2").Value = "Percent"
        .Range("Y2").Value = "Review (Over $100K & 100%): Debits should be clearing and decreasing"
    End With

    ' Data Cleanup: Fill blank cells in column R with the value above, preserving leading zeros
    lastRowR = wsVariance.Cells(wsVariance.Rows.Count, "R").End(xlUp).Row
    For i = 3 To lastRowR ' Start from row 3 to avoid overwriting headers
        If IsEmpty(wsVariance.Cells(i, "R").Value) Then
            ' Fill blank cell with the value from the row above
            wsVariance.Cells(i, "R").Value = wsVariance.Cells(i - 1, "R").Value
        End If
        
        ' Preserve leading zeros by formatting as text and explicitly formatting as 6-digit text
         If Len(wsVariance.Cells(i, "R").Value) > 0 And IsNumeric(wsVariance.Cells(i, "R").Value) Then
            wsVariance.Cells(i, "R").NumberFormat = "@"
            wsVariance.Cells(i, "R").Value = Format(wsVariance.Cells(i, "R").Value, "000000")
        End If
    Next i

    ' Add formulas for Difference and Percent columns
    For i = 3 To lastRowR
        wsVariance.Cells(i, "W").Formula = "=T" & i & "-U" & i
        wsVariance.Cells(i, "X").Formula = "=IFERROR(1-(T" & i & "/U" & i & "),0)"
    Next i

    ' Apply filter to rows R2-Y2 based on criteria
    With wsVariance
        ' Apply filter to the range R2:Y2
        .Range("R2:Y" & lastRowR).AutoFilter Field:=6, Criteria1:=">=100000", Operator:=xlOr, Criteria2:="<=-100000" ' Filter for Difference column (W)
        .Range("R2:Y" & lastRowR).AutoFilter Field:=7, Criteria1:=">=1", Operator:=xlOr, Criteria2:="<-1" ' Filter for Percent column (X)
    End With

    ' Loop through visible rows and create new worksheets
    Dim rngVis As Range, rw As Range
    Dim fundValue As String, acctValue As String
    Dim newSheetName As String
    Dim NewSheet As Worksheet, lastSheet As Worksheet
    
    Set lastSheet = wsVariance
    
    On Error Resume Next
    Set rngVis = wsVariance.AutoFilter.Range.SpecialCells(xlCellTypeVisible)
    On Error GoTo 0
    If rngVis Is Nothing Then Exit Sub  ' nothing visible after filters
    
    ' === Visual polish for the header area (R:Y) ===
    With wsVariance
        .Range("R1:Y2").Font.Bold = True
        .Range("R1:Y2").Interior.Color = RGB(221, 235, 247) ' light blue
        .Columns("R:Y").AutoFit
    End With
    
    ' === Notes and signature section in column U ===
    Dim rStart As Long, r1 As Long, r2 As Long, rPrep As Long, rRev As Long
    
    ' lastRowR should already be defined earlier in your macro
    ' Place first note with one blank row after the data
    rStart = lastRowR + 2
    r1 = rStart                       ' first note
    r2 = r1 + 2                       ' second note (one blank line below first)
    rPrep = r2 + 3                    ' "Prepared By:" (two blank lines below second note)
    rRev = rPrep + 5                  ' "Reviewed By:" (five blank lines below "Prepared By:")
    
    With wsVariance
        ' Notes
        .Range("U" & r1).Value = " * Reconciliation between periods using COGNOS Balance Sheet with Audit Trail. See Excel workbook for account details"
        .Range("U" & r2).Value = " ** Excel workbook contains FGIGLAC extract for specific account details"
    
        ' Labels
        .Range("U" & rPrep).Value = " Prepared By:"
        .Range("U" & rRev).Value = " Reviewed By:"
    
        ' Signature lines across V:Y (bottom border looks like a signature line)
        With .Range("V" & rPrep & ":Y" & rPrep).Borders(xlEdgeBottom)
            .LineStyle = xlContinuous
            .Weight = xlThin
            .Color = RGB(0, 0, 0)
        End With
        With .Range("V" & rRev & ":Y" & rRev).Borders(xlEdgeBottom)
            .LineStyle = xlContinuous
            .Weight = xlThin
            .Color = RGB(0, 0, 0)
        End With

    End With
    
    For Each rw In rngVis.Rows
        If rw.Row > 2 Then ' skip header row
            ' First 2 columns of the filtered block correspond to R (Fund) and S (Acct)
            fundValue = Trim$(CStr(rw.Columns(1).Value))
            acctValue = Trim$(CStr(rw.Columns(2).Value))
    
            ' pad Fund to 6 if numeric; keep leading zeros
            If Len(fundValue) > 0 And IsNumeric(fundValue) Then
                fundValue = Format$(CLng(fundValue), "000000")
            End If
    
            If fundValue = "" Then fundValue = "NoFund"
            If acctValue = "" Then acctValue = "NoAcct"
    
            ' sanitize sheet name
            newSheetName = fundValue & "_" & acctValue
            newSheetName = Replace(Replace(Replace(Replace(Replace(Replace(newSheetName, ":", "_"), "/", "_"), "\", "_"), "?", "_"), "[", "_"), "]", "_")
            newSheetName = Left$(newSheetName, 31)
    
            Debug.Print "Row " & rw.Row & ": Creating sheet " & newSheetName
    
            On Error Resume Next
            Set NewSheet = Worksheets.Add(After:=lastSheet)
            NewSheet.Name = newSheetName
            If Err.Number <> 0 Then
                ' name collision: append a counter
                Err.Clear
                NewSheet.Name = Left$(newSheetName, 28) & "_" & CStr(Worksheets.Count)
            End If
            On Error GoTo 0
    
            Set lastSheet = NewSheet
        End If
    Next rw

With wsVariance
    .Activate
    .Range("R1").Select
End With

End Sub

