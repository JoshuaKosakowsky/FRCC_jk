'''
This is a fresh start to the Rate Table code. 
I will be copying code from the three other scripts here in an effort clean the code and resolve issues with output.
'''

'''Note**** 
Don't Forget to change the Detail Codes depedning on the term on lines 267 & 269
(May find a way to incorporate the Term Code to self assign what the detail code should be (end in 10, 20, or 30))
'''
# First step will be to install necessary packages the script before breaking down the individual processes

import pandas as pd
import numpy as np
from datetime import datetime
import re

'''
Universal function(s) and variable(s) to be used throughout.
'''

# Function to get the current date for file renaming.
def get_current_date():
    current_date = datetime.now()
    formatted_date = current_date.strftime("%m-%d-%y")
    return formatted_date

current_date = get_current_date()
csv_doc = current_date + '.csv'
xlsx_doc = '_' + current_date + '.xlsx'

'''
Next we will create paths to our folder directories for easy management
'''

# Path to the specific folder were all the tables are saved to
filepath = 'c:/Users/S03112819/OneDrive - Colorado Community College System/AR/Course Fees/Current Project/'

# The file from Banner (Course Fee Listing) that has all the data about current courses per term.
BANNER_CourseFeeListing = 'gokoutp.csv' # input file
Cleaned_CFL = f'Cleaned_CFL{xlsx_doc}' # output file

# The file from Lori/Dina pertaining to the New Course Specific Fees for the fiscal year.
FRCC_CourseSpecificFees = 'Course Specific Fees.xlsx'
Cleaned_CSF = f'Cleaned Course Specific Fees{xlsx_doc}'

# This file is the final combined output from the Course Fee Listing and Course Specific Fees.
Rate_Table = f'Rate Table{xlsx_doc}'

# Add more below as they become needed

'''
Next, we will focus on loading and cleaing the gokoutp.csv file from Banner
This file is the list of all current courses offered at CRN for a specific term
'''

# The below out code is working as expected for the Course Fee Listing from Banner, onto the next section.

# Loading in the dataset so Python can manipulate it.
df_B_CFL = pd.read_csv(filepath + BANNER_CourseFeeListing, delimiter=',', quotechar='"')

# Function to clean column names
def clean_column_names(df):
    
    # Remove leading and trailing quotation marks if they exist in column names
    df.columns = df.columns.str.strip('"')

    # Remove any non-alphanumeric characters at the start and end, and replace inner non-alphanumeric with underscores
    # Necessary to remove the ♀ from the first column
    df.columns = df.columns.str.replace(r'^[^\w]*|[^\w]*$', '', regex=True).str.replace(r'[^\w]+', '_', regex=True)

# Applying the function to clean the data
clean_column_names(df_B_CFL)

# Creating a Dictionary to rename columns into something more human friendly
rename_columns = {
    'SSBSECT_TERM_CODE': 'SEMESTER',
    'SSBSECT_CRN': 'CRN',
    'SSBSECT_SUBJ_CODE': 'SUBJECT',
    'SSBSECT_CRSE_NUMB': 'COURSE NUMBER',
    'SSBSECT_SEQ_NUMB': 'SECTION',
    'SSBSECT_CAMP_CODE': 'CAMPUS',
    'SSRATTR_ATTR_CODE': 'ATTR',
    'SSRFEES_DETL_CODE': 'DET CODE',
    'SSRFEES_AMOUNT': 'AMOUNT'
                }

# Renaming the columns
df_B_CFL.rename(columns=rename_columns, inplace=True, errors = 'ignore')

