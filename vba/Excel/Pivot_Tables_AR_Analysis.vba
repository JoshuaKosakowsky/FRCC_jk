Sub Pivot_Tables()
    Dim ws As Worksheet
    Set ws = ActiveSheet
    
    Dim dataRange As String
    dataRange = ws.Name & "!R1C1:R1048576C7" ' Columns A to G
    
    ' Create First Pivot Table at I1 (Column 9)
    Dim pc1 As PivotCache
    Set pc1 = ActiveWorkbook.PivotCaches.Create( _
        SourceType:=xlDatabase, _
        SourceData:=dataRange, _
        Version:=6)
        
    Dim pt1 As PivotTable
    Set pt1 = pc1.CreatePivotTable( _
        TableDestination:=ws.Cells(1, 9), _
        TableName:="PivotTable3", _
        DefaultVersion:=6)
    
    With pt1
        .RowAxisLayout xlCompactRow
        .RepeatAllLabels xlRepeatLabels
        .AddDataField .PivotFields("Amt"), "Sum of Amt", xlSum
        With .PivotFields("'Trans Desc'")
            .Orientation = xlRowField
            .Position = 1
        End With
        With .PivotFields("'Rucl Code'")
            .Orientation = xlColumnField
            .Position = 1
        End With
    End With
    
    ' Apply comma format to J:N
    ws.Range("J:N").Style = "Comma"
    
    ' Create Second Pivot Table at P1 (Column 16)
    Dim pc2 As PivotCache
    Set pc2 = ActiveWorkbook.PivotCaches.Create( _
        SourceType:=xlDatabase, _
        SourceData:=dataRange, _
        Version:=6)
    
    Dim pt2 As PivotTable
    Set pt2 = pc2.CreatePivotTable( _
        TableDestination:=ws.Cells(1, 16), _
        TableName:="PivotTable4", _
        DefaultVersion:=6)
    
    With pt2
        .RowAxisLayout xlCompactRow
        .RepeatAllLabels xlRepeatLabels
        .AddDataField .PivotFields("Amt"), "Sum of Amt", xlSum
        With .PivotFields("'Dr Cr Ind'")
            .Orientation = xlColumnField
            .Position = 1
        End With
        With .PivotFields("Trans")
            .Orientation = xlRowField
            .Position = 1
            .AutoGroup
        End With
    End With
    
    ' Group by months if Trans is a date
    On Error Resume Next
    ws.Range("P3").Group Start:=True, End:=True, Periods:=Array(False, False, False, False, True, False, False)
    On Error GoTo 0
    
    ' Apply comma style to Q:T
    ws.Range("Q:T").Style = "Comma"
End Sub
