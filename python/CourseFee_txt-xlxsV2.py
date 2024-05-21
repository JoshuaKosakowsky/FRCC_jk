import pandas as pd

file_path = 'c:/Users/Joshu/OneDrive/Job/FRCC/Tuition Test/Course Fees/Course fee listing 5.13.24.txt'
output_path = 'c:/Users/Joshu/OneDrive/Job/FRCC/Tuition Test/Course Fees/CourseListingFeesV5.xlsx'
# You might need to adjust the separator if your file uses a delimiter other than a comma
df = pd.read_csv(file_path, delimiter=',', quotechar='"')


# Function to clean column names
def clean_column_names(df):
    # Remove leading and trailing quotation marks if they exist in column names
    df.columns = df.columns.str.strip('"')
    # Remove any non-alphanumeric characters at the start and end, and replace inner non-alphanumeric with underscores
    df.columns = df.columns.str.replace(r'^[^\w]*|[^\w]*$', '', regex=True).str.replace(r'[^\w]+', '_', regex=True)
def sanitize_data(df):
    # Apply a universal cleaning for non-ASCII characters in all object (string) columns
    str_cols = df.select_dtypes(include='object').columns
    df[str_cols] = df[str_cols].applymap(lambda x: ''.join([i if ord(i) < 128 else '' for i in x]) if isinstance(x, str) else x)

# Clean the column names
clean_column_names(df)
sanitize_data(df)

# Now you can manipulate the DataFrame `df` as needed
# For example, let's assume you want to add a new column based on existing data
rename_columns = {
    'SSBSECT_VPDI_CODE': 'COLLEGE',
    'SSBSECT_TERM_CODE': 'SEMESTER',
    'SSBSECT_CRN': 'SSADETL',
    'SSBSECT_SUBJ_CODE': 'SUBJECT',
    'SSBSECT_CRSE_NUMB': 'CRN',
    'SSBSECT_SEQ_NUMB': 'SECTION',
    'SSBSECT_CAMP_CODE': 'CAMPUS',
    'SSBSECT_LAB_HR': 'LAB HR',
    'SSBSECT_LEC_HR': 'LEC HR',
    'SSBSECT_OTH_HR': 'OTH HR',
    'SSRATTR_ATTR_CODE': 'ATTR',
    'SSRFEES_DETL_CODE': 'DET CODE',
    'SSRFEES_AMOUNT': 'AMOUNT'
}

# Renaming the columns
df.rename(columns=rename_columns, inplace=True, errors = 'ignore')

# Drop columns
df.drop(['COLLEGE', 'SSBSECT_CREDIT_HRS', 'SSBSECT_BILL_HRS', 'SSBSECT_ENRL', 'SSBSECT_WAIT_COUNT', 'SSBSECT_PRNT_IND', 'SSBSECT_PTRM_CODE', 'SSBSECT_PTRM_START_DATE', 'SSBSECT_PTRM_END_DATE', 'SSBSECT_CENSUS_ENRL_DATE', 'SSRATTR_ACTIVITY_DATE', 'SSRFEES_FEE_IND', 'SSBOVRR_COLL_CODE', 'SSBOVRR_DEPT_CODE', 'SSBOVRR_DIVS_CODE', 'SSBOVRR_TOPS_CODE', 'sSSRMEET_START_DATE', 'SSRMEET_END_DATE', 'SSRMEET_BEGIN_TIME', 'SSRMEET_END_TIME', 'SSRMEET_CATAGORY', 'SSRMEET_SUN_DAY', 'SSRMEET_MON_DAY', 'SSRMEET_TUE_DAY', 'SSRMEET_WED_DAY', 'SSRMEET_THU_DAY', 'SSRMEET_FRI_DAY', 'SSRMEET_SAT_DAY'], axis=1, inplace=True)

# Drop duplicates based on the 'SSADETL' column
df.drop_duplicates(subset='SSADETL', inplace=True)
# Drop rows where "SECTION" matches the regex pattern '38[A-Z]'
df = df[~df['CAMPUS'].str.contains('FCX', na=False)]
df = df[~df['CAMPUS'].str.contains('FCZ', na=False)]
df = df[~df['CAMPUS'].str.contains('FZZ', na=False)]
#df = df[~df['CAMPUS'].str.contains('FCW', na=False)] #Return to this later
df = df[~df['SECTION'].str.contains(r'37[A-Z]', na=False)]
#df = df[~((df['SECTION'].str.contains(r'38[A-Z]', na=False)) & ~(df['CAMPUS'].isin(['FWO', 'FWC'])))]
df = df[~((df['SECTION'].str.contains(r'38[A-Z]', na=False)) & ~((df['CAMPUS'].isin(['FWO', 'FWC'])) & (df['ATTR'] == 'CONC')))]
df = df[~df['SECTION'].str.contains(r'39[A-Z]', na=False)]


df.sort_values(by='SUBJECT', inplace=True)
df.to_excel(output_path, index=False)  # index=False ensures that the row indices are not written to the file

# Check if the renaming was applied
print("Renamed Column Names:", df.columns.tolist())

#print(df.head())