# Drop columns
df_B_CFL.drop(['SSBSECT_VPDI_CODE','SSBSECT_CREDIT_HRS', 'SSBSECT_BILL_HRS', 'SSBSECT_ENRL', 'SSBSECT_WAIT_COUNT', 'SSBSECT_LAB_HR', 'SSBSECT_LEC_HR', 'SSBSECT_OTH_HR', 'SSBSECT_PRNT_IND', 'SSBSECT_PTRM_CODE', 'SSBSECT_ACTIVITY_DATE', 'SSBSECT_PTRM_START_DATE', 'SSBSECT_PTRM_END_DATE', 'SSBSECT_CENSUS_ENRL_DATE', 'SSRATTR_ACTIVITY_DATE', 'SSRFEES_FEE_IND', 'SSRFEES_LEVL_CODE', 'SSRFEES_FTYP_CODE', 'SSBOVRR_COLL_CODE', 'SSBOVRR_DEPT_CODE', 'SSBOVRR_DIVS_CODE', 'SSBOVRR_TOPS_CODE', 'SSRMEET_BLDG_CODE', 'SSRMEET_START_DATE', 'SSRMEET_END_DATE', 'SSRMEET_BEGIN_TIME', 'SSRMEET_END_TIME', 'SSRMEET_HRS_WEEK', 'SSRMEET_ROOM_CODE', 'SSRMEET_CATAGORY', 'SSRMEET_SUN_DAY', 'SSRMEET_MON_DAY', 'SSRMEET_TUE_DAY', 'SSRMEET_WED_DAY', 'SSRMEET_THU_DAY', 'SSRMEET_FRI_DAY', 'SSRMEET_SAT_DAY'], axis=1, inplace=True)


''' Some data manipulation to refine out output and ensure we catch CONC attributes and drop duplicates'''
# Function to remove any value from Attribute column that isn't CONC
def conc_only(value):
    if value != "CONC":
        return ""
    else:
        return "CONC"

# Creating a dataset only where CRN's have a CONC attribute
CONC_df_CFL = df_B_CFL[df_B_CFL['ATTR'] == 'CONC']

# Creating a dateset only where there is a unique value in amount.
Unique_AMT_df_CFL = df_B_CFL.dropna(subset=['AMOUNT']).drop_duplicates(subset=['CRN', 'AMOUNT'])
Unique_AMT_df_CFL['ATTR'] = Unique_AMT_df_CFL['ATTR'].apply(conc_only)

# Creating a dataset where amount is nan
na_amt_df_CFL = df_B_CFL[df_B_CFL['AMOUNT'].isna()].drop_duplicates(subset=['CRN', 'ATTR'])
na_amt_df_CFL['ATTR'] = na_amt_df_CFL['ATTR'].apply(conc_only)

# Concatenating the three created datasets above to drop duplicates the required way.
df_B_CFL = pd.concat([CONC_df_CFL, Unique_AMT_df_CFL, na_amt_df_CFL])

df_B_CFL['ATTR2'] = df_B_CFL['ATTR'].apply(lambda x: 'MISSING' if pd.isna(x) or x == '' else x)
df_B_CFL['AMOUNT2'] = df_B_CFL['AMOUNT'].fillna('MISSING')

df_B_CFL['ATTR'] = df_B_CFL['ATTR'].apply(conc_only)

df_B_CFL.sort_values(by=['CRN', 'ATTR'], ascending = [True, False], inplace=True)

df_B_CFL.to_excel(filepath + 'b4Drops.xlsx', index=False)

# Dropping duplicate values to ensure we are keeping any CONC that may have been dropped before this proccess
df_B_CFL = df_B_CFL.drop_duplicates(subset=['CRN', 'AMOUNT2'], keep='first')
df_B_CFL = df_B_CFL.drop(columns=['ATTR2', 'AMOUNT2'])

df_B_CFL.to_excel(filepath + 'afterDrops.xlsx', index=False)

df_B_CFL['SECTION'] = df_B_CFL['SECTION'].astype(str).str.zfill(3)


# Drop rows where "CAMPUS" is FCX, FCW, FCZ, or FZZ
df_B_CFL = df_B_CFL[~df_B_CFL['CAMPUS'].str.contains('FCX|FCW|FCZ|FZZ', na=False)]

# Drop rows where Section is High School (37X, 38X, 39X, or 78X), Campus is FWO or FWC, and the Attribute is Concurrent (CONC)
df_B_CFL = df_B_CFL[~((df_B_CFL['SECTION'].str.contains(r'37[A-Z]|38[A-Z]|39[A-Z]|78[A-Z]', na=False)) & ~((df_B_CFL['CAMPUS'].isin(['FWO', 'FWC'])) & (df_B_CFL['ATTR'] == 'CONC')))]

# Function to find HS courses and normalize them to all end in X or XX, have all else just end in XX except ALL
def modify_for_matching(value):
    if value == 'ALL':
        return 'ALL'
    else:
        section_str = str(value)
        if len(section_str) > 1 and section_str[:2] in ['37', '38', '39']:
            return section_str[:2] + 'X'
        else:
            return section_str[0] + 'XX'

