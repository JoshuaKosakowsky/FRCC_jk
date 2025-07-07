Sub NormalizeAndInsertCourseFees()

    Dim ws As Worksheet
    Dim srcRow As Long, outRow As Long
    Dim feeCodes As Variant, feeAmts As Variant
    Dim courseName As String, campus As String, subject As String
    Dim courseID As String, section As String
    Dim studentID As String

    Set ws = Worksheets("Invoice")
    studentID = ws.Range("C2").Value

    ' === Always assume tuition data starts at row 7 and ends at row 9 ===
    ' You can adjust this range if needed
    Dim firstRow As Long, lastRow As Long
    firstRow = 7
    lastRow = 9 ' Change this if student has more than 3 courses

    ' === Clear old fee output from B17:H50 (safe range) ===
    ws.Range("B17:H50").ClearContents

    ' === Output fee table header at B17 ===
    outRow = 17
    ws.Range("B" & outRow & ":H" & outRow).Value = Array("Student Course(s)", "Campus", "Subject", "Course ID", "Section", "Course Specific Fee", "Fee Amount")
    outRow = outRow + 1

    ' === Loop through tuition table from firstRow to lastRow ===
    For srcRow = firstRow To lastRow
        If ws.Cells(srcRow, "B").Value = "" Then GoTo SkipRow

        courseName = ws.Cells(srcRow, "B").Value
        campus = ws.Cells(srcRow, "C").Value
        subject = ws.Cells(srcRow, "D").Value
        courseID = ws.Cells(srcRow, "E").Value
        section = ws.Cells(srcRow, "F").Value

        feeCodes = Split(ws.Cells(srcRow, "I").Value, ",")
        feeAmts = Split(ws.Cells(srcRow, "J").Value, ",")

        If ws.Cells(srcRow, "I").Value = "" Then
            ws.Cells(outRow, "B").Value = courseName
            ws.Cells(outRow, "C").Value = campus
            ws.Cells(outRow, "D").Value = subject
            ws.Cells(outRow, "E").Value = courseID
            ws.Cells(outRow, "F").Value = section
            ws.Cells(outRow, "G").Value = "None"
            ws.Cells(outRow, "H").Value = 0
            outRow = outRow + 1
        Else
            For i = LBound(feeCodes) To UBound(feeCodes)
                ws.Cells(outRow, "B").Value = courseName
                ws.Cells(outRow, "C").Value = campus
                ws.Cells(outRow, "D").Value = subject
                ws.Cells(outRow, "E").Value = courseID
                ws.Cells(outRow, "F").Value = section
                ws.Cells(outRow, "G").Value = Trim(feeCodes(i))
                If i <= UBound(feeAmts) Then
                    ws.Cells(outRow, "H").Value = Val(feeAmts(i))
                Else
                    ws.Cells(outRow, "H").Value = 0
                End If
                outRow = outRow + 1
            Next i
        End If

SkipRow:
    Next srcRow

    MsgBox "Course-specific fees added below tuition in Invoice sheet.", vbInformation

End Sub

