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

    for index, row in df.iterrows():
        try:
            term = row["TERM"]
            CRN = row["CRN"]
            #level = row["LEVEL"]
            #DC = row["DETAIL CODE"]
            #amount = row["AMOUNT"]
            #fee_type = row["FEE TYPE"]
            #resident = row["RESIDENCY"]
            #stud_attr = row["STUDENT ATTRIBUTE"]

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

            '''
            detail_code_input = wait.until(EC.presence_of_element_located((
                By.ID, "#frames66"
            )))
            print("Found the Detail Code input")
            detail_code_input.click()

            amount_input = wait.until(EC.presence_of_element_located((
                By.ID, "#frames65"
            )))
            print("Found the Amount input")
            amount_input.click()

            fee_type_input = wait.until(EC.presence_of_element_located((
                By.ID, "slickgrid_179397page_sectionFees_grdSsrfees_col4_lbl"
            )))
            print("Found the Fee Type input")
            fee_type_input.click()
            '''

            time.sleep(0.5)
            student_subtab = wait.until(EC.presence_of_element_located((
                By.ID, "tabSsadetl2TabCanvas_tab1"
            )))
            print("Found the Student subtab")
            student_subtab.click()

            time.sleep(0.6)
            start_over_button = wait.until(EC.element_to_be_clickable((
                By.ID, "frames27"
            )))
            print("Found the Start Over button")
        
            start_over_button.click()
            time.sleep(0.1)
            counter += 1
            print(f"Processed {counter} rows")
        
        except KeyboardInterrupt:
            print("Process interrupted by user.")
            break
        except Exception as e:
            print(f"An error occurred while processing row {index}: {e}")
            continue

    time.sleep(5)

except KeyboardInterrupt:
    print("Process interrupted by user.")
except Exception as e:
    print("An error occurred:")#(f"An error occurred: {e}")

time.sleep(10)
driver.quit()
