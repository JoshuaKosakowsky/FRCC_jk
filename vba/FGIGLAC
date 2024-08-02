Sub FGIGLAC()
'
' FGIGLAC Macro
'

'
    Cells.Select
    Selection.UnMerge
    Rows("1:2").Select
    Selection.Delete Shift:=xlUp
    Columns("B:B").Select
    Selection.Replace What:=" *", Replacement:="", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, _
        ReplaceFormat:=False
    Selection.NumberFormat = "m/d/yyyy"
    Columns("G:G").Select
    Selection.Replace What:="C", Replacement:="Credit", LookAt:=xlWhole, _
        SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, _
        ReplaceFormat:=False
    Selection.Replace What:="D", Replacement:="Debit", LookAt:=xlWhole, _
        SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, _
        ReplaceFormat:=False
    Range("H2").Select
    ActiveCell.FormulaR1C1 = "=IF(RC[-1]=""credit"",-RC[-2],RC[-2])"
    Range("H2").Select
    Selection.AutoFill Destination:=Range("H2:H" & Range("E" & Rows.Count).End(xlUp).Row)
    Range(Selection, Selection.End(xlDown)).Select
    Range("H1").Select
    ActiveCell.FormulaR1C1 = "Amt"
    Columns("H:H").Select
    Selection.Copy
    Columns("F:F").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Columns("H:H").Select
    Application.CutCopyMode = False
    Selection.Delete Shift:=xlToLeft
    Columns("F:F").Select
    Selection.NumberFormat = "_($* #,##0.00_);_($* (#,##0.00);_($* ""-""??_);_(@_)"
    Cells.Select
    ActiveWorkbook.ActiveSheet.Sort.SortFields. _
        Clear
    ActiveWorkbook.ActiveSheet.Sort.SortFields. _
        Add2 Key:=Range("B2:B" & Range("E" & Rows.Count).End(xlUp).Row)
    Range(Selection, Selection.End(xlDown)).Select
    With ActiveWorkbook.ActiveSheet.Sort
        .SetRange Range("A1:H" & Range("E" & Rows.Count).End(xlUp).Row)
    Range(Selection, Selection.End(xlDown)).Select
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
    Range("A1").Select
    
        Columns("B:B").Select
    Selection.Replace What:=",", Replacement:="", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, _
        ReplaceFormat:=False
    Cells.Select
    ActiveWorkbook.ActiveSheet.Sort.SortFields.Clear
    ActiveWorkbook.ActiveSheet.Sort.SortFields.Add2 Key:=Range("B2:B" & Range("E" & Rows.Count).End(xlUp).Row)
    Range(Selection, Selection.End(xlDown)).Select
    With ActiveWorkbook.ActiveSheet.Sort
        .SetRange Range("A1:H" & Range("E" & Rows.Count).End(xlUp).Row)
    Range(Selection, Selection.End(xlDown)).Select
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
    Columns("B:B").Select
    Columns("B:B").EntireColumn.AutoFit
    Range("A1").Select
End Sub
Sub ARVariance()
'
' ARVariance Macro
'

