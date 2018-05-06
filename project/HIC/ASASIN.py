'''
Amazon ASIN code scraper (feat. BeautifulSoup & Selenium)
Category Edition
=================================================================================================================================
ASASIN v0.1  (2017-07-20)
ASASIN v0.2  (2017-07-20) : 아이템의 URL 수집 개선.
ASASIN v0.3  (2017-08-01) : sqlite3 DB 연동 - test.db
ASASIN v0.3.1(2017-08-02) : MSSQL DB 연동으로 바꿈 / sqlite3는 삭제 + 중복 ASIN 수집 수정이 필요함.
ASASIN v0.4  (2017-08-09) : 중복 ASIN 수집 수정 완료(max함수를 이용) 및 amz_url(MS-SQL)과 연동 완료, 불필요한 코드 제거
ASASIN v0.5  (2017-08-16) : DB에 ASIN이 중복 수집되지 않도록 체크하는 기능 추가
ASASIN v0.5.1(2017-08-16) : DB에 ASIN이 중복 수집되지 않도록 체크하는 기능 추가 - ver.2로 작성
ASASIN v0.6  (2017-08-18) : 카테고리의 노드를 가져오도록 수정 + MS-SQL에 입력되도록 수정
ASASIN v0.7  (2017-08-22) : DB에서 수집할 페이지 수를 읽어오도록 수정 + 에러 수정
ASASIN v0.8  (2017-08-23) : 음악의 경우 ASIN코드가 숫자로만 되어있기 때문에 이를 넘어가는 코드 수정 + 카테고리의 따옴표이슈 수정
ASASIN v0.9  (2017-08-24) : "ASIN수집완료" 출력 위치 조정
ASASIN v1.0  (2017-08-24) : "상품수동수집"worksheet에 연결.
=================================================================================================================================
'''

from bs4 import BeautifulSoup as bs
from selenium import webdriver
import time
import re
import pymssql


Collection_URL = list()
Collection_URL_Error = list()

# MS-SQL에 저장되어있는 검사가 완료된 URL들을 가져온다.
conn = pymssql.connect(server='****회사IP주소****', user='****사용자ID****', password='****비밀번호****', database='test_new')
cur = conn.cursor()

cur.execute("SELECT MAX(URL_SEQ) from AMZ_CD") # ASASIN
time.sleep(1)
max_urlseq = cur.fetchone()[0]
if max_urlseq == None:
    max_urlseq = 0
    
cur.execute("SELECT MAX(seq) from amz_url") # GSUC
time.sleep(1)
max_seq = cur.fetchone()[0]
if max_seq == None:
    max_seq = 0

if max_urlseq >= max_seq:
    conn.close()
    print("새로 업데이트 된 URL이 없습니다.")
    raise SystemExit
else:
    number_of_updated = max_seq - max_urlseq
    print("약 ",number_of_updated,"개 정도의 새로운 URL이 발견되었습니다.")

cur.execute("SELECT seq, url_name, PG FROM amz_url WHERE error_check='AVAIL_URL' AND seq >"+str(max_urlseq))
Collection_URL = cur.fetchall()
print(len(Collection_URL),"개의 주소를 가져왔습니다.")
conn.close()

driver = webdriver.Chrome("C:\chromedriver.exe")
print("브라우저 구동 완료")


# 다음 페이지로 넘어가는 URL을 실행한다.
def Next_Page_Move():
    Next_Page_URL = list_page.find("a",{"title":"Next Page"})["href"]
    driver.get("https://www.amazon.com" + Next_Page_URL)

# HTML 정보를 가져온다.
def Get_HTML():
    global HTML_
    HTML_ = driver.page_source

# 현재페이지의 URL을 저장한다.
def Original_URL():
    global Home_URL
    Home_URL = driver.current_url

# 상품목록 페이지의 HTML을 분석한다.
def Get_list_from_page(trigger):
    global item_page
    global list_page
    list_page = bs(trigger,"html.parser")
    try:
        item_page = list_page.findAll("li",{"class":"s-result-item  celwidget "})
        if len(item_page)==0:
            raise NameError
    except:
        item_page = list_page.find("ul", {"id":"s-results-list-atf"}).contents

