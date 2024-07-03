import pandas as pd
import re

filepath = 'c:/'
cccs_file = 'FY25 Tuition and Fees Template - Final Board Approved.xlsx'
CCCS = filepath + cccs_file
New_fees = 'Table 4 - New Fee'
Chng_to_exst = 'Table 5 - Changes to existing'
No_chng = 'Table 6 - No Changes'
Other_new_n_exst = 'Table 7-Other New & Exist fee'

output_name = '.xlsx'
output = filepath + output_name

#complete_df = pd.read_excel(CCCS, sheet_name=[New_fees, Chng_to_exst, No_chng, Other_new_n_exst])
tab4_df = pd.read_excel(CCCS, sheet_name=New_fees, skiprows=21)
tab5_df = pd.read_excel(CCCS, sheet_name=Chng_to_exst, skiprows=9)
tab6_df = pd.read_excel(CCCS, sheet_name=No_chng, skiprows=9)
tab7_df = pd.read_excel(CCCS, sheet_name=Other_new_n_exst, skiprows=7)

tab4_frcc_df = tab4_df[tab4_df['College'] == 'FRCC']
tab4_COPS_df = tab4_df[tab4_df['College'] == 'Colorado Online@ Pooled Sections']
tab4_df = pd.concat([tab4_frcc_df, tab4_COPS_df], ignore_index=True)

campuses = ['FBC', 'FBO', 'FBX', 'FCN', 'FCW', 'FCX', 'FCY', 'FCZ', 'FLC', 'FLO', 'FLX', 'FON', 'FWC', 'FWO', 'FWX', 'FZZ', 'CW', 'BR', 'BCC', 'LC', 'OL', 'WC']

def course_clean(df):
    df['SUBJECT'] = df['Course # (New 4 Digit)'].str[:3]  # First three characters are always the subject
    df['COURSE NUMBER'] = df['Course # (New 4 Digit)'].apply(lambda x: re.search(r'(?<=\D)\d{4}', x))
    df['COURSE NUMBER'] = df['COURSE NUMBER'].apply(lambda x: x.group() if x else '')
    
    def get_remaining(entry):
        cleaned = re.sub(r'^[A-Z]{3}\s*\d{4}', '', entry).strip()
        if cleaned == entry:
            cleaned = re.sub(r'^[A-Z]{3}', '', entry).strip()
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
    parts = [part.strip() for part in text.split(',') if part.strip()]
    results = []
    # Regex to match campus and section patterns
    section_pattern = r'(\d{1,2}X{1,2})'
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

df4_part1 = course_clean(tab4_df)
df4_part1['PROCESSED'] = df4_part1['REMAINING'].apply(extract_section_campus)
df4_part2 = expand_processed_data(df4_part1, 'PROCESSED')

print(df4_part2.head())

df4_part2.to_excel(output, index=False)
