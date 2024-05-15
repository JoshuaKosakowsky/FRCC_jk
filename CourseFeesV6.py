import pandas as pd

# Load your Excel files

Mac_path_Orig = '/Users/kozy/Library/CloudStorage/OneDrive-Personal/Job/FRCC/Tuition Test/Course Fees/CleanedOriginalV4.xlsx'
Mac_path_WIP = '/Users/kozy/Library/CloudStorage/OneDrive-Personal/Job/FRCC/Tuition Test/Course Fees/WIPV4.xlsx'
#PC
PC_path_Orig = 'c:/Users/Joshu/OneDrive/Job/FRCC/Tuition Test/Course Fees/CleanedOriginal10.xlsx'
PC_path_WIP = 'c:/Users/Joshu/OneDrive/Job/FRCC/Tuition Test/Course Fees/CourseListingFeesV5.xlsx'

Orig_df = pd.read_excel(PC_path_Orig)
WIP_df = pd.read_excel(PC_path_WIP)

# Convert CRN and CAMPUS columns to string in both DataFrames
for col in ['CRN', 'CAMPUS', 'SECTION']:
    Orig_df[col] = Orig_df[col].astype(str)
    WIP_df[col] = WIP_df[col].astype(str)

# Function to modify campus based
def modify_campus_and_section(df):
    def custom_logic(row):
        section = row['SECTION']
        # Check if the section length is at least 2 characters before accessing section[1]
        if len(section) >= 2:
            if section[1] == 'B':
                row['CAMPUS'] = 'FBC' if row['CAMPUS'] == 'FCW' else row['CAMPUS']
            elif section[1] == 'L':
                row['CAMPUS'] = 'FLC' if row['CAMPUS'] == 'FCW' else row['CAMPUS']
            elif section[1] == 'W':
                row['CAMPUS'] = 'FWC' if row['CAMPUS'] == 'FCW' else row['CAMPUS']
        return row
    return df.apply(custom_logic, axis=1)

# Apply the campus override
Orig_df = modify_campus_and_section(Orig_df)
WIP_df = modify_campus_and_section(WIP_df)

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

# Apply the modified function to the SECTION columns in both dataframes
Orig_df['MODIFIED_SECTION'] = Orig_df['SECTION'].apply(modify_for_matching)
WIP_df['MODIFIED_SECTION'] = WIP_df['SECTION'].apply(modify_for_matching)

# Perform the merge using SUBJECT and CRN
result_df = pd.merge(Orig_df, WIP_df, on=['SUBJECT'], how='inner')

# Apply a custom filter function to handle modified SECTION matches, 'ALL', campus compatibility, and numeric checks
def custom_filter(row):
    # Handle CRN matching where 'ALL' in either DataFrame matches any CRN value from the other DataFrame
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
    
    # Handle Section matching based on modified sections
    section_match = (row['MODIFIED_SECTION_x'] == row['MODIFIED_SECTION_y']) or \
                    (row['MODIFIED_SECTION_x'] == 'ALL' and row['SECTION_y'].isdigit()) or \
                    (row['MODIFIED_SECTION_y'] == 'ALL' and row['SECTION_x'].isdigit())
    
    # All conditions must be true for the row to be included in the final DataFrame
    return crn_match and campus_match and section_match

# Apply the custom filter
result_df = result_df[result_df.apply(custom_filter, axis=1)]
print(result_df.columns)

# Select and rename columns for the final output
### ADD LATER - ['COURSE NAME', 'FREQUENCY', 'EXPLANATION'] ###
final_df = result_df[['SSADETL', 'SUBJECT', 'CRN_x', 'CRN_y', 'SECTION_x', 'SECTION_y', 'CAMPUS_x', 'CAMPUS_y', 'FY25 FEE AMOUNT', 'COURSE NAME', 'FREQUENCY', 'EXPLANATION']]
final_df.columns = ['SSADETL', 'SUBJECT', 'Orig CRN', 'WIP CRN', 'Orig SECTION', 'WIP SECTION', 'ORIG CAMPUS', 'WIP CAMPUS', 'FY25 Fee Amount', 'COURSE NAME', 'FREQUENCY', 'EXPLANATION']

# Display the top of the final dataframe
print(final_df.head())
print(len(final_df))

# Save the result to a new Excel file
Mac_output = '/Users/kozy/Library/CloudStorage/OneDrive-Personal/Job/FRCC/Tuition Test/Course Fees/UpdatedCourseFeesV4.xlsx'
PC_output = 'c:/Users/Joshu/OneDrive/Job/FRCC/Tuition Test/Course Fees/2025CourseFeesV1.xlsx'
final_df.to_excel(PC_output, index=False)
