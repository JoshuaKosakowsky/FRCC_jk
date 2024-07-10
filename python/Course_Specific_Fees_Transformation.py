import pandas as pd
import re

filepath = 'c:/'
cccs_file = 'FY25 Tuition and Fees Template - Final Board Approved.xlsx'
CCCS = filepath + cccs_file
New_fees = 'Table 4 - New Fee'
Chng_to_exst = 'Table 5 - Changes to existing'
No_chng = 'Table 6 - No Changes'
Other_new_n_exst = 'Table 7-Other New & Exist fee'

t4 = 'New Fee T4.xlsx'
t4_output = filepath + t4

t5 = 'Changes T5.xlsx'
t5_output = filepath + t5

t6 = 'No Changes T6.xlsx'
t6_output = filepath + t6

t7 = 'Other New & Existing Fees.xlsx'
t7_output = filepath + t7

final_output_name = 'Course Specific Fees 2025 - Josh.xlsx'
output = filepath + final_output_name

final_df_name = 'Course Specific Fees 202520 Final Test.xlsx'
final_df = filepath + final_df_name

'''
Manually clean data from the excel worksheet.
Especially Tab 6, add commas after campuses in column, and =TEXTJOIN 3 course and 4 course, then paste as values into 4 course.
'''

#complete_df = pd.read_excel(CCCS, sheet_name=[New_fees, Chng_to_exst, No_chng, Other_new_n_exst])
tab4_df = pd.read_excel(CCCS, sheet_name=New_fees, skiprows=21)
tab5_df = pd.read_excel(CCCS, sheet_name=Chng_to_exst, skiprows=8)
tab6_df = pd.read_excel(CCCS, sheet_name=No_chng, skiprows=9)
tab7_df = pd.read_excel(CCCS, sheet_name=Other_new_n_exst, skiprows=7)

campuses = ['FBC', 'FBO', 'FBX', 'FCN', 'FCW', 'FCX', 'FCY', 'FCZ', 'FLC', 'FLO', 'FLX', 'FON', 'FWC', 'FWO', 'FWX', 'FZZ', 'CW', 'BR', 'BCC', 'LC', 'OL', 'WC', 'FRCC Online']


# DF CREATION Per Tab
# TAB 4 - NEW FEES
tab4_frcc_df = tab4_df[tab4_df['College'] == 'FRCC']
tab4_COPS_df = tab4_df[tab4_df['College'] == 'Colorado Online@ Pooled Sections']
tab4_df = pd.concat([tab4_frcc_df, tab4_COPS_df], ignore_index=True)

# TAB 5 CHANGES TO EXISTING
tab5_frcc_df = tab5_df[tab5_df['College'] == 'FRCC']
tab5_COPS_df = tab5_df[tab5_df['College'] == 'Colorado Online@ Pooled Sections']
tab5_df = pd.concat([tab5_frcc_df, tab5_COPS_df], ignore_index=True)
tab5_frcc_df['Course # (Current 3 Digit)'] = tab5_frcc_df['Course # (Current 3 Digit)'].astype(str)
tab5_COPS_df['Course # (Current 3 Digit)'] = tab5_COPS_df['Course # (Current 3 Digit)'].astype(str)
tab5_df['Course # (Current 3 Digit)'] = tab5_df['Course # (Current 3 Digit)'].astype(str)

# TAB 6 - NO CHANGES
tab6_frcc_df = tab6_df[tab6_df['College'] == 'FRCC']
tab6_COPS_df = tab6_df[tab6_df['College'] == 'Colorado Online@ Pooled Sections']
tab6_df = pd.concat([tab6_frcc_df, tab6_COPS_df], ignore_index=True)
tab6_frcc_df['Course # (Current 3 Digit)'] = tab6_frcc_df['Course # (Current 3 Digit)'].astype(str)
tab6_COPS_df['Course # (Current 3 Digit)'] = tab6_COPS_df['Course # (Current 3 Digit)'].astype(str)
tab6_df['Course # (Current 3 Digit)'] = tab6_df['Course # (Current 3 Digit)'].astype(str)

'''
# TAB 7 - Other New & Existing Fees
tab7_frcc_df = tab7_df[tab7_df['College'] == 'FRCC']
tab7_COPS_df = tab7_df[tab7_df['College'] == 'Colorado Online@ Pooled Sections']
tab7_df = pd.concat([tab7_frcc_df, tab7_COPS_df], ignore_index=True)
tab7_df['Course # (Current 3 Digit)'] = tab7_df['Course # (Current 3 Digit)'].astype(str)
'''