df_B_CFL['MODIFIED_SECTION'] = df_B_CFL['SECTION'].apply(modify_for_matching)

# Function to remove any value from Attribute column that isn't CONC
def conc_only(value):
    if value != "CONC":
        return ""
    else:
        return "CONC"
    
df_B_CFL['ATTR'] = df_B_CFL['ATTR'].apply(conc_only)

# Sort values by SUBJECT then COURSE NUMBER 
df_B_CFL.sort_values(by=['SUBJECT', 'COURSE NUMBER'], ascending = [True, True], inplace=True)

print("\nInformation about the transformed Course Fee Listing Dataset\n",df_B_CFL.head(),"\n",f"Columns: {df_B_CFL.shape[1]} \nRows: {df_B_CFL.shape[0]}")
df_B_CFL.to_excel(filepath + Cleaned_CFL, index=False)


'''
Next, we will focus on loading and cleaing the Course Specific Fees file fr
This file is the list of all current courses offered at CRN for a specific term
'''

# Loading in the dataset so Python can manipulate it.
df_CSF = pd.read_excel(filepath + FRCC_CourseSpecificFees)

# Data Cleansing/Convert and Standardize the Data
df_CSF.columns = df_CSF.columns.str.upper().str.strip()

# Remove any white space from the string valueS in the columns below
df_CSF['CAMPUS'] = df_CSF['CAMPUS'].astype(str).str.strip()
df_CSF['SUBJECT'] = df_CSF['SUBJECT'].astype(str).str.strip()
df_CSF['SECTION'] = df_CSF['SECTION'].astype(str).str.strip()
df_CSF['FREQUENCY'] = df_CSF['FREQUENCY'].astype(str).str.strip()
df_CSF['EXPLANATION'] = df_CSF['EXPLANATION'].astype(str).str.strip()

# Replace variations of "ALL" with the actual word "ALL" for later assignments
df_CSF['CAMPUS'] = df_CSF['CAMPUS'].replace(['All', 'ALL', '', 'nan', 'NAN', np.nan], 'ALL')
df_CSF['COURSE NUMBER'] = df_CSF['COURSE NUMBER'].replace(['All', 'ALL', '', ' ', 'nan', 'NAN', np.nan], 'ALL')
df_CSF['SECTION'] = df_CSF['SECTION'].replace(['All', 'ALL', '', 'nan', 'NAN', np.nan], 'ALL')


# Utilize regex matching to remove any hyphens at the end of a string in "SECTION" with nothing.
df_CSF['SECTION'] = df_CSF['SECTION'].str.replace(r'-$', '', regex = True)

# Shorten the "EXPLANATION" column to a max of 30 characters.
df_CSF['EXPLANATION'] = df_CSF['EXPLANATION'].str.slice(0,30)

''' These functions below are to standardize the data, so each cell only has one value stored within for easier data manipulation'''
# Functions to split and expand rows by section so each entry is on it's own row.
def expand_rows(row):
    section = "ALL" if pd.isna(row['SECTION']) else str(row['SECTION']).strip()
    if section:
        sections = section.replace(' ', ',').split(',')
    else:
        sections = ["ALL"]
    
    new_rows = []
    for sec in sections:
        if sec:
            new_row = row.copy()
            new_row['SECTION'] = sec
            new_rows.append(new_row)
    return new_rows

# Function to expand rows so each campus gets its own row.
def expand_campuses(row):
    campus = str(row['CAMPUS']).strip() if pd.notna(row['CAMPUS']) else "ALL"
    campuses = [c.strip() for c in campus.split('/')]

    new_rows = []
    for camp in campuses:
        if camp:
            new_row = row.copy()
            new_row['CAMPUS'] = camp
            new_rows.append(new_row)
    return new_rows

# Applying the functions to the dataset

# Has to be a new variable, since expanded_rows returns a Series.
expanded_rows = df_CSF.apply(expand_rows, axis = 1)
df_CSF = pd.DataFrame([item for sublist in expanded_rows for item in sublist])

# Has to be a new variable, since expanded_campuses returns a Series.
expanded_campuses = df_CSF.apply(expand_campuses, axis = 1)
df_CSF = pd.DataFrame([item for sublist in expanded_campuses for item in sublist])

# Replace campus common name with BANNER Recognized name.
df_CSF['CAMPUS'] = df_CSF['CAMPUS'].replace({'BCC': 'FBC', 'LC': 'FLC', 'WC': 'FWC', 'OL': 'FCY'})


