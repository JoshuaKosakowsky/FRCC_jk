'''
This program takes the CLEANED data from CCCS and the CLEANED data from BANNER (Course Fee Listing screen)
To create two new spreadsheets
1 is the cleaned version to be used to update SSADETL and the Tuition costs for the upcoming term
2 is the "Trash" that was not matched for later use to see if any errors occured after uploading and performing recon.
'''

import pandas as pd
from datetime import datetime

# Function to get the current date for file renaming.
def get_current_date():
    current_date = datetime.now()
    formatted_date = current_date.strftime("%m-%d-%y")
    return formatted_date

current_date = get_current_date()
csv_doc = current_date + '.csv'
xlsx_doc = current_date + '.xlsx'
term = '202530'


filepath = 'c:/'

# Spreadsheet from SharePoint or Dina (SECTION is 1XX, 2XX, 3XX, etc.)
Path_Orig = filepath + f'Cleaned CCCS Course Fees {xlsx_doc}'

# File from BANNER/CourseFee_txt=xlsx.py (SECTION is 101, 205, 317, etc.)
Path_WIP = filepath + f'Course Fee Listing - {xlsx_doc}' #'CourseListingFeesV2.xlsx' - Old one

output_name = f'{term}CourseFees_Updated - {xlsx_doc}'
unmatched_output = filepath + f'UnmatchedEntriesWFees {term}CourseFees - {xlsx_doc}'
Output = filepath + output_name

Orig_df = pd.read_excel(Path_Orig)
WIP_df = pd.read_excel(Path_WIP)

# Convert CRN and CAMPUS columns to string in both DataFrames
for col in ['CRN', 'CAMPUS', 'SUBJECT']:
    #Orig_df[col] = Orig_df[col].astype(str)
    WIP_df[col] = WIP_df[col].astype(str)

# Normalize column names in both dataframes to upper case
Orig_df.columns = [col.upper() for col in Orig_df.columns]
WIP_df.columns = [col.upper() for col in WIP_df.columns]

# Function to extract the first digit of the SECTION and handle "ALL"
def modify_for_matching(value):
    if value == 'ALL':
        return 'ALL'
    else:
        section_str = str(value)
        if len(section_str) > 1 and section_str[:2] in ['37', '38', '39']:
            return section_str[:2] + 'X'
        else:
            return section_str[0] + 'XX'
    
# ADD MODIFY FOR ATTR here - Concurrent

def modify_for_hs(value):
    if value != "CONC":
        return ""
    else:
        return "CONC"

Orig_df['MODIFIED_SECTION'] = Orig_df['SECTION'].apply(modify_for_matching)
WIP_df['MODIFIED_SECTION'] = WIP_df['SECTION'].apply(modify_for_matching)
WIP_df['ATTR'] = WIP_df['ATTR'].apply(modify_for_hs)

# Inner join to get desired data
result_df = pd.merge(Orig_df, WIP_df, on=['SUBJECT'], how='inner')

outer_df =  pd.merge(Orig_df, WIP_df, on=['SUBJECT'], how='outer')
outer_df = outer_df[outer_df['AMOUNT'] > 0]
outer_df.dropna(thresh=2)
print(outer_df.head())
print(outer_df.shape)
print('outer_df columns', outer_df.columns)


# Course Fee Listing filtered to only include items with Fees for later comparison
WIPfees_df = WIP_df[WIP_df['AMOUNT'] > 0]

# delete FCZ campus from output 
##
#

# Apply a custom filter function to handle modified SECTION matches, 'ALL', campus compatibility, and numeric checks
def custom_filter(row):
    crn_match = (row['CRN_x'] == row['CRN_y']) or (row['CRN_x'] == 'ALL') or (row['CRN_y'] == 'ALL')
    
    # Extended Campus matching logic including special cases for FBO, FWO, FLO
    if row['CAMPUS_y'] == 'FBO':
        campus_match = row['CAMPUS_x'] in ['FBO', 'FBC']
    elif row['CAMPUS_y'] == 'FWO':
        campus_match = row['CAMPUS_x'] in ['FWO', 'FWC']
    elif row['CAMPUS_y'] == 'FLO':
        campus_match = row['CAMPUS_x'] in ['FLO', 'FLC']
    elif row['CAMPUS_y'] == 'FCY':
        campus_match = row['CAMPUS_x'] in ['FON', 'FCY']
    else:
        campus_match = (row['CAMPUS_x'] == row['CAMPUS_y']) or (row['CAMPUS_x'] == 'ALL') or (row['CAMPUS_y'] == 'ALL')
    
    if row['SECTION_x'].isdigit():
        section_match = row['SECTION_x'] == row['SECTION_y']
    else:
        section_match = (row['MODIFIED_SECTION_x'] == row['MODIFIED_SECTION_y']) or \
                        (row['MODIFIED_SECTION_x'] == 'ALL' and row['SECTION_y'].isdigit()) or \
                        (row['MODIFIED_SECTION_y'] == 'ALL' and row['SECTION_x'].isdigit())
        
    # Exclude rows where ATTR is 'CONC' and SECTION is '2XX' or '3XX' or '30X'
    hs_attr_section_rule = not ((row['ATTR'] == 'CONC') and ((row['SECTION_x'] == '2XX') or (row['SECTION_x'] == '3XX') or (row['SECTION_x'] == '30X')))
    
    # All conditions must be true for the row to be included in the final DataFrame
    return crn_match and campus_match and section_match and hs_attr_section_rule

