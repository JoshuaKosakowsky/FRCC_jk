'''
This program takes the CLEANED data from CCCS and the CLEANED data from BANNER (Course Fee Listing screen)
To create two new spreadsheets
1 is the cleaned version to be used to update SSADETL and the Tuition costs for the upcoming term
2 is the "Trash" that was not matched for later use to see if any errors occured after uploading and performing recon.
'''

import pandas as pd

filepath = 'c:/'

# Spreadsheet from SharePoint (SECTION is 1XX, 2XX, 3XX, etc.)
Path_Orig = filepath + '.xlsx'

# File from BANNER/CourseFee_txt-xlsx.py (SECTION is 101, 205, 317, etc.)
Path_WIP = filepath + '.xlsx'

output_name = '.xlsx'
unmatched_output = filepath + '.xlsx'
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
# Outer join to find unmatched entries
full_outer_df = pd.merge(Orig_df, WIP_df, on=['SUBJECT'], how='outer', indicator=True)

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
    else:
        campus_match = (row['CAMPUS_x'] == row['CAMPUS_y']) or (row['CAMPUS_x'] == 'ALL') or (row['CAMPUS_y'] == 'ALL')
    
    if row['SECTION_x'].isdigit():
        section_match = row['SECTION_x'] == row['SECTION_y']
    else:
        section_match = (row['MODIFIED_SECTION_x'] == row['MODIFIED_SECTION_y']) or \
                        (row['MODIFIED_SECTION_x'] == 'ALL' and row['SECTION_y'].isdigit()) or \
                        (row['MODIFIED_SECTION_y'] == 'ALL' and row['SECTION_x'].isdigit())
        
    # Exclude rows where ATTR is 'CONC' and SECTION is '2XX' or '3XX'
    hs_attr_section_rule = not ((row['ATTR'] == 'CONC') and ((row['SECTION_x'] == '2XX') or (row['SECTION_x'] == '3XX')))
    
    # All conditions must be true for the row to be included in the final DataFrame
    return crn_match and campus_match and section_match and hs_attr_section_rule

def fee_type(freq):
    if freq in ['Per Course', 'Per Term']:
        return 'FLAT'
    else:
        return 'CRED'
    
def detail_code(det):
    if det in ['Digital Content Fee']:
        return 'A392' # change for spring term
    else:
        return 'A382'# change for spring term

result_df['FEE TYPE'] = result_df['FREQUENCY'].apply(fee_type)
result_df['DETAIL CODE'] = result_df['EXPLANATION'].apply(detail_code)
result_df = result_df[result_df.apply(custom_filter, axis=1)]
print(result_df.columns)

# Filter for unmatched entries (where any join key is NaN)
unmatched_df = full_outer_df[full_outer_df['_merge'] != 'both']
unmatched_df = unmatched_df[['SEMESTER', 'SSADETL CRN', 'SUBJECT', 'CRN_x', 'CRN_y', 'SECTION_x', 'SECTION_y', 'CAMPUS_x', 'CAMPUS_y', 'ATTR', 'FY25 FEE AMOUNT', 'COURSE NAME', 'FREQUENCY', 'EXPLANATION']]
unmatched_df.columns = ['TERM', 'SSADETL CRN', 'SUBJECT', 'Orig CRN', 'WIP CRN', 'Orig SECTION', 'WIP SECTION', 'ORIG CAMPUS', 'WIP CAMPUS', 'ATTR', '202520 FEE AMOUNT', 'COURSE NAME', 'FREQUENCY', 'EXPLANATION']
unmatched_df = unmatched_df.sort_values(by=['SUBJECT', 'SSADETL CRN'], ascending = [True, True])

final_df = result_df[['SEMESTER', 'SSADETL CRN', 'SUBJECT', 'CRN_x', 'CRN_y', 'SECTION_x', 'SECTION_y', 'CAMPUS_x', 'CAMPUS_y', 'ATTR', 'FY25 FEE AMOUNT', 'COURSE NAME', 'FEE TYPE', 'FREQUENCY', 'DETAIL CODE', 'EXPLANATION']]
final_df.columns = ['TERM', 'SSADETL CRN', 'SUBJECT', 'Orig CRN', 'WIP CRN', 'Orig SECTION', 'WIP SECTION', 'ORIG CAMPUS', 'WIP CAMPUS', 'ATTR', '202520 FEE AMOUNT', 'COURSE NAME', 'FEE TYPE', 'FREQUENCY','DETAIL CODE', 'EXPLANATION']
final_df = final_df.sort_values(by=['SUBJECT', 'SSADETL CRN'], ascending = [True, True])

# Display the top of the final dataframe
print(final_df.head())
print(f'Matched DF is {len(final_df)}')
print(f'Unmatched DF is {len(unmatched_df)}')

result_df.to_excel(filepath + 'Full output.xlsx', index=False)
full_outer_df.to_excel(filepath + 'Full output O.xlsx', index=False)

unmatched_df.to_excel(unmatched_output, index=False)

final_df.to_excel(Output, index=False)
