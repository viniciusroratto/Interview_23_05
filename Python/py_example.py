import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from unicodedata import normalize
import requests
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
import re

url = 'https://www.mfsa.mt/financial-services-register/?fsr=&cat=154&subCat=221&country=&years='


"""
    DEPRECATED - The Malta Business Financial Services website has changed since this was implemented.

    This class get all tables in the Malta Business Registry search engine, in its 
    subcategory 221, get all table rows and and columns from the column 0. 
    The goal is to get company names and their respective links in their database.

    input = The MBR website with the right CAT (154) and SUBCAT (221) in the url.
    outputs = a object that gives you options on how the processing can happen.

"""


class Scraper:

    url = ""

    def __init__ (self, url):
        self.url = url

    def get_firefox_driver(self):
        return webdriver.Firefox(executable_path = r'/Users/viniciusroratto/Desktop/Malta/geckodriver')

    def get_phantomjs_driver(self, tor = False):
        if tor:
            service_args = ['--proxy=localhost:9150','--proxy-type=socks5',]
            return webdriver.PhantomJS(executable_path=r'/Users/viniciusroratto/Desktop/Malta/phantomjs-2.1.1-macosx/bin/phantomjs', service_args = service_args)
        else:
            return  webdriver.PhantomJS(executable_path=r'/Users/viniciusroratto/Desktop/Malta/phantomjs-2.1.1-macosx/bin/phantomjs')

    def get_html (self, driver = get_firefox_driver(), timeout = 10):
        driver.get(self.url)

        try:
            element_present = EC.presence_of_element_located((By.CLASS_NAME, 'categoryTitle'))
            WebDriverWait(driver, timeout).until(element_present)
        except TimeoutException:
            print("Timed out waiting for page to load")

        return driver.page_source
    

    def get_company_table(self, html, file_path = './'):
        soup = BeautifulSoup(html, 'lxml')
        table = soup.find_all('table')
        company_list = table[0].findAll("tr")
        table_title = company_list[0].text + " Under Treshold A"

        company = []
        link= []

        for each in table[0].findAll("td"):
            company.append(each.get_text())
            link.append(re.split('[()]', str(each.span))[1])
            
        df = pd.DataFrame(list(zip(company,link)), columns=["Company", "Link"])
        df.to_csv(file_path + table_title  + ".csv")
        print(df.head())
        return df

        


"""
#### How to use:
    1) Instantiante the object.
    2) You can choose a selenium driver between firefox and phantomjs, if you don,'t the drive will use firefox.
        a) You can actively choose to use the TOR network in the phantomJs driver
    3) Retrieve webpage's HTML with the get_html method.
    4) Retrieve the dataframe using the get_company_list method.
        a) A CSV will be saved to this folders, or an optional folder using the file_path parameter.

"""

mbra  = Scraper(url) 
driver = mbra.get_phantomjs_driver(True)
html = mbra.get_html(driver = driver)
df = mbra.get_company_list(html)