# 페이지에 있는 상품들의 URL을 수집한다.
def Get_URL_of_items(trigger):
    global URL_bucket
    URL_bucket = list()
    range_of_list = len(item_page)
    for n in range(range_of_list):
        item_URL = item_page[n].find("a",{"class":"a-link-normal a-text-normal"})['href']
        if len(re.findall("/gp/slredirect/.",item_URL)) > 0 :
            item_URL = "https://www.amazon.com/" + item_URL
        URL_bucket.append(item_URL)

# 상품으로 들어간다.
def Go_into_the_item(trigger):
    driver.get(trigger)

#카테고리 업데이트 및 ASIN 코드 추가
item_category_essential = ['No Category']
item_storage = [['No Category']]
item_category_fail_URL = [['No Category']]
def check_and_update(trigger):
    if node_category not in item_category_essential:
        item_category_essential.append(node_category)
        item_storage.append([node_category])
    for x in item_category_essential:
        if x == node_category:
            item_storage[item_category_essential.index(node_category)].append(trigger)


# HTML을 가져온 뒤 필요한 정보를 파싱한다.

def Category_scraper_sub3(trigger): #이걸로 쓰는 것을 권장한다. - 현재 쓰고 있는 함수
    global category
    global node_category
    product_cat = trigger.find("ul",{"class":"a-unordered-list a-horizontal a-size-small"})
    node_name = list()
    node_number = list()
    node_category = list()
    try:
        category_order = product_cat.findAll("li")
        category_node  = product_cat.findAll("a",{"class":"a-link-normal a-color-tertiary"})
        for n_ in category_node:
            node_ = re.findall('node=[0-9]+',n_['href'])[0]
            node_ = node_.split('=')[1]
            node_number.append(node_)
        for c_ in category_order:
            chunk = c_.find("span").get_text().strip().replace("'","`")
            if len(chunk) > 1:
                node_name.append(chunk)
            else:
                continue
        category_zip = list(zip(node_name, node_number))
        for e_ in category_zip:
            node_category.append(e_)
        category = "/".join([x[0] for x in node_category])    
        print(category)
        

    except:
        Category_Error_URL = driver.current_url
        item_category_fail_URL.append(Category_Error_URL)
        print("오류")
        category = 'No Category'
            


# ASIN코드 뽑아오는 함수 01
def Parsing_function(): # li일 경우 사용
    print("수집 중...")
    product_asin = product_page.findAll("li")
    Category_scraper_sub3(product_page)
    if category == "No Category":
        print("오류")
    else:
        temp_asin_bucket = list()
        for li in product_asin:
            a = li.get_text()
            b = re.findall('ASIN:+',a)
            try:
                if len(b) > 0:
                    code_asin = re.findall('B[0-1]{1}[0-9]{1}\w{7}', li.get_text())[0]
                    temp_asin_bucket.append(code_asin)
                    print(code_asin)
            except:
                print("ASIN 에러")
                break
        if len(temp_asin_bucket) != 0:
            code_asin = max(temp_asin_bucket)
            check_and_update(code_asin)
            ASIN_BUCKET.append(code_asin)

# ASIN코드 뽑아오는 함수 02
def Parsing_function_sub2(): #tr일 경우 사용
    print("수집 중...")
    product_asin = product_page.findAll("tr")
    Category_scraper_sub3(product_page)
    if category == "No Category":
        print("오류")      
    else:
        temp_asin_bucket = list()
        for td in product_asin:
            a = td.get_text()
            b = re.findall('ASIN',a)
            try:
                if len(b) > 0:
                    code_asin = re.findall('B[0-1]{1}[0-9]{1}\w{7}', td.get_text())[0]
                    temp_asin_bucket.append(code_asin)
                    print(code_asin)
            except:
                print("ASIN 에러")
                break
        if len(temp_asin_bucket) != 0:
            code_asin = max(temp_asin_bucket)
            check_and_update(code_asin)
            ASIN_BUCKET.append(code_asin)


