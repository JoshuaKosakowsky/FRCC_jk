Sub Student_Payment_Agreement()
'
' Student_Payment_Agreement Macro
'

'
    Cells.Select
    Selection.UnMerge
    Rows("1:6").Select
    Selection.Delete Shift:=xlUp
    Range("U1").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 15066599
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Color = -4144960
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Color = -4144960
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlInsideVertical).LineStyle = xlNone
    Selection.Borders(xlInsideHorizontal).LineStyle = xlNone
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlTop
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    ActiveCell.FormulaR1C1 = "Y in K-T"
    Range("U2").Select
    ActiveCell.FormulaR1C1 = "=IF(COUNTIF(RC[-10]:RC[-1],""Y"")>0,""Y"",""N"")"
    Range("U2").Select
    Selection.AutoFill Destination:=Range("U2:U7879")
    Range("U2:U7879").Select
    Range("K2").Select
    Range(Selection, Selection.End(xlToRight)).Select
    Range(Selection, Selection.End(xlDown)).Select
    Selection.FormatConditions.Add Type:=xlTextString, String:="Y", _
        TextOperator:=xlContains
    Selection.FormatConditions(Selection.FormatConditions.Count).SetFirstPriority
    With Selection.FormatConditions(1).Font
        .Color = -16383844
        .TintAndShade = 0
    End With
    With Selection.FormatConditions(1).Interior
        .PatternColorIndex = xlAutomatic
        .Color = 13551615
        .TintAndShade = 0
    End With
    Selection.FormatConditions(1).StopIfTrue = False
    Range("A1:U7879").Select
    Range("K2").Activate
    Selection.AutoFilter
    ActiveWindow.SmallScroll Down:=-24
    ActiveSheet.Range("$A$1:$U$7879").AutoFilter Field:=9, Criteria1:="N/A"
    ActiveSheet.Range("$A$1:$U$7879").AutoFilter Field:=8, Criteria1:= _
        ">=500.00", Operator:=xlAnd
    ActiveSheet.Range("$A$1:$U$7879").AutoFilter Field:=21, Criteria1:="Y"
    Selection.Copy
    Sheets.Add After:=ActiveSheet
    Sheets("Sheet1").Select
    Sheets("Sheet1").Name = "HS"
    Range("A1").Select
    Application.CutCopyMode = False
    Sheets("Page1").Select
    Selection.Copy
    Sheets("HS").Select
    Range("A1").Select
    ActiveSheet.Paste
    Cells.Select
    Selection.Columns.AutoFit
    Columns("A:A").Select
    Selection.EntireColumn.Hidden = True
    ActiveWindow.Zoom = 115
    ActiveWindow.Zoom = 130
    ActiveWindow.Zoom = 145
    ActiveWindow.SmallScroll Down:=-18
    Columns("D:D").Select
    Selection.EntireColumn.Hidden = True
    Sheets("Page1").Select
    Application.CutCopyMode = False
    ActiveSheet.Range("$A$1:$U$7879").AutoFilter Field:=21, Criteria1:="N"
    Selection.Copy
    Sheets.Add After:=ActiveSheet
    ActiveSheet.Paste
    Sheets("Sheet2").Select
    Sheets("Sheet2").Name = "Regular"
    Cells.Select
    Application.CutCopyMode = False
    ActiveCell.FormulaR1C1 = "hoi"
    Range("A1:U157").Select
    Range("D2").Activate
    Selection.Columns.AutoFit
    Range("A:A,D:D").Select
    Range("D1").Activate
    Selection.EntireColumn.Hidden = True
    ActiveWindow.Zoom = 115
    ActiveWindow.Zoom = 130
    ActiveWindow.Zoom = 145
    ActiveWindow.Zoom = 130
    ActiveWorkbook.Save
End Sub


