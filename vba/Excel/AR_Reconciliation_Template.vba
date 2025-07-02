'Attribute VB_Name = "Module10"
'Attribute Process.VB_Description = "Macro recorded 6/5/2012 by CCCS"
'Attribute Process.VB_ProcData.VB_Invoke_Func = " \n14"
Sub Process()

 Sheets("Instructions").Select

'Prevent execution macro if no data in Instruction tab fields
    If IsEmpty(ActiveSheet.Range("C1")) Then
    MsgBox "No Data in VPDI field"
    Exit Sub
    Else
    End If
    
    If IsEmpty(ActiveSheet.Range("C2")) Then
    MsgBox "No Data in FY field"
    Exit Sub
    Else
    End If
   
    If IsEmpty(ActiveSheet.Range("C3")) Then
    MsgBox "No Data in Period field"
    Exit Sub
    Else
    End If


'Start TGRRCON()portion

    Sheets("TGRRCON").Select
    
'Prevent execution of TGRRCON section of macro twice
    If Range("B1").Value = "Fund" Then
    Else
'Prevent execution macro if no data in TGRRCON tab
    If IsEmpty(ActiveSheet.Range("A1")) Then
    MsgBox "No Data in TGRRCON tab"
    Exit Sub
    Else
    
    
    Cells.Select
    With Selection.Font
        .Name = "Courier"
        .Size = 10
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ColorIndex = xlAutomatic
    End With
    Cells.EntireColumn.AutoFit
    Columns("A:A").Select
    Selection.Insert Shift:=xlToRight
    ActiveCell.SpecialCells(xlLastCell).Select
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    Range("A1").Select
    Range("A2").Select
    ActiveCell.FormulaR1C1 = _
        "=IF(ISNUMBER(SEARCH(""RECONCILIATION STATISTICS"",RC[1])),RC[1],R[-1]C)"
    Range("A2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Columns("A:A").Select
    Selection.Insert Shift:=xlToRight
    Selection.Insert Shift:=xlToRight
    Selection.Insert Shift:=xlToRight
    Selection.Insert Shift:=xlToRight
    Selection.Insert Shift:=xlToRight
    Selection.Insert Shift:=xlToRight
    Selection.Insert Shift:=xlToRight
    Selection.Insert Shift:=xlToRight
    Selection.Insert Shift:=xlToRight
    ActiveCell.SpecialCells(xlLastCell).Select
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
 
    Columns("J:J").Select
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    Columns("K:K").Select
    Selection.TextToColumns Destination:=Range("K1"), DataType:=xlFixedWidth, _
        FieldInfo:=Array(Array(0, 2), Array(5, 2), Array(12, 2), Array(19, 1), Array(38, 1), _
        Array(57, 1), Array(76, 1), Array(96, 1), Array(115, 1), Array(133, 1)), _
        TrailingMinusNumbers:=True

    Range("I2").Select
    ActiveCell.FormulaR1C1 = _
        "=IF(RC[1]=""                                            RECONCILIATION STATISTICS - ACCOUNT SUMMARY"",""A"",IF(RC[1]=""                                            RECONCILIATION STATISTICS - DEPOSIT SUMMARY"",""D"",""N""))"
    Range("I3").Select
 
    Range("I2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Range("I1").Select
    Application.CutCopyMode = False


    Range("A2").Select
    ActiveCell.FormulaR1C1 = _
        "=IF(RC10=""                                            RECONCILIATION STATISTICS - ACCOUNT SUMMARY"",(IF(RC11=""W"",RC[11],"""")),IF(RC10=""                                            RECONCILIATION STATISTICS - DEPOSIT SUMMARY"",(IF(RC11=""W"",RC[11],"""")),""""))"
    Range("A3").Select

    Range("A2").Select
    Selection.AutoFill Destination:=Range("A2:H2"), Type:=xlFillDefault
    Range("A2:H2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False

    ActiveCell.FormulaR1C1 = _
        "=IF(RC10=""                                            RECONCILIATION STATISTICS - ACCOUNT SUMMARY"",(IF(RC11=""W"",RC[11],"""")),IF(RC10=""                                            RECONCILIATION STATISTICS - DEPOSIT SUMMARY"",(IF(RC11=""W"",RC[11],"""")),""""))"
    Range("I2").Select
    ActiveCell.FormulaR1C1 = _
        "=IF(RC10=""                                            RECONCILIATION STATISTICS - ACCOUNT SUMMARY"",(IF(RC11=""W"",A,"""")),IF(RC10=""                                            RECONCILIATION STATISTICS - DEPOSIT SUMMARY"",(IF(RC11=""W"",D,"""")),""Z""))"
    Range("I2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Range("A1").Select
    Application.CutCopyMode = False
    Range("I2").Select
    ActiveCell.FormulaR1C1 = _
        "=IF(RC10=""                                            RECONCILIATION STATISTICS - ACCOUNT SUMMARY"",(IF(RC11=""W"",""A"","""")),IF(RC10=""                                            RECONCILIATION STATISTICS - DEPOSIT SUMMARY"",(IF(RC11=""W"",""D"","""")),""Z""))"
    Range("I2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    
    Range("I2").Select
    ActiveCell.FormulaR1C1 = _
        "=IF(RC10=""                                            RECONCILIATION STATISTICS - ACCOUNT SUMMARY"",(IF(RC11=""W"",""A"",""Z"")),IF(RC10=""                                            RECONCILIATION STATISTICS - DEPOSIT SUMMARY"",(IF(RC11=""W"",""D"",""Z"")),""Z""))"
    Range("I2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Range("A1").Select
    Application.CutCopyMode = False
    Columns("A:I").Select
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    Columns("J:AH").Select
    Selection.Delete Shift:=xlToLeft
    Range("G13").Select
    ActiveCell.SpecialCells(xlLastCell).Select
    Range(Selection, Cells(1)).Select
    Selection.Sort Key1:=Range("I1"), Order1:=xlAscending, Key2:=Range("A1") _
        , Order2:=xlAscending, Key3:=Range("B1"), Order3:=xlAscending, Header:= _
        xlGuess, OrderCustom:=1, MatchCase:=False, Orientation:=xlTopToBottom, _
        DataOption1:=xlSortNormal, DataOption2:=xlSortNormal, DataOption3:= _
        xlSortNormal
'Add fund-acct link
    Columns("I:I").Select
    Selection.Find(What:="Z", After:=ActiveCell, LookIn:=xlFormulas, LookAt _
        :=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, MatchCase:= _
        False, SearchFormat:=False).Activate
        
    ActiveCell.Offset(0, 1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    Range("A1").Select
    Range("J1").Select
    ActiveCell.FormulaR1C1 = "=RC[-9]&""-""&RC[-8]"
    Range("J1").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Application.CutCopyMode = False
    Columns("J:J").Select
    Columns("J:J").EntireColumn.AutoFit
    Columns("A:A").Select
    Selection.Insert Shift:=xlToRight
    Columns("K:K").Select
    Selection.Cut
    Range("A1").Select
    ActiveSheet.Paste
'Delete non-applicable rows
    Columns("J:J").Select
    Selection.Find(What:="Z", After:=ActiveCell, LookIn:=xlFormulas, LookAt _
        :=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, MatchCase:= _
        False, SearchFormat:=False).Activate

    ActiveCell.Rows("1:1").EntireRow.Select
    Range(Selection, ActiveCell.SpecialCells(xlLastCell)).Select
    Selection.EntireRow.Delete
    Columns("D:I").Select
    Selection.NumberFormat = "#,##0.00_);(#,##0.00)"
    Range("A1").Select
 
 'Add Titles
    Rows("1:1").Select
    Selection.Insert Shift:=xlDown
    Range("A1").Select
    ActiveCell.FormulaR1C1 = "Fund-Acct"
    Range("B1").Select
    ActiveCell.FormulaR1C1 = "Fund"
    Range("C1").Select
    ActiveCell.FormulaR1C1 = "Acct"
    Range("D1").Select
    ActiveCell.FormulaR1C1 = "A/R Adj Fed"
    Range("E1").Select
    ActiveCell.FormulaR1C1 = "Pending GURFEED"
    Range("F1").Select
    ActiveCell.FormulaR1C1 = "In Transit"
    Range("G1").Select
    ActiveCell.FormulaR1C1 = "Adj Net Fed"
    Range("H1").Select
    ActiveCell.FormulaR1C1 = "GL Balance"
    Range("I1").Select
    ActiveCell.FormulaR1C1 = "Difference"
    Range("J1").Select
    ActiveCell.FormulaR1C1 = "Type"
    Range("A2").Select
    ActiveWindow.FreezePanes = True

    Range("A2").Select
    
' to save with a date and time in the filename
'    fname = "AR Recon" & "_" & Format(Date, "yyyy-mm-dd") & "_" & Format(Time, "hhmmss") & ".xls"
'    Application.EnableEvents = False
'    ThisWorkbook.SaveAs fname
'    Application.EnableEvents = True

'Change path to current workbook path
    ChDir ThisWorkbook.path
    Sheets("Instructions").Select
 '   fname = "AR Recon" & " " & Range("C1").Value & " " & Range("C2").Value & "-" & Range("C3").Value & " " & Format(Date, "yyyy-mm-dd") & ".xlsm"
    fname = "temp.xlsm"
    Application.DisplayAlerts = False
    ThisWorkbook.SaveAs fname
    Application.DisplayAlerts = True

 End If
 End If

'End TGRRCON portion
'Start SNA portion
    Sheets("SNA-AR").Select
'Prevent execution of SNA macro twice
    If Range("A1").Value = "FundAcct" Then
    Else
'Prevent execution macro if no data in SNA tab
    If IsEmpty(ActiveSheet.Range("A2")) Then
    MsgBox "No Data in SNA tab"
    Exit Sub
    Else

'   Sheets("SNA-AR").Select
    Cells.Select
    Cells.EntireColumn.AutoFit
    Range("A2").Select
    ActiveWindow.FreezePanes = True
    Columns("A:A").Select
    Application.CutCopyMode = False
    Selection.Insert Shift:=xlToRight
    Selection.Insert Shift:=xlToRight
    Selection.Insert Shift:=xlToRight
    Columns("K:K").Select
    Selection.NumberFormat = "#,##0.00_);(#,##0.00)"
    Range("A1").Select
    ActiveCell.FormulaR1C1 = "FundAcct"
    Range("A2").Select
    ActiveCell.SpecialCells(xlLastCell).Select
    ActiveCell.Offset(0, -8).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    Range("A2").Select
    ActiveCell.FormulaR1C1 = "=""0""&RC[8]&""-""&RC[9]"
    Range("A2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Columns("A:A").Select
    Columns("A:A").EntireColumn.AutoFit
    Application.CutCopyMode = False
    Range("B2").Select
    ActiveCell.FormulaR1C1 = _
        "=IF(ISERROR(VLOOKUP(RC[-1],TGRRCON!R1C1:R500C[8],10,FALSE))=TRUE,""Z"",VLOOKUP(RC[-1],TGRRCON!R1C1:R500C10,10,FALSE))"
    Range("B2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Selection.Copy
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Range("A2").Select
    Application.CutCopyMode = False
    Range("B1").Select
    ActiveCell.FormulaR1C1 = "Type"
    Range("A2").Select
    Range(Selection, ActiveCell.SpecialCells(xlLastCell)).Select
    Selection.Sort Key1:=Range("B2"), Order1:=xlAscending, Header:=xlGuess, _
        OrderCustom:=1, MatchCase:=False, Orientation:=xlTopToBottom, _
        DataOption1:=xlSortNormal
  
' End SNA portion
' Start Computation section

    Sheets("TGRRCON").Select
    
    Sheets("TGRRCON").Copy Before:=Sheets(1)
    Sheets("TGRRCON (2)").Select
    Range("K2").Select
    ActiveCell.FormulaR1C1 = _
        "=IF(ISERROR(VLOOKUP(RC[-10],'SNA-AR'!R2C1:R5000C11,11,FALSE))=TRUE,0,VLOOKUP(RC[-10],'SNA-AR'!R2C1:R5000C11,11,FALSE))"
    Range("K3").Select
    ActiveCell.SpecialCells(xlLastCell).Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(1, -7).Range("A1").Select

    ActiveCell.FormulaR1C1 = "x"
    Range("L2").Select
    ActiveCell.FormulaR1C1 = "=RC[-8]-RC[-1]"
    Range("K2:L2").Select
    Selection.Copy
    ActiveSheet.Paste
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Columns("K:L").Select
    Columns("K:L").EntireColumn.AutoFit
    Range("L3").Select
    Application.CutCopyMode = False
    Range("L2").Select
    ActiveCell.FormulaR1C1 = "=IF(ISBLANK(RC[-10])=TRUE,"""",RC[-8]-RC[-1])"
    
    Range("L2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Range("L2").Select
    Application.CutCopyMode = False
    ActiveCell.FormulaR1C1 = "=IF(RC[-10]=""Z"","""",RC[-8]-RC[-1])"
    Range("L2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Range("A2").Select
    Application.CutCopyMode = False
    Range("K1").Select
    Selection.NumberFormat = "#,##0.00_);(#,##0.00)"
    ActiveCell.FormulaR1C1 = "GL Balance"
    With ActiveCell.Characters(Start:=1, Length:=10).Font
        .Name = "Courier"
        .FontStyle = "Regular"
        .Size = 10
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ColorIndex = xlAutomatic
    End With
    Range("L1").Select
    ActiveCell.FormulaR1C1 = "Difference"
    Columns("K:L").Select
    Selection.NumberFormat = "#,##0.00_);(#,##0.00)"
    Columns("K:K").Select
    Selection.Copy
    Range("H1").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Columns("L:L").Select
    Application.CutCopyMode = False
    Selection.Copy
    Range("I1").Select
    Selection.PasteSpecial Paste:=xlPasteValues, Operation:=xlNone, SkipBlanks _
        :=False, Transpose:=False
    Columns("K:L").Select
    Application.CutCopyMode = False
    Selection.Delete Shift:=xlToLeft
    Range("A2").Select
    
'Change path to current workbook path
    ChDir ThisWorkbook.path
    Sheets("Instructions").Select
    fname = "AR Recon" & " " & Range("C1").Value & " " & Range("C2").Value & "-" & Range("C3").Value & " " & Format(Date, "yyyy-mm-dd") & "_" & Format(Time, "hhmmss") & ".xlsm"
    Application.DisplayAlerts = False
    ThisWorkbook.SaveAs fname
    Application.DisplayAlerts = True

'   ActiveWorkbook.Save
    Sheets("TGRRCON (2)").Select
 
    Columns("H:H").Select
    Selection.Insert Shift:=xlToRight
    Range("H1").Select
    ActiveCell.FormulaR1C1 = "A/R Adj O/S"
    Columns("I:I").Select
    Selection.Insert Shift:=xlToRight
    Range("I1").Select
    ActiveCell.FormulaR1C1 = "Adj A/R"
    Columns("K:K").Select
    Selection.Insert Shift:=xlToRight
    Range("K1").Select
    ActiveCell.FormulaR1C1 = "JE O/S"
    Columns("L:L").Select
    Selection.Insert Shift:=xlToRight
    Range("L1").Select
    ActiveCell.FormulaR1C1 = "Adj G/L"
    Range("H2").Select
    ActiveCell.FormulaR1C1 = "0"
    Range("I2").Select
    ActiveCell.FormulaR1C1 = "=SUM(RC[-5]+RC[-1])"
    Range("I3").Select
    ActiveCell.SpecialCells(xlLastCell).Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, -1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    Range("H2:I2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Range("K2").Select
    Application.CutCopyMode = False
    ActiveCell.FormulaR1C1 = "0"
    Range("L2").Select
    ActiveCell.FormulaR1C1 = "=SUM(RC[-2]+RC[-1])"
    Range("L3").Select
    ActiveCell.SpecialCells(xlLastCell).Select
    ActiveCell.Offset(0, -3).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, 1).Range("A1").Select
    ActiveCell.FormulaR1C1 = "x"
    ActiveCell.Offset(0, 1).Range("A1").Select
    Range("K2:L2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Range("M2").Select
    Application.CutCopyMode = False
    ActiveCell.FormulaR1C1 = "=RC[-4]-RC[-1]"
    Range("M2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Columns("M:M").Select
    Columns("M:M").EntireColumn.AutoFit
    Range("A2").Select

    Columns("B:B").Select
    Selection.Replace What:="Z", Replacement:="", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, _
        ReplaceFormat:=False
    Range("A2").Select
'Delete last row
    ActiveCell.SpecialCells(xlLastCell).Select
    ActiveCell.Rows("1:1").EntireRow.Select
    Selection.Delete Shift:=xlUp
    Range("A2").Select
    
    Sheets("TGRRCON (2)").Select
    Columns("E:G").Select
    Selection.Delete Shift:=xlToLeft
    Range("A2").Select
    Columns("C:C").Select
    Selection.Delete Shift:=xlToLeft
    Range("A2").Select

'End computation section

'Start Insert TGR info

    Sheets("TGRRCON (2)").Select
    Range("A2").Select
    Range(Selection, ActiveCell.SpecialCells(xlLastCell)).Select
    Selection.Copy
    Sheets("Reconciliation").Select
    Range("A3").Select
    Selection.Insert Shift:=xlDown
    ActiveCell.Cells.Select
    ActiveCell.Cells.EntireColumn.AutoFit
'End Insert TGR info
'Start Insert SNA info
    Sheets("SNA-AR").Select
    Sheets("SNA-AR").Copy Before:=Sheets(1)
    Range("A2").Select
    Sheets("SNA-AR (2)").Select
    Columns("D:F").Select
    Selection.Delete Shift:=xlToLeft
    Columns("C:G").Select
    Selection.ClearContents
        Columns("H:H").Select
    Application.CutCopyMode = False
    Selection.Copy
    Columns("F:F").Select
    ActiveSheet.Paste
    Range("H2").Select
    Application.CutCopyMode = False
    ActiveCell.FormulaR1C1 = "=RC[-2]+RC[-1]"
    Range("H2").Select
    Selection.Copy
    Range(Selection, Selection.End(xlDown)).Select
    ActiveSheet.Paste
    Application.CutCopyMode = False
    Columns("G:G").Select
    Selection.NumberFormat = "#,##0.00_);(#,##0.00)"
    Range("A2").Select
    Columns("B:B").Select
    Selection.Find(What:="Z", After:=ActiveCell, LookIn:=xlFormulas, LookAt _
        :=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, MatchCase:= _
        False, SearchFormat:=False).Activate
    ActiveCell.Offset(0, -1).Range("A1").Select
    Range(Selection, ActiveCell.SpecialCells(xlLastCell)).Select
    Selection.Copy
    Sheets("Reconciliation").Select
    Columns("A:A").Select
    Selection.Find(What:="Total", After:=ActiveCell, LookIn:=xlFormulas, _
        LookAt:=xlPart, SearchOrder:=xlByRows, SearchDirection:=xlNext, _
        MatchCase:=False, SearchFormat:=False).Activate
    ActiveCell.Offset(-2, 0).Range("A1").Select
    Selection.Insert Shift:=xlDown
    ActiveCell.Offset(0, 1).Columns("A:A").EntireColumn.Select
    Selection.Replace What:="Z", Replacement:="", LookAt:=xlPart, _
        SearchOrder:=xlByRows, MatchCase:=False, SearchFormat:=False, _
        ReplaceFormat:=False
    Range("A2").Select
    ActiveCell.SpecialCells(xlLastCell).Select
    Range("A2").Select
    
'override confirm
    Application.DisplayAlerts = False
    Sheets("SNA-AR (2)").Select
    ActiveWindow.SelectedSheets.Delete
    Application.DisplayAlerts = True
'End Insert SNA section

' Start CleanUp
    Sheets("Reconciliation").Select
    Cells.Select
    Cells.EntireColumn.AutoFit
    Cells.Select
    With Selection.Font
        .Name = "Arial"
        .FontStyle = "Regular"
        .Size = 10
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ColorIndex = xlAutomatic
    End With

    Range("G1").Select
    ActiveCell.FormulaR1C1 = "JE O/S"
    Range("F1").Select
    ActiveCell.FormulaR1C1 = "Adj A/R"
    Range("E1").Select
    ActiveCell.FormulaR1C1 = "A/R O/S"
    Range("F1").Select
    ActiveCell.FormulaR1C1 = "GL Balance"
    Range("H1").Select
    ActiveCell.FormulaR1C1 = "Adj GL Balance"
    Range("E1").Select
    ActiveCell.FormulaR1C1 = "Adj A/R Balance"
    Range("D1").Select
    ActiveCell.FormulaR1C1 = "A/R Adj O/S"
    Range("C1").Select
    ActiveCell.FormulaR1C1 = "A/R Balance"
    Range("C1:J1").Select
    With Selection
        .HorizontalAlignment = xlCenter
        .VerticalAlignment = xlBottom
        .WrapText = False
        .Orientation = 0
        .AddIndent = False
        .IndentLevel = 0
        .ShrinkToFit = False
        .ReadingOrder = xlContext
        .MergeCells = False
    End With
    Range("E15").Select
    Sheets("SNA-AR").Select
    Cells.Select
    With Selection.Font
        .Name = "Courier"
        .FontStyle = "Regular"
        .Size = 10
        .Strikethrough = False
        .Superscript = False
        .Subscript = False
        .OutlineFont = False
        .Shadow = False
        .Underline = xlUnderlineStyleNone
        .ColorIndex = xlAutomatic
    End With
    Cells.EntireColumn.AutoFit
    Columns("B:C").Select
    Selection.Delete Shift:=xlToLeft
    Range("A2").Select
    Sheets("TGRRCON").Select
    Range("A2").Select
    Sheets("Instructions").Select
    Range("A1").Select
    Application.DisplayAlerts = False
    Sheets("TGRRCON (2)").Select
    ActiveWindow.SelectedSheets.Delete
    Application.DisplayAlerts = True
    Sheets("Reconciliation").Select

    Columns("B:B").Select
    Selection.Delete Shift:=xlToLeft
    Range("A2").Select

MsgBox "Finished."
End If
End If

'Delete temporary file

Kill "temp.xlsm"



End Sub