####################'''
# 입력한 URL에서 수집한 ASIN코드를 MSSQL DB에 저장하는 코드 - ver.2
def SAVE_ASIN_DB():
    import datetime
    import pymssql
    conn = pymssql.connect(server='****회사IP주소****', user='****사용자ID****', password='****비밀번호****', database='test_new')
    cursor = conn.cursor()
    for category_ in item_storage:
        date_ = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        seq_ = str(Start_URL[0])
        for asin_ in category_[1:]:
            cursor.execute("SELECT COUNT(GODS_CD) FROM AMZ_CD WHERE GODS_CD='"+asin_+"'")
            duplicate_check = int(cursor.fetchone()[0])
            if duplicate_check > 0:
                print("중복이라 넘어감")
                continue
            else:
                print(asin_, date_, seq_, category_[0][0][0],category_[0][0][1],category_[0][-1][0],category_[0][-1][1])
                print("INSERT INTO AMZ_CD values('"+asin_+"','"+date_+"','"+seq_+"','"+category_[0][0][0]+"','"+category_[0][0][1]+"','"+category_[0][-1][0]+"','"+category_[0][-1][1]+"')")
                cursor.execute("INSERT INTO AMZ_CD values('"+asin_+"','"+date_+"','"+seq_+"','"+category_[0][0][0]+"','"+category_[0][0][1]+"','"+category_[0][-1][0]+"','"+category_[0][-1][1]+"')")
    conn.commit()
    conn.close()
    note_for_gspread_success(seq_)
#####################'''


def note_for_gspread_success(number_):
    _ = int(number_) + 5
    import gspread
    from oauth2client.service_account import ServiceAccountCredentials
    scope = ['https://spreadsheets.google.com/feeds']
    credentials = ServiceAccountCredentials.from_json_keyfile_name('***키파일***',scope)
    gc = gspread.authorize(credentials)
    wks = gc.open("상품수동수집")
    wks = wks.get_worksheet(2)
    wks.update_cell(_,8,"ASIN수집완료")
        
    

flag = 0
print(Collection_URL)
for Start_URL in Collection_URL[:]:
    print(Start_URL,type(Start_URL))
    global ASIN_BUCKET
    ASIN_BUCKET = list()
    driver.get(Start_URL[1])
    Total_Target_Page = int(Start_URL[2])

    
    print("amz_url 테이블의 seq : ",Start_URL[0],"...인 주소 접속 완료.")
    for count_ in range(Total_Target_Page):
        Original_URL()
        Get_HTML()
        time.sleep(1.5)
        Get_list_from_page(HTML_)
        time.sleep(1.5)
        try:
            Get_URL_of_items(item_page)
        except:
            print("상품 목록을 가져오는 도중 오류가 발생했습니다.")
            print("다음 URL로 넘어갑니다.")
            break
        time.sleep(1.5)
        print(count_+1," 번째 페이지에 있는 상품을 수집합니다.......")
        counter = 0
        len_of_ASIN_BUCKET = len(ASIN_BUCKET)
        for x in URL_bucket:
            try:
                Go_into_the_item(x)
            except:
                Collection_URL_Error.append(x)
            HTML_ITEM = driver.page_source
            product_page = bs(HTML_ITEM,"html.parser")
            
            if product_page.find("div",{"id":"prodDetails"}) == None:
                Parsing_function()
            else : Parsing_function_sub2()


        print(count_+1," 번째 페이지 완료.")
        driver.get(Home_URL)
        try :
            Next_Page_Move()
        except:
            print("페이지 못 넘어감")
            continue
        print("다음 페이지로 넘어갑니다. ------> Page.",count_+2)
    flag += 1
    SAVE_ASIN_DB()
    
    item_category_essential = ['No Category'] # 리스트 내용 초기화
    item_storage = [['No Category']] # 리스트 내용 초기화
    item_category_fail_URL = [['No Category']] # 리스트 내용 초기화
    print("지정한 주소 및 페이지에서의 수집활동을 모두 수행하였습니다.", "\n[ 총 ",len(ASIN_BUCKET),"개의 ASIN 번호 수집. ]")

    
if len(Collection_URL_Error)>0:
    print(Collection_URL_ERROR)
conn.close()
driver.close()
print("브라우저 종료")
