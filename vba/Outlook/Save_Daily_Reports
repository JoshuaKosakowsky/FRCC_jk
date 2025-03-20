Private Sub Application_Startup()
    Save_Daily_Reports
End Sub

Sub Save_Daily_Reports()
    Dim OutlookNamespace As Object
    Dim Inbox As Object
    Dim Item As Object
    Dim Attachment As Object
    Dim MainFolderPath As String
    Dim DateStr As String
    Dim SubFolderPath As String
    Dim Items As Outlook.Items
    
    ' Main folder path and date format
    MainFolderPath = "C:\Users\" & Environ("USERNAME") & "\OneDrive - Colorado Community College System\AR\Daily Reports\"
    DateStr = Format(Date, "yyyy-mm-dd") ' Format date as "yyyy-mm-dd"
    
    ' Set up Outlook application
    Set OutlookNamespace = Application.GetNamespace("MAPI")
    Set Inbox = OutlookNamespace.GetDefaultFolder(6).Folders("Reports") ' Access the "Reports" subfolder in Inbox
    Set Items = Inbox.Items
    Items.Sort "[ReceivedTime]", True ' Sorts by ReceivedTime in descending order
    
    ' Loop through each mail item in the Reports folder
    For Each Item In Items
        ' Only process emails received today
        If Item.ReceivedTime >= Date Then
            If Item.Attachments.Count > 0 Then
                ' Process each attachment based on its exact name
                For Each Attachment In Item.Attachments
                    Select Case Attachment.DisplayName
                        Case "Refund by Check or Credit Card.xlsx"
                            SubFolderPath = MainFolderPath & "Refund by Check or Credit Card\"
                        Case "Net Credit By Term And SID.xlsx"
                            SubFolderPath = MainFolderPath & "Net Credit By Term And SID\"
                        Case "Remaining Credits by VPDI.xlsx"
                            SubFolderPath = MainFolderPath & "Remaining Credits by VPDI\"
                        Case "ARP Scholarships and Refunds by Term.xlsx"
                            SubFolderPath = MainFolderPath & "ARP Scholarships and Refunds by Term\"
                        Case "COVID Scholarships and Refunds by Term.xlsx"
                            SubFolderPath = MainFolderPath & "COVID Scholarships and Refunds by Term\"
                        Case "CRRSAA Scholarships and Refunds by Term.xlsx"
                            SubFolderPath = MainFolderPath & "CRRSAA Scholarships and Refunds by Term\"
                        Case "FA AR Query.xlsx"
                            SubFolderPath = MainFolderPath & "FA AR Query\"
                        Case "Tax Offset Report.xlsx"
                            SubFolderPath = MainFolderPath & "Tax Offset Report\"
                        Case "Third Party AR Aging Report.xlsx"
                            SubFolderPath = MainFolderPath & "Third Party AR Aging Report\"
                        Case "Third Party Balances by Term and SID.xlsx"
                            SubFolderPath = MainFolderPath & "Third Party Balances by Term and SID\"
                        Case "FRCC Amount By Current Term.xlsx"
                            SubFolderPath = MainFolderPath & "Amount By Current Term\"
                        Case "PPL AR Query.xlsx"
                            SubFolderPath = MainFolderPath & "PPL AR Query\"
                        Case Else
                            SubFolderPath = MainFolderPath & "Other\"
                    End Select
                
                    ' Ensure the subfolder exists
                    If Dir(SubFolderPath, vbDirectory) = "" Then
                        MkDir SubFolderPath
                    End If

                    ' Remove the ".xlsx" extension before appending the date
                    Dim FileNameWithoutExtension As String
                    FileNameWithoutExtension = Left(Attachment.DisplayName, Len(Attachment.DisplayName) - 5) ' Removes the last 5 characters (.xlsx)

                    ' Save the attachment with the date appended
                    Attachment.SaveAsFile SubFolderPath & FileNameWithoutExtension & "_" & DateStr & ".xlsx"
                Next
            End If
        End If
    Next
    
    ' Clean up
    Set Attachment = Nothing
    Set Item = Nothing
    Set Inbox = Nothing
    Set OutlookNamespace = Nothing
End Sub
