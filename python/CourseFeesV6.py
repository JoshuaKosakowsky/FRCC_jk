import pandas as pd

filepath = 'c:/'
Path_Orig = 'c:/'
Path_WIP = 'c:/'

output_name = '202520CourseFees_Updated.xlsx'
Output = filepath + output_name

Orig_df = pd.read_excel(Path_Orig)
WIP_df = pd.read_excel(Path_WIP)

# Convert CRN and CAMPUS columns to string in both DataFrames
for col in ['CRN', 'CAMPUS', 'SECTION']:
    Orig_df[col] = Orig_df[col].astype(str)
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

result_df = pd.merge(Orig_df, WIP_df, on=['SUBJECT'], how='inner')

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
    
    # All conditions must be true for the row to be included in the final DataFrame
    return crn_match and campus_match and section_match

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

final_df = result_df[['SEMESTER', 'SSADETL', 'SUBJECT', 'CRN_x', 'CRN_y', 'SECTION_x', 'SECTION_y', 'CAMPUS_x', 'CAMPUS_y', 'ATTR', 'FY25 FEE AMOUNT', 'FEE TYPE', 'COURSE NAME', 'FREQUENCY', 'DETAIL CODE', 'EXPLANATION']]
final_df.columns = ['TERM', 'SSADETL CRN', 'SUBJECT', 'Orig CRN', 'WIP CRN', 'Orig SECTION', 'WIP SECTION', 'ORIG CAMPUS', 'WIP CAMPUS', 'ATTR', '202520 FEE AMOUNT', 'FEE TYPE', 'COURSE NAME', 'FREQUENCY','DETAIL CODE', 'EXPLANATION']

# Display the top of the final dataframe
print(final_df.head())
print(len(final_df))

final_df.to_excel(Output, index=False)
