from bs4 import BeautifulSoup
import requests
import json
import urls

headers = { "Referer": "http://rt.molit.go.kr/new/gis/srh.do?menuGubun=A&gubunCode=LAND",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"}

def get_dong_code():
    url = "http://rt.molit.go.kr/new/gis/getDongListAjax.do" #POST

    simplified_apt_code_list = {}
    params = {'menuGubun': 'A' ,
              'gubunCode': 'LAND',
              'sidoCode': '11',
              'gugunCode': '11350'}

    html = requests.post(url, params=params, headers=headers)
    jsonData = json.loads(html.text)
    dong_name_list = jsonData["jsonList"]

    simplified_dong_code_list = {}
    for dong_name in dong_name_list:
        simplified_dong_code_list[dong_name["NAME"]] = dong_name["CODE"]
        print("Keep-Alive >>>>>>>>>>>>", html.headers['Keep-Alive'])
        print("", html.headers['Set-Cookie'])
        print("기초 동을 가지고 오는 중입니다..........................", dong_name["NAME"])
    
    return simplified_dong_code_list

def get_apartment_code(dongCode):
    url = "http://rt.molit.go.kr/new/gis/getDanjiComboAjax.do" #POST

    params = {
        'menuGubun': 'A',
        'srhYear': '2019',
        'srhLastYear': '2018',
        'gubunCode': 'LAND',
        'sidoCode': '11',
        'gugunCode': '11350',
        'dongCode': dongCode,
        'rentAmtType': '3'
    }

    html = requests.post(url, params=params, headers=headers)
    jsonData = json.loads(html.text)
    apt_name_list = jsonData["jsonList"]

    simplified_apt_code_list = {}
    for apt_name in apt_name_list:
        simplified_apt_code_list[apt_name["APT_NAME"]] = apt_name["APT_CODE"]
        print("Keep-Alive >>>>>>>>>>>>", html.headers['Keep-Alive'])
        print("", html.headers['Set-Cookie'])
        print("아파트 이름을 가지고 오는 중입니다..........................", apt_name["APT_NAME"])

    return simplified_apt_code_list


def get_detailed_apartment_information(APT_NAME, APT_CODE, session_cnt, jsessionid):
    url = "http://rt.molit.go.kr/new/gis/getDanjiInfoDetail.do?menuGubun=A&p_apt_code={}&p_house_cd=1&p_acc_year=2018&areaCode=&priceCode=".format(APT_CODE)  #GET

    params = {'p_apt_code': str(APT_CODE),
            'p_house_cd':'1',
            'p_acc_year':'2018',
            'areaCode':'',
            'priceCode':''}
    session = requests.Session()

    if session_cnt >= 90:
        print("\n서버로부터 새로운 SESSION ID를 할당받아 사용합니다.")

        html = session.get(url, params=params, headers=headers)
        jsonData = json.loads(html.text)
        detailed_information_list = jsonData["result"]
        session_cnt = 0
        exit()
    elif session_cnt == 0:
        print("\n서버로부터 새로운 SESSION ID를 할당받아 사용합니다.")

        html = session.get(url, params=params, headers=headers)
        jsonData = json.loads(html.text)
        detailed_information_list = jsonData["result"]

        import re
        pattern = re.compile("^JSESSIONID\=(.*)\; P")
        jsessionid_list  = re.findall(pattern, html.headers['Set-Cookie'])
        jsessionid = jsessionid_list[0]
        print("!!!!!!!!!!!!!!!!>>>>>>>>>>>>>>>>>>>>>>>>jsessionid : ", jsessionid)
    else:
        print("\n할당된 SESSION ID를 이용하여 재접속합니다.")
        
        print(">>>>>>>>>>>>>>>>>>>>>>>>jsessionid : ", jsessionid)
        headers["Cookie"] = "JSESSIONID="+jsessionid
        html = session.get(url, params=params, headers=headers)
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> headers['Cookie'] : ", headers["Cookie"])
        jsonData = json.loads(html.text)
        detailed_information_list = jsonData["result"]

    print("Keep-Alive >>>>>>>>>>>>", html.headers['Keep-Alive'])
    print("", html.headers['Set-Cookie'])
    print("아파트 정보를 가지고 오는 중입니다..........................", APT_NAME)
    

    arranged_apartment_informations = {}
    # saveFile = "./GW_Study/Crawling/results/test_____house.html"
    saveFile = "./results/test_____house.html"
    sseion_cnt_in_function = 1
    for detailed_information in detailed_information_list:
        sseion_cnt_in_function += 1

        arranged_apartment_informations[detailed_information["BLDG_CD"]] = {
                    "DNAME"   : detailed_information["DNAME"],
                    "BLDG_NM": detailed_information["BLDG_NM"],
                    "BOBN": detailed_information["BOBN"],
                    "BLDG_AREA": detailed_information["BLDG_AREA"],
                    "DEAL_MM": detailed_information["DEAL_MM"],
                    "DEAL_DD": detailed_information["DEAL_DD"],
                    "SUM_AMT": detailed_information["SUM_AMT"],
                    "APTFNO": detailed_information["APTFNO"],
                    "BUILD_YEAR": detailed_information["BUILD_YEAR"],
                    "ROAD_LEN": detailed_information["ROAD_LEN"],
                    "BC_RAT": detailed_information["BC_RAT"],
                    "VL_RAT": detailed_information["VL_RAT"]
                }
        
        with open(saveFile, mode='a') as file:
            file.writelines(str(arranged_apartment_informations[detailed_information["BLDG_CD"]]))

    print(">>>>>>>>>>>>>>>sssss : ", sseion_cnt_in_function)  
    session_cnt += sseion_cnt_in_function  
    return [session_cnt, jsessionid]

if __name__ == "__main__":
    dong_names = get_dong_code()
    for dong_name in dong_names:
        apt_names = get_apartment_code(dong_names[dong_name])
        print(apt_names)
        session_cnt = 0
        jsessionid = ""
        for apt_name in apt_names:
            result = get_detailed_apartment_information(apt_name, apt_names[apt_name], session_cnt, jsessionid)
            session_cnt = result[0]
            jsessionid = result[1]