# Functions to clean data
def course_clean_3digit(df):
    df['Course # (Current 3 Digit)'] = df['Course # (Current 3 Digit)'].str.upper()
    df['Course # (New 4 Digit)'] = df['Course # (New 4 Digit)'].str.upper()
    df['SUBJECT'] = df['Course # (Current 3 Digit)'].str[:3]  # First three characters are always the subject
    df['COURSE NUMBER'] = df['Course # (Current 3 Digit)'].apply(lambda x: re.search(r'(?<=\D)\d{4}', x))
    df['COURSE NUMBER'] = df['COURSE NUMBER'].apply(lambda x: x.group() if x else '')
    
    def get_remaining(entry):
        cleaned = re.sub(r'^[A-Z]{3}\s*\d{4}', '', entry).strip()
        if cleaned == entry:
            cleaned = re.sub(r'^[A-Z]{3}', '', entry).strip()
        cleaned = cleaned.replace('OXX', '0XX')
        if cleaned == '':
            return 'ALL ALL'
        return cleaned

    df['REMAINING'] = df['Course # (New 4 Digit)'].apply(get_remaining)

    return df

def course_clean_4digit(df):
    df['Course # (New 4 Digit)'] = df['Course # (New 4 Digit)'].str.upper()
    df['SUBJECT'] = df['Course # (New 4 Digit)'].str[:3]  # First three characters are always the subject
    df['COURSE NUMBER'] = df['Course # (New 4 Digit)'].apply(lambda x: re.search(r'(?<=\D)\d{4}', x))
    df['COURSE NUMBER'] = df['COURSE NUMBER'].apply(lambda x: x.group() if x else '')
    
    def get_remaining(entry):
        cleaned = re.sub(r'^[A-Z]{3}\s*\d{4}', '', entry).strip()
        if cleaned == entry:
            cleaned = re.sub(r'^[A-Z]{3}', '', entry).strip()
        cleaned = cleaned.replace('OXX', '0XX')
        if cleaned == '':
            return 'ALL ALL'
        return cleaned

    df['REMAINING'] = df['Course # (New 4 Digit)'].apply(get_remaining)

    return df

def extract_section_campus(text):
    # Normalize spaces and ensure uniform comma spacing
    text = re.sub(r'\s*,\s*', ',', re.sub(r'\s+', ' ', text.strip())).strip(',')
    
    # Handle special cases explicitly
    if text == 'CW All' or text == 'CW All Sections':
        return [('ALL', 'FCW')]
    if text == '- All Sections':
        return [('ALL', 'ALL')]

    # Normalize spaces and commas, then split by commas
    parts = [part.strip() for part in re.split(r',|/', text) if part.strip()]
    results = []
    # Regex to match campus and section patterns
    section_pattern = r'(\d{1,2}X{1,2}|\d{3})'
    campus_pattern = r'([A-Z]{2,3})$'
    for part in parts:
        # Find all section codes
        sections = re.findall(section_pattern, part)
        # Find campus code at the end of the string
        campus_match = re.search(campus_pattern, part)
        campus = campus_match.group(1) if campus_match and campus_match.group(1) in campuses else 'ALL'
        # Append results
        if sections:
            for section in sections:
                results.append((section, campus))
        else:
            # If no sections are found, assume 'ALL' sections
            results.append(('ALL', campus))

    return results

def expand_processed_data(df, processed_col_name):
    # Check if the data needs to be converted from string to list of tuples
    if isinstance(df[processed_col_name].iloc[0], str):
        df[processed_col_name] = df[processed_col_name].apply(eval)

    # Explode the 'PROCESSED' data into new rows
    sections_campuses = df[processed_col_name].explode()
    expanded_df = pd.DataFrame(sections_campuses.tolist(), columns=['SECTION', 'CAMPUS'], index=sections_campuses.index)

    # Merge the expanded SECTION and CAMPUS back to the original dataframe
    processed_df = df.drop(columns=[processed_col_name]).join(expanded_df)
    
    return processed_df


# TAB 4 FRCC DATA CLEANING AND OUTPUT
tab4_frcc_df_part1 = course_clean_4digit(tab4_frcc_df)
tab4_frcc_df_part1['PROCESSED'] = tab4_frcc_df_part1['REMAINING'].apply(extract_section_campus)
tab4_frcc_df_part2 = expand_processed_data(tab4_frcc_df_part1, 'PROCESSED')
print("Tab 4 FRCC New Fees")
print(tab4_frcc_df_part2.head())
# TAB 4 CO ONLINE DATA CLEANING AND OUTPUT
tab4_COPS_df_part1 = course_clean_4digit(tab4_COPS_df)
tab4_COPS_df_part1['PROCESSED'] = tab4_COPS_df_part1['REMAINING'].apply(extract_section_campus)
tab4_COPS_df_part2 = expand_processed_data(tab4_COPS_df_part1, 'PROCESSED')
print("Tab 4 CO Online New Fees")
print(tab4_COPS_df_part2.head())

# TAB 4 DATA CLEANING AND OUTPUT
df4_part1 = course_clean_4digit(tab4_df)
df4_part1['PROCESSED'] = df4_part1['REMAINING'].apply(extract_section_campus)
df4_part2 = expand_processed_data(df4_part1, 'PROCESSED')
print(df4_part2.head())
df4_part2.to_excel(t4_output, index=False)

