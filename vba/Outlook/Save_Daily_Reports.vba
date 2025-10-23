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
    MainFolderPath = "C:\Users\" & Environ("USERNAME") & "\OneDrive - Colorado Community College System\Accounts Receivable - AR Supervisors - AR Supervisors\Daily Reports\"
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
                    Select Case True
                        ' === Kevin/CCCS reports ===
                        Case Attachment.DisplayName = "ARP Scholarships and Refunds by Term.xlsx"
                            SubFolderPath = MainFolderPath & "ARP Scholarships and Refunds by Term\"
                        Case Attachment.DisplayName = "COVID Scholarships and Refunds by Term.xlsx"
                            SubFolderPath = MainFolderPath & "COVID Scholarships and Refunds by Term\"
                        Case Attachment.DisplayName = "CRRSAA Scholarships and Refunds by Term.xlsx"
                            SubFolderPath = MainFolderPath & "CRRSAA Scholarships and Refunds by Term\"
                        Case Attachment.DisplayName = "Net Credit By Term And SID.xlsx"
                            SubFolderPath = MainFolderPath & "Net Credit By Term And SID\"
                        Case Attachment.DisplayName = "Refund by Check or Credit Card.xlsx"
                            SubFolderPath = MainFolderPath & "Refund by Check or Credit Card\"
                        Case Attachment.DisplayName = "Remaining Credits by VPDI.xlsx"
                            SubFolderPath = MainFolderPath & "Remaining Credits by VPDI\"
                        Case Attachment.DisplayName = "Tax Offset Report.xlsx"
                            SubFolderPath = MainFolderPath & "Tax Offset Report\"
                        Case Attachment.DisplayName = "Third Party AR Aging Report.xlsx"
                            SubFolderPath = MainFolderPath & "Third Party AR Aging Report\"
                        Case Attachment.DisplayName = "Third Party Balances by Term and SID.xlsx"
                            SubFolderPath = MainFolderPath & "Third Party Balances by Term and SID\"
                            
                        ' === DSIR reports ===
                        Case Attachment.DisplayName = "Bursar QA Report.xlsx"
                            SubFolderPath = MainFolderPath & "Bursar Error Report\"
                        
                        
                        ' === My reports ===
                        ' === AR Query reports ===
                        Case Attachment.DisplayName = "AR Query BM Rev.xlsx"
                            SubFolderPath = MainFolderPath & "AR Query BM Rev\"
                        Case Attachment.DisplayName = "AR Query COF.xlsx"
                            SubFolderPath = MainFolderPath & "AR Query COF\"
                        Case Attachment.DisplayName = "AR Query Disbursements.xlsx"
                            SubFolderPath = MainFolderPath & "AR Query Disbursements\"
                        Case Attachment.DisplayName = "AR Query ELM.xlsx"
                            SubFolderPath = MainFolderPath & "AR Query ELM\"
                        Case Attachment.DisplayName = "AR Query PPL.xlsx"
                            SubFolderPath = MainFolderPath & "AR Query PPL\"
                        Case Attachment.DisplayName = "AR Query Refunds.xlsx"
                            SubFolderPath = MainFolderPath & "AR Query Refunds\"
                        Case Attachment.DisplayName = "AR Query Student Payments.xlsx"
                            SubFolderPath = MainFolderPath & "AR Query Student Payments\"
                        Case Attachment.DisplayName = "FA AR Query.xlsx"
                            SubFolderPath = MainFolderPath & "FA AR Query\"
                        Case Attachment.DisplayName = "PPL AR Query.xlsx"
                            SubFolderPath = MainFolderPath & "PPL AR Query\"
                            
                        ' === Ledger reports ===
                        Case Attachment.DisplayName = "001010_111010_Cash Log.xlsx"
                            SubFolderPath = MainFolderPath & "001010 111010 General Fund\"
                        Case Attachment.DisplayName = "011042_113070_Cashnet.xlsx"
                            SubFolderPath = MainFolderPath & "011042 113070 Cashnet\"
                        Case Attachment.DisplayName = "011043_113070_WC-BCC.xlsx"
                            SubFolderPath = MainFolderPath & "011043 113070 WC-BCC\"
                            
                        ' === Student reports ===
                        Case Attachment.DisplayName = "FRCC Amount By Current Term.xlsx"
                            SubFolderPath = MainFolderPath & "Amount By Current Term\"
                        Case Attachment.DisplayName = "Amount by Term and SID.xlsx"
                            SubFolderPath = MainFolderPath & "Amount by Term and SID\"
                        Case Attachment.DisplayName = "My Fiscal Student Attributes.xlsx"
                            SubFolderPath = MainFolderPath & "My Fiscal Student Attributes\"
                        
                        ' === Wildcard term-based reports ===
                        Case Attachment.DisplayName Like "20#### SD Holds.xlsx"
                            SubFolderPath = MainFolderPath & "Holds\SD Holds\"
                        Case Attachment.DisplayName Like "20#### T6 Holds.xlsx"
                            SubFolderPath = MainFolderPath & "Holds\T6 Holds\"
                        Case Attachment.DisplayName Like "20#### TF Holds.xlsx"
                            SubFolderPath = MainFolderPath & "Holds\TF Holds\"
                        Case Attachment.DisplayName Like "20#### TF Holds.xlsx"
                            SubFolderPath = MainFolderPath & "Holds\TF Holds\"
                        Case Attachment.DisplayName Like "Non-Payment Contact List by Census Date 20####.xlsx"
                            SubFolderPath = MainFolderPath & "Non-Payment Contact List by Census Date\"
                            
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

