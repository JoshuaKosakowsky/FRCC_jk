''' This Code  will be used to automate Holds on student accounts'''

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
Search_key = 'SOAHOLD'

# Loading data from excel
filepath = f"C:/Users/S03112819/OneDrive - Colorado Community College System/AR/Holds/{TERM}/"
filename = f"{TERM} Holds TEST.xlsx"
schedule_detail = filepath + filename
df = pd.read_excel(schedule_detail)
df.columns = df.columns.str.strip().str.upper()

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

    driver.get(f'https://banner.cccs.edu/BannerAdmin?form=SOAHOLD&vpdi_code=FRCC&appnav_vpdi_code=FRCC&ban_args=&ban_mode=xe#eyJ0eXBlIjoiY29udGV4dCIsImNvbnRleHQiOnsicGFnZU5hbWUiOiJTT0FIT0xEIiwidmFsdWVzIjp7fSwiaG9zdCI6Imh0dHBzOi8vYmFubmVyLmNjY3MuZWR1L2FwcGxpY2F0aW9uTmF2aWdhdG9yIiwiYXBwaWQiOiJiYW5uZXJIUyIsInBsYXRmb3JtIjoiYmFubmVySFMifX0=')
    print(f"Found {Search_key} Webpage")
    countdown(15)

    index = 0
    while index < len(df):
        row = df.iloc[index]
        try:
            ID = str(row["ID"])
            Hold_Type = str(row["HOLD"])
            Reason =  str(row["REASON"])
            Term = str(row["ACADEMIC_PERIOD"])
            Amount = str(row["AMOUNT"])
            Origination_Code = str(row["ORIGINATION CODE"])

            countdown(4)
            SOAHOLD_ID = wait.until(EC.presence_of_element_located((
                By.ID, 'inp:key_block_id'
                )))
            print("Found ID input box")
            SOAHOLD_ID.clear()
            print("Cleared ID box")
            time.sleep(.5)
            SOAHOLD_ID.send_keys(ID)
            print(f"Input {ID}")

            countdown(5)
            GO = wait.until(EC.presence_of_element_located((
                By.CLASS_NAME, 'ui-button-text'
            )))
            print("Found GO button")
            GO.click() 

            # Insert Button (F6)
            countdown(5)
            Insert = wait.until(EC.presence_of_element_located((
                By.XPATH, "(//a[@title='Insert (F6)'])[1]"
            )))
            print("Found the Insert Button")
            Insert.click() 

            # Hold Type is hard to interact with. It's ID is dependent on the load frame, making it hard to keep consistent.
            '''
            countdown(4)
            Hold_Type_Input = wait.until(EC.presence_of_element_located((
                By.ID, '#frames31'
                )))
            print("Found Hold Type input box")
            time.sleep(.5)
            Hold_Type_Input.send_keys(Hold_Type)
            print(f"Input {Hold_Type}")
            '''
            # Using Action Keys since the Insert Button places us directly in the Hold Type Input Box
            countdown(5)
            print(f"Action Keys to input Hold Type of: {Hold_Type}")
            HT = ActionChains(driver)
            HT.pause(1).send_keys(Hold_Type).perform()

            # Utilize TAB Key to move to next block
            countdown(2)
            tab = ActionChains(driver)
            tab.send_keys(Keys.TAB).perform()

            # Using Action Keys to input Reason after Hold Type
            countdown(5)
            print(f"Action Keys to input Reason of: {Reason}")
            Rsn = ActionChains(driver)
            Rsn.pause(1).send_keys(Reason).perform()

            # Hitting the TAB key to get to Amount.
            countdown(2)
            tab.send_keys(Keys.TAB).perform()
            print(f"Action Keys to input Amount of: {Amount} for SID {ID}")
            HoldAmt = ActionChains(driver)
            HoldAmt.pause(1).send_keys(Amount).perform()

            
            print("For Loop to hit Tab 3 times")
            for skip in range(3):
                tab.send_keys(Keys.TAB).perform()
                print(f"Pressed Tab {skip} time(s)")
                time.sleep(1.5)

            # Inputting Origination Code now that we are tabbed to it
            countdown(5)
            print(f"Action Keys to input Origination Code of: {Origination_Code}")
            OC = ActionChains(driver)
            OC.pause(1).send_keys(Origination_Code).perform()       

            # Last step (or near it) of the loop
            countdown(5)
            Start_Over = wait.until(EC.presence_of_element_located((
                By.ID, 'frames16'
            )))
            print('Found Start Over Button')
            Start_Over.click()
            '''

            # F10 to save and move process along
            time.sleep(0.1)
            #save = ActionChains(driver)
            #save.key_down(Keys.F10).key_up(Keys.F10).perform()

            #Enter Twice to Save and bypass warning of registartion
            #enter = ActionChains(driver)
            #time.sleep(0.1)
            #enter.key_down(Keys.ENTER).key_up(Keys.ENTER).perform()
            #time.sleep(0.75)
            #enter.key_down(Keys.ENTER).key_up(Keys.ENTER).perform()
            #print("Enter Twice to save input")

            #time.sleep(1)
            #startover = ActionChains(driver)
            #startover.key_down(Keys.F5).key_up(Keys.F5).perform()
            #print("Hit F5 Key to Startover")
            #time.sleep(1)
            '''         
            
            counter += 1
            print(f"Processed {counter} rows")
        except KeyboardInterrupt:
            print("Process interrupted by user.")
            break
        except Exception as e:
            print(f"An error occurred while processing row {index}: {e}")
            continue
            
        
        index += 1
        print(f"Processed row {index}",f"\n SID: {ID} ... AMT: {Amount}")
        

    time.sleep(5)

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
