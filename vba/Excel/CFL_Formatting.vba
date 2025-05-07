Sub CFL_Formatting()
'
' CFL_Formatting Macro
'

'
    Rows("1:1").Select
    Selection.Delete Shift:=xlUp
    Selection.AutoFilter
    Range("A1").Select
    ActiveCell.FormulaR1C1 = "COLLEGE"
    Range("B1").Select
    ActiveCell.FormulaR1C1 = "TERM"
    Range("C1").Select
    ActiveCell.FormulaR1C1 = "CRN"
    Range("D1").Select
    ActiveCell.FormulaR1C1 = "SUBJECT"
    Range("E1").Select
    ActiveCell.FormulaR1C1 = "COURSE NUMBER"
    Range("F1").Select
    ActiveCell.FormulaR1C1 = "SECTION"
    Range("G1").Select
    ActiveCell.FormulaR1C1 = "CAMPUS"
    Range("U1").Select
    ActiveCell.FormulaR1C1 = "ATTRIBUTE"
    Range("V1").Select
    ActiveCell.FormulaR1C1 = "ACTIVITY DATE"
    Range("W1").Select
    ActiveCell.FormulaR1C1 = "DETAIL CODE"
    Range("Y1").Select
    ActiveCell.FormulaR1C1 = "FEE"
    Range("AA1").Select
    ActiveCell.FormulaR1C1 = "CODE TYPE"
    Rows("1:1").Select
    Selection.Font.Bold = True
    Cells.Select
    Selection.Columns.AutoFit
    Selection.Rows.AutoFit
    ActiveWindow.SmallScroll ToRight:=7
    Columns("H:T").Select
    Selection.EntireColumn.Hidden = True
    Columns("X:X").Select
    Selection.EntireColumn.Hidden = True
    Columns("Z:Z").Select
    Selection.EntireColumn.Hidden = True
    Columns("AB:AT").Select
    Selection.EntireColumn.Hidden = True
    ActiveWindow.ScrollColumn = 1
    Range(Selection, Selection.End(xlToLeft)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    Range(Selection, Selection.End(xlUp)).Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 15773696
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    Range("A3").Select
    Selection.Copy
    Range("A2").Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    ActiveWorkbook.Worksheets("gokoutp").Sort.SortFields.Clear
    ActiveWorkbook.Worksheets("gokoutp").Sort.SortFields.Add2 Key:=Range( _
        "D2:D7084"), SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:= _
        xlSortNormal
    ActiveWorkbook.Worksheets("gokoutp").Sort.SortFields.Add2 Key:=Range( _
        "E2:E7084"), SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:= _
        xlSortNormal
    ActiveWorkbook.Worksheets("gokoutp").Sort.SortFields.Add2 Key:=Range( _
        "F2:F7084"), SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:= _
        xlSortNormal
    ActiveWorkbook.Worksheets("gokoutp").Sort.SortFields.Add2 Key:=Range( _
        "G2:G7084"), SortOn:=xlSortOnValues, Order:=xlAscending, DataOption:= _
        xlSortNormal
    With ActiveWorkbook.Worksheets("gokoutp").Sort
        .SetRange Range("A1:AT7084")
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With
    ActiveWindow.Zoom = 115
    ActiveWindow.Zoom = 130
    ActiveWindow.SmallScroll Down:=-42
End Sub
