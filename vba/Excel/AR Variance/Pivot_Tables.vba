Option Explicit

Private Function CleanHeaderName(ByVal s As String) As String
    ' Normalize: remove ASCII apostrophes and smart quotes, collapse spaces, case-insensitive compare
    Dim t As String
    t = s
    t = Replace(t, "'", "")                ' remove straight apostrophes
    t = Replace(t, ChrW(8216), "")         ' left single smart quote
    t = Replace(t, ChrW(8217), "")         ' right single smart quote
    t = Replace(t, Chr(160), " ")          ' non-breaking space -> normal space
    t = Application.WorksheetFunction.Trim(t)
    CleanHeaderName = LCase$(t)
End Function

Private Function FindPivotField(ByVal pt As pivotTable, ByVal desired As String) As PivotField
    Dim pf As PivotField, want As String, cand As String
    want = CleanHeaderName(desired)
    For Each pf In pt.PivotFields
        cand = pf.SourceName
        If Len(cand) = 0 Then cand = pf.Name
        If CleanHeaderName(cand) = want Then
            Set FindPivotField = pf
            Exit Function
        End If
    Next pf
    Set FindPivotField = Nothing
End Function

Public Sub Pivot_Tables()
    Dim ws As Worksheet: Set ws = ActiveSheet

    ' Use the actual data block: assumes headers in row 1, contiguous data
    Dim src As Range
    Set src = ws.Range("A1").CurrentRegion  ' safer than full A:G
    
    ' --- First Pivot at I1
    Dim pc1 As pivotCache, pt1 As pivotTable
    Set pc1 = ActiveWorkbook.PivotCaches.Create(SourceType:=xlDatabase, SourceData:=src.Address(External:=True), Version:=6)
    On Error Resume Next
    Application.DisplayAlerts = False
    ws.PivotTables("PivotTable3").TableRange2.Clear
    Application.DisplayAlerts = True
    On Error GoTo 0
    Set pt1 = pc1.CreatePivotTable(TableDestination:=ws.Cells(1, 9), TableName:="PivotTable3", DefaultVersion:=6)

    With pt1
        .RowAxisLayout xlCompactRow
        .RepeatAllLabels xlRepeatLabels

        Dim pfAmt As PivotField, pfTransDesc As PivotField, pfRucl As PivotField
        Set pfAmt = FindPivotField(pt1, "Amt")
        Set pfTransDesc = FindPivotField(pt1, "Trans Desc")
        Set pfRucl = FindPivotField(pt1, "Rucl Code")

        If pfAmt Is Nothing Then Err.Raise vbObjectError + 513, , "Could not find the 'Amt' field. Check header spelling/whitespace."
        If pfTransDesc Is Nothing Then Err.Raise vbObjectError + 514, , "Could not find the 'Trans Desc' field."
        If pfRucl Is Nothing Then Err.Raise vbObjectError + 515, , "Could not find the 'Rucl Code' field."

        .AddDataField pfAmt, "Sum of Amt", xlSum

        With pfTransDesc
            .Orientation = xlRowField
            .Position = 1
        End With
        With pfRucl
            .Orientation = xlColumnField
            .Position = 1
        End With
    End With

    ws.Range("J:N").Style = "Comma"

    ' --- Second Pivot at P1
    Dim pc2 As pivotCache, pt2 As pivotTable
    Set pc2 = ActiveWorkbook.PivotCaches.Create(SourceType:=xlDatabase, SourceData:=src.Address(External:=True), Version:=6)
    On Error Resume Next
    Application.DisplayAlerts = False
    ws.PivotTables("PivotTable4").TableRange2.Clear
    Application.DisplayAlerts = True
    On Error GoTo 0
    Set pt2 = pc2.CreatePivotTable(TableDestination:=ws.Cells(1, 16), TableName:="PivotTable4", DefaultVersion:=6)

    With pt2
        .RowAxisLayout xlCompactRow
        .RepeatAllLabels xlRepeatLabels

        Dim pfDrCr As PivotField, pfTrans As PivotField, pfAmt2 As PivotField
        Set pfAmt2 = FindPivotField(pt2, "Amt")
        Set pfDrCr = FindPivotField(pt2, "Dr Cr Ind")
        Set pfTrans = FindPivotField(pt2, "Trans")

        If pfAmt2 Is Nothing Then Err.Raise vbObjectError + 516, , "Could not find the 'Amt' field for Pivot 2."
        If pfDrCr Is Nothing Then Err.Raise vbObjectError + 517, , "Could not find the 'Dr Cr Ind' field."
        If pfTrans Is Nothing Then Err.Raise vbObjectError + 518, , "Could not find the 'Trans' field."

        .AddDataField pfAmt2, "Sum of Amt", xlSum

        With pfDrCr
            .Orientation = xlColumnField
            .Position = 1
        End With
        With pfTrans
            .Orientation = xlRowField
            .Position = 1
            On Error Resume Next
            .AutoGroup    ' groups dates if Trans is a date
            On Error GoTo 0
        End With
    End With

    ' Try month grouping at P3 (harmless if not a date)
    On Error Resume Next
    ws.Range("P3").Group Start:=True, End:=True, Periods:=Array(False, False, False, False, True, False, False)
    On Error GoTo 0

    ws.Range("Q:T").Style = "Comma"
End Sub