''' Functions to add required database information based off of existing data within the Course Specific Fees Dataset'''
# Function to return the Fee Type for SSADETL based off charges in the "FREQUENCY" column
def fee_type(freq):
    if freq in ['Per Course', 'Per Term']:
        return 'FLAT'
    else:
        return 'CRED'

# Matches detail codes for FRCC and CO Online
def detail_code(det, campus):
    if campus == 'FCY' or campus == 'FON':
        # CO Online Lab Kit Fee 'Lab Kit Fee'
        if np.isin(det, ['Lab Kit Fee', 'Lab Fee Kit', 'Lab Fee', 'Lab Kit']).any():
            return 'B730' 
        # CO Online Lab Fee "Lab Supplies"
        elif 'Lab Supplies' in det:
            return 'B731' 
        # CO Online Digital Content Fee 'Digital Content Fee'
        elif 'Digital Content Fee' in det:
            return 'B733'
        # CO Online Materials Fee # this is the else:
        else:
            return 'B732' 
    else:
        if det == 'Digital Content Fee':
            return 'A393' # A392 - FALL, A393 - SPRING, 'A394' Summer 
        else:
            return 'A384' # A383 - FALL, A384 - SPRING , 'A385' Summer # Course Specific Fee

# Applying the function to a new column called "Fee Type" based off the values from "FREQUENCY"
df_CSF['FEE TYPE'] = df_CSF['FREQUENCY'].apply(fee_type)

# Applying the function to a new column called "DETAIL CODE" based off the values from "EXPLANATION" and "CAMPUS"
df_CSF['DETAIL CODE'] = df_CSF.apply(lambda row: detail_code(row['EXPLANATION'], row['CAMPUS']), axis=1)

# Sort values by SUBJECT then COURSE NUMBER
df_CSF = df_CSF.sort_values(by=['SUBJECT', 'COURSE NUMBER'], ascending = [True, True])


print("\nInformation about the transformed Course Specific Fees Dataset\n",df_CSF.head(15),"\n",f"Columns: {df_CSF.shape[1]} \nRows: {df_CSF.shape[0]}")
df_CSF.to_excel(filepath + Cleaned_CSF, index=False)

'''
The code below is used to combine the two dataframes to match CRN's from the Course Fee Listing with Fees from the Course Specific Fees.
This in effect is the Rate Table and will be used to assign costs to courses.
'''

# Merging the two DataFrames together, with a indicator from where each duplicate column is from.
# Can only mergy by "SUBJECT". Cannot merge by "COURSE NUMBER" since there are a few subjects where ALL courses have a fee. (Like CSC)
df_RT = pd.merge(df_B_CFL, df_CSF, how='inner', on=['SUBJECT'], suffixes=('_CFL', '_CSF'))

# Creating a new Column "UNCHANGED" to see if the fee amount has is the same as what is in Banner's Course Fee Listing
df_RT['UNCHANGED'] = df_RT['FY25 FEE AMOUNT'] == df_RT['AMOUNT']

# Function to seperate HIGH and MED Attributes two dateframes (Since they are attribute costs, not course costs)
def filter_out_high_med_attr(df):

    # Filtering out "HIGH" or "MED" in the "EXPLANATION" column
    df = df[~((df['EXPLANATION'].str.contains('HIGH|MED', case=False, na=False)) & 
    # Filtering out where above criteria is met AND "FY25 FEE AMOUNT" == 8.85
        (df['FY25 FEE AMOUNT'] == 8.85))]

    return df

# Function to match the "MODIFIED_SECTION" to the "SECTION_CSF" column or both to "ALL"
#   Note* MODIFIED_SECTION is used because it is modified from SECTION_CFL to catch the first or second number and replace the rest with X(s)
def section_filter(row):
    section_match = (
    (row['MODIFIED_SECTION'] == row['SECTION_CSF']) or 
    (row['MODIFIED_SECTION'] == 'ALL') or 
    (row['SECTION_CSF'] == 'ALL')
                    )
    return section_match

# Function to match the "COURSE NUMBER_CFL" to the "COURSE NUMBER_CSF" column or both to "ALL"
def course_filter(row):

    course_match = (
    (row['COURSE NUMBER_CFL'] == row['COURSE NUMBER_CSF']) or 
    (row['COURSE NUMBER_CFL'] == 'ALL') or 
    (row['COURSE NUMBER_CSF'] == 'ALL')
                    )
    return course_match

