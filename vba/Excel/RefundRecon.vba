
Sub Refund_Recon_Format()
'
' Refund_Recon_Format Macro
'

'
    Cells.Select
    Selection.UnMerge
    Sheets("Net Credit").Select
    Cells.Select
    Selection.UnMerge
    Rows("1:3").Select
    Selection.Delete Shift:=xlUp
    Sheets("CC Refunds").Select
    Cells.Select
    Selection.UnMerge
    Rows("1:1").Select
    Selection.Delete Shift:=xlUp
    Sheets("DNR").Select
    Cells.Select
    Selection.UnMerge
    Cells.EntireColumn.AutoFit
    Cells.EntireRow.AutoFit
    Sheets("Manual").Select
    Cells.Select
    Selection.UnMerge
    Cells.EntireColumn.AutoFit
    Cells.EntireRow.AutoFit
    Sheets("FA").Select
    Cells.Select
    Selection.UnMerge
    Sheets("HS").Select
    Cells.Select
    Selection.UnMerge
    Sheets("Net Credit").Select
    Range("G1").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 14865087
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Color = -4945056
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Color = -4945056
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
    ActiveCell.FormulaR1C1 = "DNR"
    Range("H1").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 14865087
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Color = -4945056
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Color = -4945056
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
    ActiveCell.FormulaR1C1 = "CC Refunds"
    Range("I1").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 14865087
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Color = -4945056
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Color = -4945056
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
    ActiveCell.FormulaR1C1 = "Manual"
    Range("J1").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 14865087
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Color = -4945056
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Color = -4945056
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
    ActiveCell.FormulaR1C1 = "TGACREV"
    Range("K1").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 14865087
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Color = -4945056
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Color = -4945056
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
    ActiveCell.FormulaR1C1 = "FA"
    Range("L1").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 14865087
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Color = -4945056
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Color = -4945056
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
    ActiveCell.FormulaR1C1 = "HS"
    Range("M1").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 14865087
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Color = -4945056
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Color = -4945056
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
    ActiveCell.FormulaR1C1 = "Difference"
    Range("N1").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 14865087
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    Selection.Borders(xlDiagonalDown).LineStyle = xlNone
    Selection.Borders(xlDiagonalUp).LineStyle = xlNone
    With Selection.Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Color = -4945056
        .TintAndShade = 0
        .Weight = xlMedium
    End With
    Selection.Borders(xlEdgeTop).LineStyle = xlNone
    Selection.Borders(xlEdgeBottom).LineStyle = xlNone
    With Selection.Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Color = -4945056
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
    ActiveCell.FormulaR1C1 = "Notes"
    Range("G2").Select
    ActiveCell.FormulaR1C1 = "=COUNTIF(DNR!C[-5],'Net Credit'!RC[-5])"
    Range("H2").Select
    ActiveCell.FormulaR1C1 = _
        "=SUMIF('CC Refunds'!C[-5],'Net Credit'!RC[-6],'CC Refunds'!C[3])"
    Range("I2").Select
    ActiveCell.FormulaR1C1 = "=COUNTIF(Manual!C[-7],'Net Credit'!RC[-7])"
    Range("J2").Select
    ActiveCell.FormulaR1C1 = _
        "=SUMIF(TGACREV!C[-5],'Net Credit'!RC[-8],TGACREV!C[-7])"
    Range("K2").Select
    ActiveCell.FormulaR1C1 = "=COUNTIF(FA!C[-10],'Net Credit'!RC[-9])"
    Range("L2").Select
    ActiveCell.FormulaR1C1 = "=VLOOKUP(RC[-10],HS!C[-10]:C[-7],4,FALSE)"
    Range("M2").Select
    Application.CutCopyMode = False
    ActiveCell.FormulaR1C1 = "=RC[-3]+RC[-7]"
    Range("G2:M2").Select
    Selection.AutoFill Destination:=Range("G2:M174")
    Range("G2:M174").Select
    Range("A1:N1").Select
    Selection.AutoFilter
    Cells.Select
    Cells.EntireColumn.AutoFit
    Sheets("TGACREV").Select
    Columns("I:S").Select
    Selection.Delete Shift:=xlToLeft
    Range("I1").Select
    ActiveCell.FormulaR1C1 = "DNR"
    Range("J1").Select
    ActiveCell.FormulaR1C1 = "Net Credit"
    Range("K1").Select
    ActiveCell.FormulaR1C1 = "CC Refunds"
    Range("L1").Select
    ActiveCell.FormulaR1C1 = "Difference"
    Range("M1").Select
    ActiveCell.FormulaR1C1 = "Notes"
    Range("I2").Select
    ActiveCell.FormulaR1C1 = "=COUNTIF(DNR!C[-7],TGACREV!RC[-4])"
    Range("J2").Select
    ActiveCell.FormulaR1C1 = _
        "=SUMIF('Net Credit'!C[-8],TGACREV!RC[-5],'Net Credit'!C[-4])"
    Range("K2").Select
    Application.CutCopyMode = False
    Range("K2").Select
    ActiveCell.FormulaR1C1 = _
        "=SUMIF('CC Refunds'!C[-8],TGACREV!RC[-6],'CC Refunds'!C)"
    Range("L2").Select
    Application.CutCopyMode = False
    ActiveCell.FormulaR1C1 = "=RC[-2]+RC[-9]"
    Range("I2:L2").Select
    Range("L2").Activate
    Selection.AutoFill Destination:=Range("I2:L67")
    Range("I2:L67").Select
    Range("A1:M1").Select
    Selection.AutoFilter
    Selection.Font.Bold = True
    Columns("A:M").Select
    Range("M1").Activate
    Columns("A:M").EntireColumn.AutoFit
    Range("A1:M1").Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .ThemeColor = xlThemeColorAccent1
        .TintAndShade = 0.599993896298105
        .PatternTintAndShade = 0
    End With
    ActiveWindow.Zoom = 145
    ActiveWindow.Zoom = 130
    ActiveWindow.Zoom = 115
End Sub
