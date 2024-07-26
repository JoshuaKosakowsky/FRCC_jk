'''
This code snippet is being used to download the Y Batch FGIGLAC reports from Banner
'''

from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
from datetime import datetime
from openpyxl import load_workbook
from openpyxl.styles import NamedStyle
from decimal import Decimal, getcontext
import time
import pandas as pd
import numpy as np
import os
import shutil

# Credentials/BANNER page.
SNum = ''
P = ''
Search_key = 'FGIGLAC'

# Pathing to files for movement
Download_filepath = "c:/Users/Downloads/"
FGIGLAC_filepath = "c:/Users/"
YBPath_011042_113070 = "011042 113070/"
YBPath_011043_113070 = "011043 113070/"
YBPath_026010_113080 = "026010 113080/"
YBPath_026011_113080 = "026011 113080/"
YBPath_026012_113080 = "026012 113080/"

# Fund/Accounts (May make this an excel/csv in the future)
F_A = { 
        # Y BATCH files
        '011042': '113070',
        '011043': '113070',
        '026010': '113080', 
        '026011': '113080', 
        '026012': '113080',
        # Cash Log File
        '001010': '111010',
        # FUPLOAD
        '011010': '113400'
        }

# Function to get the current date for file renaming.
def get_current_date():
    current_date = datetime.now()
    formatted_date = current_date.strftime("%m-%d-%y")
    return formatted_date

current_date = get_current_date()
csv_doc = current_date + '.csv'
xlsx_doc = current_date + '.xlsx'

def move_and_rename_file(source_folder, destination_folder):
    source_file = os.path.join(source_folder, 'FGIGLAC.csv')

    if not os.path.exists(destination_folder):
        os.makedirs(destination_folder)

    if os.path.isfile(source_file):
        destination_file = os.path.join(destination_folder, f"FGIGLAC_{fund}_{acct}_{csv_doc}")

        # Move and Rename the file
        shutil.move(source_file, destination_file)
        print(f"Moved and renamed {source_file} to {destination_file}")
    else:
        print(f"No file named FGIGLAC.csv found in {source_folder}")

chrome_options = Options()
#chrome_options.add_argument("--headless")
chrome_options.add_argument("--window-size=1600,720")

try:
    service = Service(executable_path=ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=chrome_options)
    action = ActionChains(driver)
    driver.get('https://banner.cccs.edu/applicationNavigator/seamless')
    print("Found Webpage")

    wait = WebDriverWait(driver, 10)
    SNum_box = wait.until(EC.presence_of_element_located(
        (By.XPATH, "//input[@placeholder='ex: S########']")))
    SNum_box.send_keys(SNum)
    P_box = wait.until(EC.presence_of_element_located(
        (By.XPATH, "//input[@placeholder='Password']")))
    P_box.send_keys(P)
    SNum_box.send_keys(Keys.RETURN)
    print("Logged in")

    time.sleep(20)
    actionKeys = ActionChains(driver)
    actionKeys.key_down(Keys.CONTROL).key_down(Keys.SHIFT).send_keys('y').key_up(Keys.SHIFT).key_up(Keys.CONTROL).perform()
    time.sleep(0.5)
    print("ActionChain to open searchbar")

    screen_input = wait.until(EC.presence_of_element_located(
        (By.XPATH, "//input[@name = 'search']")))
    screen_input.send_keys(Search_key)
    screen_input.send_keys(Keys.RETURN)
    print(f"Searched for {Search_key}")

    driver.get(f'https://banner.cccs.edu/BannerAdmin/?form={Search_key}')
    print(f"Found {Search_key} Webpage")

    for fund, acct in F_A.items():
        try:
            # Input Fund
            fund_input = wait.until(EC.presence_of_element_located((
            By.ID, 'inp:keyblck_block_keyblckFundCode'
            )))
            print("Found Fund input box")
            fund_input.clear()
            print("Cleared Fund box")
            time.sleep(1)
            fund_input.send_keys(str(fund))
            print(f"Input {fund}")
            # Repeating cycle so it enters correctly
            fund_input.clear()
            print("Cleared Fund box")
            time.sleep(1)
            fund_input.send_keys(str(fund))
            print(f"Input {fund} again")
            time.sleep(1)

            # Input Acct
            acct_input = wait.until(EC.presence_of_element_located((
            By.ID, 'inp:keyblck_block_keyblckAcctCode'
            )))
            print("Found Acct input box")
            acct_input.clear()
            print("Cleared Acct box")
            time.sleep(1)
            acct_input.send_keys(str(acct))
            print(f"Input {acct}")
            # Repeating cycle so it enters correctly
            acct_input.clear()
            print("Cleared Acct box")
            time.sleep(1)
            acct_input.send_keys(str(acct))
            print(f"Input {acct} again")
            time.sleep(1)

            # Using action keys to progress until I figure out the html.

            # Chain to go to next page
            actionKeys.key_down(Keys.ALT).key_down(Keys.PAGE_DOWN).perform()
            print("Action Chain to progress to next page")
            time.sleep(2)  

            #GO_Button = wait.until(EC.presence_of_element_located((
            #By.CLASS_NAME, 'ui-widget ui-button btn btn-default ui-state-default ui-button-text-only mode-edit'
            #)))
            #print("Found the GO button")
            #GO_Button.click()
            #time.sleep(1)

            GO_Button_2 = wait.until(EC.presence_of_element_located((
            By.XPATH, "(//button[@class='primary-button ui-buttonGo'])[1]"
            )))
            print("Found the GO button to bring up data for download")
            GO_Button_2.click()
            time.sleep(3)

            Tools_Dropdown = wait.until(EC.presence_of_element_located((
            By.XPATH, "/html[1]/body[1]/nav[5]/div[1]/div[2]/ul[1]/li[6]/a[1]"
            )))
            print("Found the tools dropdown menu")
            Tools_Dropdown.click()
            time.sleep(1)

            Export_csv = wait.until(EC.presence_of_element_located((
            By.XPATH, "(//a[@title='Export'])[1]"
            )))
            print("Found the Export button")
            Export_csv.click()
            print(f"FGIGLAC.csv for F: {fund} A: {acct} has started downloading")
            time.sleep(2)

            move_and_rename_file(Download_filepath,FGIGLAC_filepath)

            start_over_button = wait.until(EC.presence_of_element_located((
            By.XPATH, "/html[1]/body[1]/div[1]/div[1]/div[2]/div[1]/div[1]/form[1]/div[2]/button[2]"
            )))
            print("Found the Start Over button")
            start_over_button.click()
            print("Clicked the Start Over button")
            time.sleep(2)

        except KeyboardInterrupt:
            print("Process interrupted by user.")
        except Exception as e:
            print("An error occurred:")#(f"An error occurred: {e}")
    
        print("FGIGLAC downloads completed")

