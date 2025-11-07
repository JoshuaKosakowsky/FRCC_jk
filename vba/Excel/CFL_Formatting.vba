Sub CFL_Formatting()
'
' CFL_Formatting Macro
'

    Dim ws As Worksheet
    Dim lastRow As Long
    Set ws = ActiveSheet

    ' Delete old header row
    ws.Rows("1:1").Delete Shift:=xlUp

    ' Set new headers
    ws.Range("A1").Value = "COLLEGE"
    ws.Range("B1").Value = "TERM"
    ws.Range("C1").Value = "CRN"
    ws.Range("D1").Value = "SUBJECT"
    ws.Range("E1").Value = "COURSE NUMBER"
    ws.Range("F1").Value = "SECTION"
    ws.Range("G1").Value = "CAMPUS"
    ws.Range("H1").Value = "CREDIT HRS"
    ws.Range("I1").Value = "BILL HRS"
    ws.Range("U1").Value = "ATTRIBUTE"
    ws.Range("V1").Value = "ACTIVITY DATE"
    ws.Range("W1").Value = "DETAIL CODE"
    ws.Range("Y1").Value = "FEE"
    ws.Range("Z1").Value = "LEVEL CODE"
    ws.Range("AA1").Value = "CODE TYPE"

    ' Overwrite cell A2 to remove hidden/invalid character
    ws.Range("A3").Copy
    ws.Range("A2").PasteSpecial Paste:=xlPasteValues
    Application.CutCopyMode = False

    ' Format header row
    With ws.Range("A1:AT1")
        .Font.Bold = True
        .Interior.Color = 15773696
    End With

    ' Apply AutoFilter to header row
    ws.Range("A1:AT1").AutoFilter

    ' Autofit columns and rows
    ws.Cells.Columns.AutoFit
    ws.Cells.Rows.AutoFit

    ' Hide unnecessary columns
    ws.Columns("J:T").EntireColumn.Hidden = True
    ws.Columns("X:X").EntireColumn.Hidden = True
    ws.Columns("AB:AT").EntireColumn.Hidden = True

    ' Freeze top row
    With ActiveWindow
        .SplitRow = 1
        .FreezePanes = True
    End With

    ' Get last row based on column A
    lastRow = ws.Cells(ws.Rows.Count, "A").End(xlUp).Row

    ' Sort by SUBJECT, COURSE NUMBER, SECTION, and CAMPUS
    With ws.Sort
        .SortFields.Clear
        .SortFields.Add2 Key:=ws.Range("D2:D" & lastRow), Order:=xlAscending
        .SortFields.Add2 Key:=ws.Range("E2:E" & lastRow), Order:=xlAscending
        .SortFields.Add2 Key:=ws.Range("F2:F" & lastRow), Order:=xlAscending
        .SortFields.Add2 Key:=ws.Range("G2:G" & lastRow), Order:=xlAscending
        .SetRange ws.Range("A1:AT" & lastRow)
        .Header = xlYes
        .MatchCase = False
        .Orientation = xlTopToBottom
        .SortMethod = xlPinYin
        .Apply
    End With

    ' Optional zoom
    ActiveWindow.Zoom = 130
End Sub
