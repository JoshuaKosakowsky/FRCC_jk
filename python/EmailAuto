import os
import re
import time
import pandas as pd
from openpyxl import load_workbook
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from webdriver_manager.chrome import ChromeDriverManager

def download_email_attachment_web(email_user, email_pass, download_path):
    try:
        options = Options()
        prefs = {"download.default_directory": download_path}
        options.add_experimental_option("prefs", prefs)
        options.add_argument("--start-maximized")
        options.add_argument("--disable-blink-features=AutomationControlled")

        driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
        driver.get("https://outlook.office.com")

        # Log in to email account
        print("Logging in to email account...")
        WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.NAME, "loginfmt"))).send_keys(email_user)
        driver.find_element(By.NAME, "loginfmt").send_keys(Keys.RETURN)
        time.sleep(2)

        WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.NAME, "passwd"))).send_keys(email_pass)
        driver.find_element(By.NAME, "passwd").send_keys(Keys.RETURN)
        time.sleep(2)

        WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.ID, "idSIButton9"))).click()
        time.sleep(5)

        # Search for the email by subject containing "PLUS Loan Report"
        print("Searching for the email...")
        search_box = WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.XPATH, "//input[@aria-label='Search']")))
        search_box.send_keys("PLUS Loan Report")
        search_box.send_keys(Keys.RETURN)
        time.sleep(5)

        # Open the first email in the search results
        print("Opening the email...")
        email_item = WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.XPATH, "(//div[@role='option'])[1]")))
        email_item.click()
        time.sleep(5)

        # Extract date from email subject
        print("Extracting date from email subject...")
        subject = driver.find_element(By.XPATH, "//div[@class='gs tC']")  # Adjust this XPath as needed
        date_match = re.search(r"\d{2}\.\d{2}\.\d{4}", subject.text)
        if date_match:
            date_str = date_match.group(0)
            print(f"Date found: {date_str}")

            # Download the attachment
            print("Downloading the attachment...")
            attachment = WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.XPATH, "//div[@data-icon-name='Download']")))
            attachment.click()
            time.sleep(5)

            # Keep the browser open for debugging
            input("Press Enter to close the browser...")

            driver.quit()
            return date_str

    except Exception as e:
        print(f"An error occurred: {e}")
        driver.quit()
        return None

def read_locked_excel(file_path, password):
    try:
        wb = load_workbook(filename=file_path, read_only=False, keep_vba=False, data_only=True, password=password)
        sheet = wb.active
        data = sheet.values
        columns = next(data)[0:]
        df = pd.DataFrame(data, columns=columns)
        return df
    except Exception as e:
        print(f"An error occurred while reading the Excel file: {e}")
        return None

def automate_website(ids, download_path):
    try:
        options = webdriver.ChromeOptions()
        prefs = {"download.default_directory": download_path}
        options.add_experimental_option("prefs", prefs)

        driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)
        driver.get("https://website.com/login")

        # Perform login (example, replace with actual login logic)
        print("Logging into the website...")
        username = WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.NAME, "username")))
        password = driver.find_element(By.NAME, "password")
        username.send_keys("your_username")
        password.send_keys("your_password")
        password.send_keys(Keys.RETURN)

        # Navigate to upload page and upload IDs (example, replace with actual upload logic)
        print("Uploading IDs...")
        upload_field = WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.ID, "upload_field")))
        for id in ids:
            upload_field.send_keys(id)
            # Perform the upload action here

        # Keep the browser open for debugging
        input("Press Enter to close the browser...")

    except Exception as e:
        print(f"An error occurred: {e}")

    finally:
        driver.quit()

def process_downloaded_data(file_path):
    try:
        df = pd.read_excel(file_path)
        filtered_df = df[df['some_column'] == 'some_value']  # Replace with actual filtering logic
        filtered_df.to_excel('/path/to/save/final_output.xlsx', index=False)
    except Exception as e:
        print(f"An error occurred while processing the downloaded data: {e}")

def main():
    try:
        download_path = '/path/to/save/attachment'
        email_user = 'your_email@company.com'
        email_pass = 'your_password'
        
        date_str = download_email_attachment_web(email_user, email_pass, download_path)
        
        if date_str:
            # Use the dynamic filename for the downloaded file
            file_path = os.path.join(download_path, f'PLUS Loan Report {date_str}.xlsx')
            df = read_locked_excel(file_path, 'your_password')

            if df is not None:
                ids = df['ID'].tolist()  # Replace with actual filtering logic
                automate_website(ids, '/path/to/download/directory')
                process_downloaded_data('/path/to/download/directory/resulting_file.xlsx')
            else:
                print("Failed to read the Excel file.")
        else:
            print("Failed to download the email attachment.")

    except Exception as e:
        print(f"An error occurred in the main function: {e}")

if __name__ == "__main__":
    main()