except KeyboardInterrupt:
    print("Process interrupted by user.")
except Exception as e:
    print("An error occurred:")#(f"An error occurred: {e}")

time.sleep(10)
print("Closing browser")
driver.quit()
print("Beginning data manipulation")

getcontext().prec = 10

def df_transform(df,df_name):
    df["'Trans Amt'"] = np.where(df["'Dr Cr Ind'"] == 'Credit', -df["'Trans Amt'"], df["'Trans Amt'"])
    
    df["'Trans Amt'"] = df["'Trans Amt'"].apply(lambda x: Decimal(str(x)).quantize(Decimal('0.01')))

    df["'Trans Date'"] = pd.to_datetime(df["'Trans Date'"]).dt.strftime('%m/%d/%Y')

    if df_name == f'FGIGLAC_011010_11400_{csv_doc}':
        df = df.sort_values(by="'Trans Date'", ascending=False)
    else:
        df = df.sort_values(by="'Trans Date'", ascending=True)

    df = df[["'Acct Code'","'Trans Date'","'Rucl Code'","'Doc Code'","'Trans Desc'","'Trans Amt'","'Dr Cr Ind'"]]
    df.columns = ["'Acct Code'", 'Trans', "'Rucl Code'", "'Doc Code'", "'Trans Desc'", 'Amt', "'Dr Cr Ind'"]

    return df

print("FGIGLACs being read into Python")
df_keyed = pd.read_csv(FGIGLAC_filepath + f'FGIGLAC_001010_111010_{csv_doc}', skiprows=2)
df_FUPLOAD = pd.read_csv(FGIGLAC_filepath + f'FGIGLAC_011010_113400_{csv_doc}', skiprows=2)
df_YB_1 = pd.read_csv(FGIGLAC_filepath + f'FGIGLAC_011042_113070_{csv_doc}', skiprows=2)
df_YB_2 = pd.read_csv(FGIGLAC_filepath + f'FGIGLAC_011043_113070_{csv_doc}', skiprows=2)
df_YB_3 = pd.read_csv(FGIGLAC_filepath + f'FGIGLAC_026011_113080_{csv_doc}', skiprows=2)
df_YB_4 = pd.read_csv(FGIGLAC_filepath + f'FGIGLAC_026012_113080_{csv_doc}', skiprows=2)
print("FGIGLACs now in Python")

print('Data now being transformed to correct output')
df_keyed = df_transform(df_keyed, f'FGIGLAC_001010_111010_{csv_doc}')
df_FUPLOAD = df_transform(df_FUPLOAD, f'FGIGLAC_011010_113400_{csv_doc}')
df_YB_1 = df_transform(df_YB_1, f'FGIGLAC_011042_113070_{csv_doc}')
df_YB_2 = df_transform(df_YB_2, f'FGIGLAC_011043_113070_{csv_doc}')
df_YB_3 = df_transform(df_YB_3, f'FGIGLAC_026011_113080_{csv_doc}')
df_YB_4 = df_transform(df_YB_4, f'FGIGLAC_026012_113080_{csv_doc}')
print('Data transformation complete')

df_keyed.to_excel(FGIGLAC_filepath + f'001010 111010 Keyed/FGIGLAC_001010_111010_{xlsx_doc}')
df_FUPLOAD.to_excel(FGIGLAC_filepath + f'011010 113400 FUPLOAD/FGIGLAC_011010_113400_{xlsx_doc}')
df_YB_1.to_excel(FGIGLAC_filepath + f'Y BATCH/FGIGLAC_011042_113070_{xlsx_doc}')
df_YB_2.to_excel(FGIGLAC_filepath + f'Y BATCH/FGIGLAC_011043_113070_{xlsx_doc}')
df_YB_3.to_excel(FGIGLAC_filepath + f'Y BATCH/FGIGLAC_026011_113080_{xlsx_doc}')
df_YB_4.to_excel(FGIGLAC_filepath + f'Y BATCH/FGIGLAC_026012_113080_{xlsx_doc}')

print(df_keyed.head())
