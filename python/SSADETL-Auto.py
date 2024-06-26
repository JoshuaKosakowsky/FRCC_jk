from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager
import time
import pandas as pd

# Loading data from excel
filepath = # Path to your file "C:/Users/"
filename = # Name of your excel file "Test.xlsx"
schedule_detail = filepath + filename
df = pd.read_excel(schedule_detail)

chrome_options = Options()
#chrome_options.add_argument("--headless")
chrome_options.add_argument("--window-size=1600,720")

# Credentials/BANNER page.
SNum = #Your S Number
P = # Your Password
Search_key = 'SSADETL'
counter = 0

# Process that starts data entry automation.
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
    search_shortcut = ActionChains(driver)
    search_shortcut.key_down(Keys.CONTROL).key_down(Keys.SHIFT).send_keys('y').key_up(Keys.SHIFT).key_up(Keys.CONTROL).perform()
    time.sleep(0.5)
    print("ActionChain to open searchbar")

    screen_input = wait.until(EC.presence_of_element_located(
        (By.XPATH, "//input[@name = 'search']")))
    screen_input.send_keys(Search_key)
    screen_input.send_keys(Keys.RETURN)
    print(f"Searched for {Search_key}")

    driver.get('https://banner.cccs.edu/BannerAdmin/?form=SSADETL')
    print("Found SSADETL Webpage")

    index = 0
    while index < len(df):
        row = df.iloc[index]
        try:
            term = str(row["TERM"])
            CRN = str(row["SSADETL CRN"])
            #level = str(row["LEVEL"])
            DC = str(row["DETAIL CODE"])
            amount = str(row["202520 FEE AMOUNT"])
            fee_type = str(row["FEE TYPE"])
            #resident = str(row["RESIDENCY"])
            #stud_attr = str(row["STUDENT ATTRIBUTE"])

            time.sleep(0.5)
            SSADETL_term = wait.until(EC.presence_of_element_located((
                By.ID, 'inp:key_block_ssasectTermCode'
                )))
            print("Found term input box")
            SSADETL_term.clear()
            print("Cleared Term box")
            SSADETL_term.send_keys(term)
            print(f"Input {term}")
            time.sleep(0.5)

            SSADETL_CRN = wait.until(EC.presence_of_element_located((
                By.ID, 'inp:key_block_ssasectCrn'
            )))
            print("Found CRN input box")
            SSADETL_CRN.clear()
            print("Cleared CRN box")
            time.sleep(0.5)
            ## NOT INPUTTING INTO THE CRM INPUT BOX CONSISTENTLY ##
            SSADETL_CRN.send_keys(CRN)
            print(f"Input {CRN}")
            ## PERFORMING THE ACTION TWICE SEEMS TO WORK, MAY REMOVE SLEEP TIMER IN THE FUTURE#
            SSADETL_CRN.clear()
            print("Cleared CRN box")
            time.sleep(0.2)
            SSADETL_CRN.send_keys(CRN)
            print(f"Input {CRN}")

            time.sleep(0.5)
            GO = wait.until(EC.presence_of_element_located((
                By.CLASS_NAME, 'ui-button-text'
            )))
            print("Found GO button")
            GO.click()

            time.sleep(0.5)
            Section_Fees = wait.until(EC.presence_of_element_located((
                By.ID, "tabSsadetl1TabCanvas_tab1"
            )))
            print("Found the Section Fees Tab")
            Section_Fees.click()

            time.sleep(0.5)
            level_input = wait.until(EC.presence_of_element_located((
                By.ID, "page_sectionFees_grdSsrfees_col0_0_row"
            )))
            print("Found the Level input")
            level_input.click()

            time.sleep(0.2)
            detail_code_input = wait.until(EC.presence_of_element_located((
                By.ID, "page_sectionFees_grdSsrfees_col1_0_row"
            )))
            print("Found the Detail Code input")
            action.click(detail_code_input).pause(1).send_keys(DC).perform()
            print(f"Input Detail Code {DC}")
            
            amount_input = wait.until(EC.presence_of_element_located((
                By.ID, "page_sectionFees_grdSsrfees_col3_0_row"
            )))
            print("Found the Amount input")
            action.click(amount_input).pause(1).send_keys(amount).perform()
            print(f"Input Amount: {amount}")
            
            fee_type_input = wait.until(EC.presence_of_element_located((
                By.ID, "page_sectionFees_grdSsrfees_col4_0_row"
            )))
            print("Found the Fee Type input")
            action.click(fee_type_input).pause(1).send_keys(fee_type).perform()

            # Handles if there are 2 CRN's in a row
            if index + 1 < len(df):
                next_row = df.iloc[index + 1]
                next_CRN = str(next_row['SSADETL CRN'])
                print(f"Next CRN: {next_CRN}")
                if next_CRN == CRN:
                    print("Duplicate found")
                    insert_button = wait.until(EC.presence_of_element_located((By.XPATH, "(//a[@title='Insert (F6)'])[3]")))
                    insert_button.click()
                
                    # Retrieve the next row of data
                    next_DC = str(next_row['DETAIL CODE'])
                    next_amount = str(next_row['202520 FEE AMOUNT'])
                    next_fee_type = str(next_row['FEE TYPE'])

                    time.sleep(0.2)
                    detail_code_input_1 = wait.until(EC.presence_of_element_located((
                        By.ID, "page_sectionFees_grdSsrfees_col1_1_row"
                    )))
                    print("Found the Detail Code input")
                    action.click(detail_code_input_1).pause(1).send_keys(next_DC).perform()
                    print(f"Input Detail Code {next_DC}")
            
                    amount_input_1 = wait.until(EC.presence_of_element_located((
                        By.ID, "page_sectionFees_grdSsrfees_col3_1_row"
                    )))
                    print("Found the Amount input")
                    action.click(amount_input_1).pause(1).send_keys(next_amount).perform()
                    print(f"Input Amount: {next_amount}")
            
                    fee_type_input_1 = wait.until(EC.presence_of_element_located((
                        By.ID, "page_sectionFees_grdSsrfees_col4_1_row"
                    )))
                    print("Found the Fee Type input")
                    action.click(fee_type_input_1).pause(1).send_keys(next_fee_type).perform()
                    print(f"Input Fee Type: {next_fee_type}")

                    index += 1
                    print(f"Processed row {index}")
          
            time.sleep(0.75)
            student_subtab = wait.until(EC.presence_of_element_located((
                By.ID, "tabSsadetl2TabCanvas_tab1"
            )))
            print("Found the Student subtab")
            student_subtab.click()

            time.sleep(0.6)
            start_over_button = wait.until(EC.presence_of_element_located((
                By.ID, "frames27"
            )))
            print("Found the Start Over button")
            start_over_button.click()

            save_changes = wait.until(EC.element_to_be_clickable((
                # SET THIS ACTIVE FOR TESTING - IT IS THE NO BUTTON
                By.XPATH, "(//button[normalize-space()='No'])[1]"
            )))
            print("Found the No button")
                # SET THIS ACTIVE FOR LIVE USE - IT IS THE YES BUTTON
                #By.XPATH, "(//button[normalize-space()='Yes'])[1]"
            #)))
            #print("Found the Yes button")
            save_changes.click()

            counter += 1
            print(f"Processed {counter} rows")

        except KeyboardInterrupt:
            print("Process interrupted by user.")
            break
        except Exception as e:
            print(f"An error occurred while processing row {index}: {e}")
            continue

        index += 1
        print(f"Processed row {index}")

    time.sleep(5)

except KeyboardInterrupt:
    print("Process interrupted by user.")
except Exception as e:
    print("An error occurred:")#(f"An error occurred: {e}")

time.sleep(10)
driver.quit()
