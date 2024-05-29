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
chrome_options.add_argument("--window-size=1920,1200")

SNum = #ID
P = #Password
Search_key = 'SFARGFE'

try:
    service = Service(executable_path=ChromeDriverManager().install())
    driver = webdriver.Chrome(service=service, options=chrome_options)
    driver.get('https://banner.cccs.edu/applicationNavigator/seamless')

    wait = WebDriverWait(driver, 10)
    SNum_box = wait.until(EC.presence_of_element_located(
        (By.XPATH, "//input[@placeholder='ex: S########']")))
    SNum_box.send_keys(SNum)
    P_box = wait.until(EC.presence_of_element_located(
        (By.XPATH, "//input[@placeholder='Password']")))
    P_box.send_keys(P)
    SNum_box.send_keys(Keys.RETURN)

    time.sleep(20)
    search_shortcut = ActionChains(driver)
    search_shortcut.key_down(Keys.CONTROL).key_down(Keys.SHIFT).send_keys('y').key_up(Keys.SHIFT).key_up(Keys.CONTROL).perform()
    time.sleep(1)

    screen_input = wait.until(EC.presence_of_element_located(
        (By.XPATH, "//input[@name = 'search']")))
    screen_input.send_keys('SSADETL')
    screen_input.send_keys(Keys.RETURN)


    time.sleep(5)
    term_input = wait.until(EC.presence_of_element_located(
        (By.ID, "inp:key_block_ssasectTermCode")))
    term_input.send_keys('202520')



except Exception as e:
    print(f"An error occured: {e}")

time.sleep(20)
driver.quit()  

time.sleep(30)
driver.quit()               
