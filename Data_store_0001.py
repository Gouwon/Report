import pymysql
import requests, json
from bs4 import BeautifulSoup
import re

def naverApi():
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
        "X-Naver-Client-Secret": "oMFYO0EzLu"
    }

    result = requests.get(url, params=params, headers=headers).text

    jsonData = json.loads(result)

    with open('./results/naverApi.json', 'w', encoding="utf-8") as make_file:
        json.dump(jsonData, make_file, ensure_ascii=False, indent="\t")

    return jsonData

    # i = 0
    # for post in jsonData['items']:
    #     i += 1
    #     print(">>>>>>>>>>>>>>>> ", i, " 번째 블로그 검색 결과 포스트입니다.")
    #     print("\t포스트명 : ", post['title'],"\n\t포스트주소 : ", post['link'],"\n\t블로거명 : ", post['bloggername'], "\n\t게시일 : ", post['postdate'])
    #     print("")

def get_conn(db):
    return pymysql.connect(
    host='localhost',
    user='dooo',
    password='root1!',
    port=3306,
    db=db,
    charset='utf8')

def insert_data_to_db(db, sql, lst):
    conn = get_conn(db)

    with conn:
        cursor = conn.cursor()
        cursor.execute(sql, lst)


if __name__ == "__main__":
    jsonData = naverApi()
    file_directory = './results/naverApi.json'
    json_data = open(file_directory).read()

    jsonData = json.loads(json_data)

    for post in jsonData['items']:
        name = post["bloggername"]
        bloggerlink = post["bloggerlink"]
        title = post["title"]
        postdate = post["postdate"]
        link = post["link"]
        
        blogid = post["bloggerlink"]
        if "http://blog.naver.com" not in blogid:
            blogid = re.sub("http(s)*|:|\/\/|\/|\.tistory.com", '', blogid)
            print(blogid)
        else:
            blogid = blogid.replace("http://blog.naver.com/","")
            print(">>>", blogid)

        lst1 = [blogid, name, bloggerlink]
        lst2 = [blogid, title, postdate, link]


        sql_insert_blogger = "insert into Blogger(bloggerId, name, link) values(%s, %s, %s) on duplicate key update name = values(name)"
        insert_data_to_db('dooodb', sql_insert_blogger, lst1)


        sql_insert_blogpost = "insert into BlogPost(bloggerId, title, postDate, link) values(%s, %s, %s, %s)"
        insert_data_to_db("dooodb", sql_insert_blogpost, lst2)
