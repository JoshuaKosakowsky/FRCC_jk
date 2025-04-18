''' This Code  will be used to automate Charge Applications on student accounts'''

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

# Counting run time of inputting the fees
start_time = time.perf_counter()

TERM = '202530'

# Credentials/BANNER page.
SNum = ''
P = ''
Search_key = 'TSAAREV'

# Loading data from excel
filepath = f"C:/"
filename = f"TSAAREV Input.xlsx"
schedule_detail = filepath + filename
df = pd.read_excel(schedule_detail)
df.columns = df.columns.str.strip().str.upper()
print(df.head())
print(df.dtypes)

# Countdown Function for longer pauses:
def countdown(seconds):
    for remaining in range(seconds, 0, -1):
        print(f"Waiting: {remaining} seconds.", end="\r")
        time.sleep(1)
    print("Resuming execution.          ")


chrome_options = Options()
chrome_options.add_argument("--window-size=1600,720")


counter = 0

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

    print("Waiting for 2FA to resume.")
    countdown(25)
    print("Resuming process for 2FA pause.")
    actionKeys = ActionChains(driver)

    driver.get(f'https://banner.cccs.edu/BannerAdmin?form=TSAAREV&vpdi_code=FRCC&appnav_vpdi_code=FRCC&ban_args=&ban_mode=xe#eyJ0eXBlIjoiY29udGV4dCIsImNvbnRleHQiOnsicGFnZU5hbWUiOiJUU0FBUkVWIiwidmFsdWVzIjp7fSwiaG9zdCI6Imh0dHBzOi8vYmFubmVyLmNjY3MuZWR1L2FwcGxpY2F0aW9uTmF2aWdhdG9yIiwiYXBwaWQiOiJiYW5uZXJIUyIsInBsYXRmb3JtIjoiYmFubmVySFMifX0=')
    print(f"Found {Search_key} Webpage")
    countdown(15)

    # Action keys for closing TOADEST
    print(f"Action Keys to close Toadest")
    Close_TOADEST = ActionChains(driver)
    Close_TOADEST.pause(1).key_down(Keys.CONTROL).send_keys('q').key_up(Keys.CONTROL).perform()
    countdown(3)

    index = 0
    while index < len(df):
        row = df.iloc[index]
        try:
            ID = str(row["SID"])
            Detail_Code = str(row["DETAIL CODE"])
            Term = str(row["TERM"])
            Amount = str(row["VOID"])

            try:
                TSAAREV_ID = wait.until(EC.presence_of_element_located((
                    By.ID, 'inp:key_block_id'
                    )))
                print("Found ID input box")
                TSAAREV_ID.clear()
                print("Cleared ID box")
                time.sleep(.75)
                TSAAREV_ID.send_keys(ID)
                print(f"Input {ID}")
                countdown(2)
            except TimeoutException:
                print(f"SID Input not found. Skipping row and {ID}")
                index += 1
                continue

            countdown(1)
            GO = wait.until(EC.presence_of_element_located((
                By.CLASS_NAME, 'ui-button-text'
            )))
            print("Found GO button")
            GO.click() 

            # Insert Button (F6)
            countdown(2)
            Insert = wait.until(EC.presence_of_element_located((
                By.XPATH, "(//a[@title='Insert (F6)'])[1]"
            )))
            print("Found the Insert Button")
            Insert.click() 

            # Using Action Keys since the Insert Button places us directly in the Detail Code Input Box
            countdown(2)
            print(f"Action Keys to input Detil Code of: {Detail_Code}")
            DC = ActionChains(driver)
            DC.pause(1).send_keys(Detail_Code).perform()

            # Utilize TAB Key to move to Description block
            countdown(2)
            tab = ActionChains(driver)
            tab.send_keys(Keys.TAB).perform()

            # Utilize TAB Key to move to Term block
            countdown(2)
            tab = ActionChains(driver)
            tab.send_keys(Keys.TAB).perform()

            # Using Action Keys to input Term after Detail Code
            countdown(2)
            print(f"Action Keys to input Term of: {Term}")
            Rsn = ActionChains(driver)
            Rsn.pause(1).send_keys(Term).perform()

            # Hitting the TAB key to get to Charge.
            countdown(2)
            tab.send_keys(Keys.TAB).perform()
            print(f"Action Keys to input Amount of: {Amount} for SID {ID}")
            HoldAmt = ActionChains(driver)
            HoldAmt.pause(1).send_keys(Amount).perform()
     
            #F10 to save and move process along
            time.sleep(0.5)
            save = ActionChains(driver)
            save.key_down(Keys.F10).key_up(Keys.F10).perform()

            #F5 to startove and move process along
            time.sleep(0.5)
            save = ActionChains(driver)
            save.key_down(Keys.F5).key_up(Keys.F5).perform()

            # Last step (or near it) of the loop
            #countdown(2)
            #Start_Over = wait.until(EC.presence_of_element_located((
            #    By.ID, 'frames19'
            #)))
            #print('Found Start Over Button')
            #Start_Over.click()         
            
            counter += 1
            print(f"Processed {counter} rows")
        except KeyboardInterrupt:
            print("Process interrupted by user.")
            break
        except Exception as e:
            print(f"An error occurred while processing row {index}: {e}")
            continue
        countdown(2)
            
        
        index += 1
        print(f"Processed row {index}",f"\n SID: {ID} ... AMT: {Amount}")
        

    time.sleep(2)

except KeyboardInterrupt:
    print("Process interrupted by user.")
except Exception as e:
    print("An error occurred:")#(f"An error occurred: {e}")

print(f"Data entry complete, input a total of {counter} rows.")
driver.quit()
            
end_time = time.perf_counter()

execution_time = end_time - start_time
execution_time_minutes = execution_time/60
print(f"Execution time: \n\t{execution_time:.4f} seconds\n\t{execution_time_minutes:.2f} minutes")