# Function to filter out HS courses ('37X', '38X', '39X') when they match with "ALL" from the course_filter function
def dropHS_all(row):
    if row['MODIFIED_SECTION'] in ['37X', '38X', '39X'] and row['SECTION_CSF'] == 'ALL':
        return False
    return True

# Function to match the "CAMPUS_CFL" to the "CAMPUS_CSF" column Based off specific Campus codes for matching
def campus_filter(row):

    # Snippet to match Boulder Online campus with Boulder Online and Boulder Campus
    if row['CAMPUS_CFL'] == 'FBO':
        campus_match = row['CAMPUS_CSF'] in ['FBO', 'FBC']
    # Snippet to match Westminster Online campus with Westminster Online and Westminster Campus
    elif row['CAMPUS_CFL'] == 'FWO':
        campus_match = row['CAMPUS_CSF'] in ['FWO', 'FWC']
    # Snippet to match Fort Collins Online campus with Fort Collins Online and Fort Collins Campus
    elif row['CAMPUS_CFL'] == 'FLO':
        campus_match = row['CAMPUS_CSF'] in ['FLO', 'FLC']
    # Snippet to match Colorado Online campus with Online and Colorado Online
    elif row['CAMPUS_CFL'] == 'FCY':
        campus_match = row['CAMPUS_CSF'] in ['FON', 'FCY']
    # Snippet to match for "ALL" or the same campus code
    else:
        campus_match = (
                (row['CAMPUS_CFL'] == row['CAMPUS_CSF']) or
                (row['CAMPUS_CFL'] == 'ALL') or
                (row['CAMPUS_CSF'] == 'ALL')
                        )
    return campus_match

# Function to filter out Sections that aren't 2XX, 3XX, 37X, or 38X if the ATTR is CONC
def hs_filter(df):
        # Exclude rows where ATTR is 'CONC' and SECTION is '2XX' or '3XX' or '30X'
    df = df[~((df['ATTR'] == "CONC") &
              (df['MODIFIED_SECTION'].str.match(r'^(2XX|3XX|7XX)$', na=False)))]
    
    return df

# Applying all the functions to the DataFrame to futher refine the results
df_RT = filter_out_high_med_attr(df_RT)
df_RT = df_RT[df_RT.apply(section_filter, axis=1)]
df_RT = df_RT[df_RT.apply(campus_filter, axis=1)]
df_RT = df_RT[df_RT.apply(course_filter, axis=1)]
df_RT = df_RT[df_RT.apply(dropHS_all, axis=1)]
df_RT = hs_filter(df_RT)

def update_unchaged(group):
    has_match = group['AMOUNT'].isin(group['FY25 FEE AMOUNT']).any()
    if has_match:
        group.loc[:, 'UNCHANGED'] = True
    return group

df_RT = df_RT.groupby(['CRN'], group_keys=False).apply(update_unchaged)

df_RT = df_RT[df_RT['UNCHANGED'] | ~df_RT['AMOUNT'].isin(df_RT['FY25 FEE AMOUNT'])]

df_RT = df_RT.sort_values(by=['SUBJECT', 'COURSE NUMBER_CFL', 'CRN'], ascending = [True, True, True])

# Changing column order so related columns from the two datasets are near each other
column_order = ['SEMESTER', 'CRN', 'SUBJECT', 'COURSE NUMBER_CFL', 'COURSE NUMBER_CSF', 'SECTION_CFL', 'MODIFIED_SECTION', 'SECTION_CSF', 'CAMPUS_CFL', 'CAMPUS_CSF', 'ATTR', 'DET CODE', 'DETAIL CODE', 'AMOUNT', 'FY25 FEE AMOUNT', 'FEE TYPE', 'COURSE NAME', 'FREQUENCY', 'EXPLANATION', 'UNCHANGED']
df_RT = df_RT[column_order]

# Getting a quick preview of what the data will look like, along with the count of columns and rows, before creating an excel file.
print("\nInformation about the transformed Rate Table Dataset\n",df_RT.head(15),"\n",f"Columns: {df_RT.shape[1]} \nRows: {df_RT.shape[0]}")
df_RT.to_excel(filepath + Rate_Table, index=False)
