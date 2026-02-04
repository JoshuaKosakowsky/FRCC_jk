Sub Student_Payment_Agreement()
'
' Student_Payment_Agreement Macro
'

    Dim ws As Worksheet
    Dim lastRow As Long

    Set ws = ActiveSheet
    ws.Cells.UnMerge

    ' Delete top rows
    ws.Rows("1:6").Delete Shift:=xlUp

    ' Determine last row based on DOB column D
    lastRow = ws.Cells(ws.Rows.Count, "D").End(xlUp).Row
    If lastRow < 2 Then Exit Sub

    ' -----------------------------
    ' Column U: "Y in K-T"
    ' -----------------------------
    ws.Range("U1").Interior.Color = 15066599

    With ws.Range("U1").Borders(xlEdgeLeft)
        .LineStyle = xlContinuous
        .Color = -4144960
        .Weight = xlMedium
    End With
    With ws.Range("U1").Borders(xlEdgeRight)
        .LineStyle = xlContinuous
        .Color = -4144960
        .Weight = xlMedium
    End With

    With ws.Range("U1")
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlTop
        .WrapText = False
        .MergeCells = False
        .Value = "Y in K-T"
    End With

    ws.Range("U2").FormulaR1C1 = "=IF(COUNTIF(RC[-10]:RC[-1],""Y"")>0,""Y"",""N"")"
    ws.Range("U2:U" & lastRow).FillDown

    ' -----------------------------
    ' Column V: Current Age
    ' -----------------------------
    With ws.Range("V1")
        .Value = "Current Age"
        .Interior.Pattern = xlSolid
        .Interior.PatternColorIndex = xlAutomatic
        .Interior.Color = 15066599
        .Interior.TintAndShade = 0
        .Interior.PatternTintAndShade = 0
    
        .Borders(xlDiagonalDown).LineStyle = xlNone
        .Borders(xlDiagonalUp).LineStyle = xlNone
    
        With .Borders(xlEdgeLeft)
            .LineStyle = xlContinuous
            .Color = -4144960
            .Weight = xlMedium
        End With
    
        With .Borders(xlEdgeRight)
            .LineStyle = xlContinuous
            .Color = -4144960
            .Weight = xlMedium
        End With
    
        .Borders(xlEdgeTop).LineStyle = xlNone
        .Borders(xlEdgeBottom).LineStyle = xlNone
        .Borders(xlInsideVertical).LineStyle = xlNone
        .Borders(xlInsideHorizontal).LineStyle = xlNone
    
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlTop
        .WrapText = False
        .MergeCells = False
    End With
    
    ' Age calc (completed years, handles birthdays correctly)
    ws.Range("V2").Formula = "=IFERROR(DATEDIF(D2,TODAY(),""Y""),"""")"
    ws.Range("V2:V" & lastRow).FillDown
    ws.Columns("V").NumberFormat = "0"
    
    ' Conditional formatting: highlight <18 in red with black text
    With ws.Range("V2:V" & lastRow)
        .FormatConditions.Add Type:=xlExpression, Formula1:="=AND($V2<>"""",$V2<18)"
        With .FormatConditions(.FormatConditions.Count)
            .Interior.Color = RGB(255, 199, 206)
            .Font.Color = RGB(0, 0, 0)
            .StopIfTrue = False
        End With
    End With

    ' -----------------------------
    ' Conditional formatting for Y in K-T area
    ' -----------------------------
    With ws.Range("K2:T" & lastRow)
        .FormatConditions.Add Type:=xlTextString, String:="Y", TextOperator:=xlContains
        With .FormatConditions(.FormatConditions.Count)
            .Font.Color = -16383844
            .Interior.Color = 13551615
            .StopIfTrue = False
        End With
    End With

    ' -----------------------------
    ' Filter + HS sheet creation
    ' -----------------------------
    ws.Range("A1:W" & lastRow).AutoFilter

    ws.Range("A1:W" & lastRow).AutoFilter Field:=9, Criteria1:="N/A"
    ws.Range("A1:W" & lastRow).AutoFilter Field:=8, Criteria1:=">=500.00", Operator:=xlAnd
    ws.Range("A1:W" & lastRow).AutoFilter Field:=21, Criteria1:="Y"

    ws.Range("A1:W" & lastRow).Copy

    Sheets.Add After:=ws
    ActiveSheet.Name = "HS"
    ActiveSheet.Range("A1").PasteSpecial xlPasteAll

    Application.CutCopyMode = False

    With Sheets("HS")
        .Cells.Columns.AutoFit
        .Columns("A:A").EntireColumn.Hidden = True
        .Activate
        ActiveWindow.Zoom = 130
    End With

    ' -----------------------------
    ' Regular sheet creation
    ' -----------------------------
    ws.Range("A1:W" & lastRow).AutoFilter Field:=21, Criteria1:="N"
    ws.Range("A1:W" & lastRow).Copy

    Sheets.Add After:=ws
    ActiveSheet.Name = "Regular"
    ActiveSheet.Range("A1").PasteSpecial xlPasteAll
    Application.CutCopyMode = False

    With Sheets("Regular")
        .Cells.Columns.AutoFit
        .Range("A:A").EntireColumn.Hidden = True
        .Activate
        ActiveWindow.Zoom = 130
    End With

    ' Save
    ActiveWorkbook.Save

End Sub

