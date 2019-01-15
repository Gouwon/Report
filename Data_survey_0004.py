import requests, json
from bs4 import BeautifulSoup

url = "https://openapi.naver.com/v1/search/blog.json"

title = "파이썬"
params = {
    "query": title,
    "display": 100,
    "start": 1,
    "sort": "date"
}

headers = {
    "X-Naver-Client-Id": "nfSbPUyZrzsu6ycI7DRr",
    "X-Naver-Client-Secret": "UWmai2O6iy"
}

result = requests.get(url, params=params, headers=headers).text

jsonData = json.loads(result)

i = 0
for post in jsonData['items']:
    i += 1
    print(">>>>>>>>>>>>>>>> ", i, " 번째 블로그 검색 결과 포스트입니다.")
    print("\t포스트명 : ", post['title'],"\n\t포스트주소 : ", post['link'],"\n\t블로거명 : ", post['bloggername'], "\n\t게시일 : ", post['postdate'])
    print("")