def fee_type(freq):
    if freq in ['Per Course', 'Per Term']:
        return 'FLAT'
    else:
        return 'CRED'
    
# Matches detail codes for FRCC Campus (all but FCY)
def detail_code(det, campus):
    if det in ['Digital Content Fee'] and campus != 'FCY':
        return 'A393' # A392 - FALL, A393 - SPRING
    else:
        return 'A384' # A383 - FALL, A384 - SPRING # Course Specific Fee


# Matches Detail Codes for CO Online (FCY)
def online_detail_code(det, campus):
    # This only runs the below code on FCY Campus
    if campus == 'FCY' or campus == 'FON':
        # CO Online Lab Kit Fee 'Lab Kit Fee'
        if 'Lab Kit Fee' in det or 'Lab Fee Kit' in det:
            return 'B730' 
        # CO Online Lab Fee "Lab Supplies"
        elif 'Lab Supplies' in det:
            return 'B731' 
        # CO Online Digital Content Fee 'Digital Content Fee'
        elif 'Digital Content Fee'in det:
            return 'B733'
        # CO Online Materials Fee # this is the else:
        else:
            return 'B732' 
    else:
        return "Review for accuracy"


result_df['FEE TYPE'] = result_df['FREQUENCY'].apply(fee_type)
#result_df['DETAIL CODE'] = result_df['EXPLANATION'].apply(detail_code)
# applying FRCC Detail code matching
result_df['DETAIL CODE'] = result_df.apply(lambda row: detail_code(row['EXPLANATION'], row['CAMPUS_y']), axis=1)
# applying CO ONline Detail code matching
# 
result_df['DETAIL CODE'] = result_df.apply(lambda row: online_detail_code(row['EXPLANATION'], row['CAMPUS_y']) if row['CAMPUS_y'] == 'FCY' else row ['DETAIL CODE'], axis=1)
result_df = result_df[result_df.apply(custom_filter, axis=1)]
print('Resulting Columns\n',result_df.columns)

final_df = result_df[['SEMESTER', 'SSADETL CRN', 'SUBJECT', 'CRN_x', 'CRN_y', 'SECTION_x', 'SECTION_y', 'CAMPUS_x', 'CAMPUS_y', 'ATTR', 'FY25 FEE AMOUNT', 'COURSE NAME', 'FEE TYPE', 'FREQUENCY', 'DETAIL CODE', 'EXPLANATION']]
final_df.columns = ['TERM', 'SSADETL CRN', 'SUBJECT', 'Orig CRN', 'WIP CRN', 'Orig SECTION', 'WIP SECTION', 'ORIG CAMPUS', 'WIP CAMPUS', 'ATTR', f'{term} FEE AMOUNT', 'COURSE NAME', 'FEE TYPE', 'FREQUENCY','DETAIL CODE', 'EXPLANATION']
final_df = final_df.sort_values(by=['SUBJECT', 'SSADETL CRN'], ascending = [True, True])
print('Final Fees Columns\n',final_df.columns)
print('WIP FEES Columns\n', WIPfees_df.columns)
print(WIPfees_df.shape)


# Removing Noise from unmatched entries
WIPfees_df = WIPfees_df[['SEMESTER', 'SSADETL CRN', 'SUBJECT', 'CRN', 'SECTION', 'CAMPUS', 'ATTR', 'DET CODE', 'AMOUNT', 'MODIFIED_SECTION', 'DET CODE']]
WIPfees_df.columns = ['TERM', 'SSADETL CRN', 'SUBJECT', 'WIP CRN', 'WIP SECTION', 'WIP CAMPUS', 'ATTR', 'DET CODE', 'AMOUNT', 'MODIFIED_SECTION', 'DETAIL CODE']

# Filter for unmatched entries (where any join key is NaN)
unmatched_wFees_df = WIPfees_df.merge(final_df, on=['SUBJECT', 'SSADETL CRN', 'WIP SECTION', 'WIP CAMPUS'], how='left', indicator=True)
unmatched_wFees_df = unmatched_wFees_df[unmatched_wFees_df['_merge'] == 'left_only']
unmatched_wFees_df = unmatched_wFees_df.sort_values(by=['SUBJECT', 'SSADETL CRN'], ascending = [True, True])

unmatched_wFees_df = unmatched_wFees_df[['TERM_x', 'SSADETL CRN', 'WIP CRN_x', 'WIP SECTION', 'WIP CAMPUS', 'ATTR_x', 'AMOUNT']]
unmatched_wFees_df.columns = ['TERM', 'SSADETL CRN', 'COURSE NUM', 'SECTION','WIP CAMPUS', 'ATTR', 'AMOUNT']

unmatched_wFees_df.to_excel(unmatched_output, index=False)

final_df.to_excel(Output, index=False)

print(final_df.head())
print(f'Matched DF is {len(final_df)}')
print(f'Unmatched DF with Fees is {len(unmatched_wFees_df)}')