'
    Application.CutCopyMode = False
    Application.CutCopyMode = False
    ActiveWorkbook.PivotCaches.Create(SourceType:=xlDatabase, SourceData:= _
        "Variance!R1C1:R1048576C9", Version:=6).CreatePivotTable TableDestination:= _
        "Variance!R2C11", TableName:="PivotTable33", DefaultVersion:=6
    Sheets("Variance").Select
    Cells(2, 11).Select
    With ActiveSheet.PivotTables("PivotTable33")
        .ColumnGrand = True
        .HasAutoFormat = True
        .DisplayErrorString = False
        .DisplayNullString = True
        .EnableDrilldown = True
        .ErrorString = ""
        .MergeLabels = False
        .NullString = ""
        .PageFieldOrder = 2
        .PageFieldWrapCount = 0
        .PreserveFormatting = True
        .RowGrand = True
        .SaveData = True
        .PrintTitles = False
        .RepeatItemsOnEachPrintedPage = True
        .TotalsAnnotation = False
        .CompactRowIndent = 1
        .InGridDropZones = False
        .DisplayFieldCaptions = True
        .DisplayMemberPropertyTooltips = False
        .DisplayContextTooltips = True
        .ShowDrillIndicators = True
        .PrintDrillIndicators = False
        .AllowMultipleFilters = False
        .SortUsingCustomLists = True
        .FieldListSortAscending = False
        .ShowValuesRow = False
        .CalculatedMembersInFilters = False
        .RowAxisLayout xlCompactRow
    End With
    With ActiveSheet.PivotTables("PivotTable33").PivotCache
        .RefreshOnFileOpen = False
        .MissingItemsLimit = xlMissingItemsDefault
    End With
    ActiveSheet.PivotTables("PivotTable33").RepeatAllLabels xlRepeatLabels
    ActiveWorkbook.ShowPivotTableFieldList = True
    With ActiveSheet.PivotTables("PivotTable33").PivotFields("Fund")
        .Orientation = xlRowField
        .Position = 1
    End With
    With ActiveSheet.PivotTables("PivotTable33").PivotFields("Acct")
        .Orientation = xlRowField
        .Position = 2
    End With
    ActiveSheet.PivotTables("PivotTable33").AddDataField ActiveSheet.PivotTables( _
        "PivotTable33").PivotFields("Current_Yr_Balance"), "Sum of Current_Yr_Balance" _
        , xlSum
    With ActiveSheet.PivotTables("PivotTable33").PivotFields("Period")
        .Orientation = xlColumnField
        .Position = 1
    End With
    ActiveSheet.PivotTables("PivotTable33").PivotFields("Fund").Subtotals = Array( _
        False, False, False, False, False, False, False, False, False, False, False, False)
    ActiveSheet.PivotTables("PivotTable33").PivotFields("Fund").RepeatLabels = True
    Range("M2").Select
    With ActiveSheet.PivotTables("PivotTable33")
        .InGridDropZones = True
        .RowAxisLayout xlTabularRow
    End With
    Columns("K:P").Select
    Selection.Copy
    Columns("R:R").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    ActiveWindow.ScrollColumn = 2
    ActiveWindow.ScrollColumn = 3
    Range("T2").Select
    Application.CutCopyMode = False
    Selection.ClearContents
    Range("T3").Select
    ActiveCell.FormulaR1C1 = "Period 10"
    Range("U3").Select
    ActiveCell.FormulaR1C1 = "Period 11"
    Columns("V:W").Select
    Selection.EntireColumn.Hidden = True
    Range("X3").Select
    ActiveCell.FormulaR1C1 = "Difference"
    Range("Y3").Select
    ActiveCell.FormulaR1C1 = "Percentage"
    Range("Z3").Select
    ActiveCell.FormulaR1C1 = _
        "Review (anything over 100% and 100,000 - debits should be clearing and decreasing)"
    Columns("Z:Z").Select
    Selection.ColumnWidth = 37.89
    ActiveWindow.SmallScroll ToRight:=7
    Selection.ColumnWidth = 78
    Selection.ColumnWidth = 85.22
    Columns("Y:Y").EntireColumn.AutoFit
    Columns("X:X").EntireColumn.AutoFit
    Range("R2").Select
    ActiveCell.FormulaR1C1 = "AR Variance Analysis"
    Range("R2:Z3").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent5
        .TintAndShade = 0.599993896298105
        .PatternTintAndShade = 0
    End With
    Selection.Font.Bold = True
    Range("X4").Select
    Application.CutCopyMode = False
    ActiveCell.FormulaR1C1 = "=RC[-4]-RC[-3]"
    Range("Y4").Select
    ActiveCell.FormulaR1C1 = "1-"
    Range("Y4").Select
    Application.CutCopyMode = False
    ActiveCell.FormulaR1C1 = "=1-RC[-5]/RC[-4]"
    Range("Y4").Select
    Selection.AutoFill Destination:=Range("Y4:Y130")
    Range("Y4:Y130").Select
    Range("X4").Select
    Selection.AutoFill Destination:=Range("X4:X130")
    Range("X4:X130").Select
    Columns("T:X").Select
    Selection.NumberFormat = "_($* #,##0.00_);_($* (#,##0.00);_($* ""-""??_);_(@_)"
    Columns("Y:Y").Select
    Selection.NumberFormat = "0.00%"
    Range("R3:Y3").Select
    Selection.AutoFilter
    ActiveWindow.ScrollColumn = 11
    ActiveWindow.ScrollColumn = 10
    ActiveWindow.ScrollColumn = 9
    ActiveWindow.ScrollColumn = 8
    ActiveWindow.ScrollColumn = 9
    Columns("K:P").Select
    Selection.EntireColumn.Hidden = True
    ActiveWindow.ScrollColumn = 8
    ActiveWindow.ScrollColumn = 7
    ActiveWindow.ScrollColumn = 6
    ActiveWindow.ScrollColumn = 5
    ActiveWindow.ScrollColumn = 4
    ActiveWindow.ScrollColumn = 3
    ActiveWindow.ScrollColumn = 2
    ActiveSheet.Range("$R$3:$Y$130").AutoFilter Field:=8, Criteria1:=">100%", _
        Operator:=xlOr, Criteria2:="<-100%"
    ActiveSheet.Range("$R$3:$Y$130").AutoFilter Field:=7, Criteria1:=">100,000" _
        , Operator:=xlOr, Criteria2:="<-100,000"
    Range("S135").Select
    ActiveCell.FormulaR1C1 = _
        "* Reconciliation between periods using COGNOS Balance Sheet with Audit Trail. See Excel workbook for account details"
    Range("S137").Select
    ActiveCell.FormulaR1C1 = _
        "** Excel workbook contains FGIGLAC extract for specific account details"
    Range("T140").Select
    ActiveCell.FormulaR1C1 = "Prepared By:"
    Range("U140:Y140").Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    Selection.Borders(xlEdgeLeft).LineStyle = xlNone
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlEdgeRight).LineStyle = xlNone
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    Range("T144").Select
    ActiveCell.FormulaR1C1 = "Reviewed By:"
    Range("U144:Y144").Select
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    Selection.Borders(xlEdgeLeft).LineStyle = xlNone
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    With Selection.Borders(xlEdgeBottom)
        .LineStyle = xlContinuous
        .ColorIndex = 0
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlEdgeRight).LineStyle = xlNone
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    ActiveWindow.SmallScroll Down:=-6
End Sub

