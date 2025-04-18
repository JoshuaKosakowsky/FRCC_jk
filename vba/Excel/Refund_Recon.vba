Sub Refund_Recon()
    Dim MainFolderPath As String
    Dim NetCreditFilePath As String
    Dim CCRefundsFilePath As String
    Dim DNRFilePath As String
    Dim TodayDate As String
    Dim wbSource As Workbook
    Dim wsSource As Worksheet
    Dim wsDest As Worksheet

    ' Define main folder path and today's date in the format used for files
    MainFolderPath = "C:\Users\" & Environ("USERNAME") & "\OneDrive - Colorado Community College System\AR\Daily Reports\"
    TodayDate = Format(Date, "yyyy-mm-dd")

    ' Set file paths with today's date appended
    NetCreditFilePath = MainFolderPath & "Net Credit By Term And SID\Net Credit By Term And SID_" & TodayDate & ".xlsx"
    CCRefundsFilePath = MainFolderPath & "Refund by Check or Credit Card\Refund by Check or Credit Card_" & TodayDate & ".xlsx"
    DNRFilePath = "C:\Users\" & Environ("USERNAME") & "\OneDrive - Colorado Community College System\Refunds\Auto and Manual Refunds\Reversals- DO NOT REFUND PA.xlsx"
    

    ' Locate the TGACREV sheet to insert tabs after it
    Dim tgacrevSheet As Worksheet
    Set tgacrevSheet = ThisWorkbook.Sheets("TGACREV")

    ' Insert and populate Net Credit tab
    Set wsDest = ThisWorkbook.Sheets.Add(After:=tgacrevSheet)
    wsDest.Name = "Net Credit"
    Set wbSource = Workbooks.Open(NetCreditFilePath)
    Set wsSource = wbSource.Sheets(1) ' Assuming data is in the first sheet of the Net Credit report
    wsSource.UsedRange.Copy wsDest.Range("A1")
    wbSource.Close False

    ' Insert and populate CC Refunds tab
    Set wsDest = ThisWorkbook.Sheets.Add(After:=ThisWorkbook.Sheets("Net Credit"))
    wsDest.Name = "CC Refunds"
    Set wbSource = Workbooks.Open(CCRefundsFilePath)
    Set wsSource = wbSource.Sheets(1) ' Assuming data is in the first sheet of the CC Refunds report
    wsSource.UsedRange.Copy wsDest.Range("A1")
    wbSource.Close False

    ' Insert and populate DNR tab
    Set wsDest = ThisWorkbook.Sheets.Add(After:=ThisWorkbook.Sheets("CC Refunds"))
    wsDest.Name = "DNR"
    Set wbSource = Workbooks.Open(DNRFilePath)
    Set wsSource = wbSource.Sheets(1) ' Assuming data is in the first sheet of the DNR report
    wsSource.UsedRange.Copy wsDest.Range("A1")
    wbSource.Close False

    ' Clean up
    Set wsSource = Nothing
    Set wsDest = Nothing
    Set wbSource = Nothing

    MsgBox "Net Credit, CC Refunds, and DNR tabs inserted and populated between TGACREV and Manual."
End Sub
