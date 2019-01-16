#todo!!! 캡챠 관련 자동으로 해결하기...


headers = { "Referer": "http://rt.molit.go.kr/new/gis/srh.do?menuGubun=A&gubunCode=LAND",
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"}


def open_captcha():
    from selenium import webdriver
    import os

    if os.name == "nt":
        driver = webdriver.Chrome('C:\Program Files (x86)\chromedriver_win32/chromedriver.exe')
    elif os.name == "posix": 
        driver = webdriver.Chrome('/Users/mac/workspace/chromedriver')  # mac or linux
    else:
        print("Not supported OS")
        exit()

    driver.get("http://rt.molit.go.kr/new/pop/captcha_Popup.do")
    userinput = input("Captcha 처리 후 Enter를 쳐주세요...........")
    driver.close()



def get_dong_code():
    import requests
    import json

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
    import requests
    import json
            
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



def get_detailed_apartment_information(dong_name, APT_NAME, APT_CODE, session_cnt, session):
    import requests
    import json

    url = "http://rt.molit.go.kr/new/gis/getDanjiInfoDetail.do"  #GET

    params = {"menuGubun": "A",
            'p_apt_code': str(APT_CODE),
            'p_house_cd':'1',
            'p_acc_year':'2018',
            'areaCode':'',
            'priceCode':''}

    if session_cnt >= 90:
        print("\n서버로부터 새로운 SESSION ID를 할당받아 사용합니다.")
        session = requests.session()
        session_cnt = 0
    
    elif session_cnt == 0:
        print("\n서버로부터 새로운 SESSION ID를 할당받아 사용합니다.")
        session = requests.session()

    else:
        print("\n할당된 SESSION ID를 이용하여 재접속합니다.")

    html = session.get(url, params=params, headers=headers)
    jsonData = json.loads(html.text)
    try:
        detailed_information_list = jsonData["result"]
    except:
        open_captcha()
        html = session.get(url, params=params, headers=headers)
        jsonData = json.loads(html.text)
        detailed_information_list = jsonData["result"]        

    print("Keep-Alive >>>>>>>>>>>>", html.headers['Keep-Alive'])
    # print("", html.headers['Set-Cookie'])
    print("아파트 정보를 가지고 오는 중입니다.......................... ", dong_name, ". ", APT_NAME)
    
    arranged_apartment_informations = {}
    # saveFile = "./GW_Study/Crawling/results/test_____house.html"
    saveFile = "./results/test_____house____{}.html".format(dong_name)

    try:
        file = open(saveFile, mode='x')
        file.close()
    except:
        pass

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

        adding = open(saveFile, mode='a')
        adding.writelines(str(arranged_apartment_informations[detailed_information["BLDG_CD"]]))
        adding.close()

#    print(">>>>>>>>>>>>>>>sssss : ", sseion_cnt_in_function)
    session_cnt += sseion_cnt_in_function
    return (session_cnt, session)



if __name__ == "__main__":
    import requests

    dong_names = get_dong_code()
    for dong_name in dong_names:
        apt_names = get_apartment_code(dong_names[dong_name])
        print("현재의 동은 ", dong_name," 입니다.")
        print(apt_names)
        session = requests.session()
        session_cnt = 0

        for apt_name in apt_names:
            result = get_detailed_apartment_information(dong_name, apt_name, apt_names[apt_name], session_cnt, session)
            session_cnt = result[0]
            session = result[1]