# TAB 5 FRCC DATA CLEANING AND OUTPUT
tab5_frcc_df_part1 = course_clean_4digit(tab5_frcc_df)
tab5_frcc_df_part1['PROCESSED'] = tab5_frcc_df_part1['REMAINING'].apply(extract_section_campus)
tab5_frcc_df_part2 = expand_processed_data(tab5_frcc_df_part1, 'PROCESSED')
print("Tab 5 FRCC New Fees")
print(tab5_frcc_df_part2.head())
# TAB 5 CO ONLINE DATA CLEANING AND OUTPUT
tab5_COPS_df_part1 = course_clean_4digit(tab5_COPS_df)
tab5_COPS_df_part1['PROCESSED'] = tab5_COPS_df_part1['REMAINING'].apply(extract_section_campus)
tab5_COPS_df_part2 = expand_processed_data(tab5_COPS_df_part1, 'PROCESSED')
print("Tab 5 CO Online New Fees")
print(tab5_COPS_df_part2.head())

# TAB 5 DATA CLEANING AND OUPUT
df5_part1 = course_clean_3digit(tab5_df)
df5_part1['PROCESSED'] = df5_part1['REMAINING'].apply(extract_section_campus)
df5_part2 = expand_processed_data(df5_part1, 'PROCESSED')
print(df5_part2.head())
df5_part2.to_excel(t5_output, index=False)


# TAB 6 FRCC DATA CLEANING AND OUTPUT
tab6_frcc_df_part1 = course_clean_4digit(tab6_frcc_df)
tab6_frcc_df_part1['PROCESSED'] = tab6_frcc_df_part1['REMAINING'].apply(extract_section_campus)
tab6_frcc_df_part2 = expand_processed_data(tab6_frcc_df_part1, 'PROCESSED')
print("Tab 6 FRCC New Fees")
print(tab6_frcc_df_part2.head())
# TAB 6 CO ONLINE DATA CLEANING AND OUTPUT
tab6_COPS_df_part1 = course_clean_4digit(tab6_COPS_df)
tab6_COPS_df_part1['PROCESSED'] = tab6_COPS_df_part1['REMAINING'].apply(extract_section_campus)
tab6_COPS_df_part2 = expand_processed_data(tab6_COPS_df_part1, 'PROCESSED')
print("Tab 6 CO Online New Fees")
print(tab6_COPS_df_part2.head())


# TAB 6 DATA CLEANING AND OUPUT
df6_part1 = course_clean_3digit(tab6_df)
df6_part1['PROCESSED'] = df6_part1['REMAINING'].apply(extract_section_campus)
df6_part2 = expand_processed_data(df6_part1, 'PROCESSED')
print(df6_part2.head())
df6_part2.to_excel(t6_output, index=False)


'''
# NO DATA FROM TAB 7 AT THIS TIME
# TAB 7 DATA CLEANING AND OUPUT
df7_part1 = course_clean_3digit(tab6_df)
df7_part1['PROCESSED'] = df7_part1['REMAINING'].apply(extract_section_campus)
df7_part2 = expand_processed_data(df7_part1, 'PROCESSED')
print(df7_part2.head())
#df7_part2.to_excel(t7_output, index=False)
'''

frcc_output = pd.concat([tab4_frcc_df_part2, tab5_frcc_df_part2, tab6_frcc_df_part2], ignore_index=True)
COPS_ouptut = pd.concat([tab4_COPS_df_part2, tab5_COPS_df_part2, tab6_COPS_df_part2], ignore_index=True)

# Drop rows where "CAMPUS" is 'BR' - Campus shut down as of 2023
frcc_output = frcc_output[~frcc_output['CAMPUS'].str.contains('BR', na=False)]

frcc_output = frcc_output.sort_values(by=['SUBJECT', 'COURSE NUMBER'], ascending = [True, True])
#frcc_output = frcc_output.sort_values(by=['SUBJECT', 'COURSE NUMBER', 'SECTION'], ascending = [True, True, True]) # For manual data comparison
COPS_ouptut = COPS_ouptut.sort_values(by=['SUBJECT', 'COURSE NUMBER'], ascending = [True, True])

frcc_output = frcc_output[['College', 'SUBJECT', 'COURSE NUMBER', 'SECTION', 'CAMPUS', 'Course Name', 'New FY25 Fee Amount', 'Frequency', 'Explanation', 'Course # (Current 3 Digit)', 'Course # (New 4 Digit)']]
COPS_ouptut = COPS_ouptut[['College', 'SUBJECT', 'COURSE NUMBER', 'SECTION', 'CAMPUS', 'Course Name', 'New FY25 Fee Amount', 'Frequency', 'Explanation', 'Course # (Current 3 Digit)', 'Course # (New 4 Digit)']]

with pd.ExcelWriter(final_df, engine='openpyxl') as writer:
    frcc_output.to_excel(writer, sheet_name="FRCC")
    COPS_ouptut.to_excel(writer, sheet_name="CO Pooled")
