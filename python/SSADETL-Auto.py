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

chrome_options = Options()
#chrome_options.add_argument("--headless")
chrome_options.add_argument("--window-size=1600,720")

SNum = #Your S Number
P = # Your Password
Search_key = 'SSADETL'
term = # Term you want to update
CRN = # CRN you want to update

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

    SSADETL_term = wait.until(EC.presence_of_element_located((
        By.ID, 'inp:key_block_ssasectTermCode'))
    )
    print("Found term input box")
    SSADETL_term.send_keys(term)

    time.sleep(1)
    SSADETL_CRN = wait.until(EC.presence_of_element_located((
        By.ID, 'inp:key_block_ssasectCrn'
        )))
    print("Found CRN input box")
    SSADETL_CRN.clear()
    print("Cleared CRN box")
    time.sleep(1)
    ## NOT INPUTTING INTO THE CRM INPUT BOX CONSISTENTLY ##
    SSADETL_CRN.send_keys(CRN)
    print(f"Input {CRN}")
    ## PERFORMING THE ACTION TWICE SEEMS TO WORK, MAY REMOVE SLEEP TIMER IN THE FUTURE#
    SSADETL_CRN.clear()
    print("Cleared CRN box")
    time.sleep(1)
    SSADETL_CRN.send_keys(CRN)
    print(f"Input {CRN}")

    time.sleep(1)
    GO = wait.until(EC.presence_of_element_located((
        By.CLASS_NAME, 'ui-button-text'))
    )
    print("Found GO button")
    GO.click()

    Section_Fees = wait.until(EC.presence_of_element_located((
        By.ID, "tabSsadetl1TabCanvas_tab1"
    )))
    print("Found the Section Fees Tab")
    Section_Fees.click()

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

    student_subtab = wait.until(EC.presence_of_element_located((
        By.ID, "tabSsadetl2TabCanvas_tab1"
    )))
    print("Found the Student subtab")
    student_subtab.click()

    start_over_button = wait.until(EC.presence_of_element_located((
        By.ID, "frames27"
    )))
    print("Found the Start OVer button")
    start_over_button.click()

    time.sleep(5)



except Exception as e:
    print("An error occurred:")#(f"An error occurred: {e}")

time.sleep(10)
driver.quit()
