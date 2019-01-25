def get_conn(db):
    import pymysql

    return pymysql.connect(
    host='localhost',
    user='dooo',
    password='root1!',
    port=3306,
    db=db,
    charset='utf8')

def get_html(url, method, params = ""):
    import requests
    from bs4 import BeautifulSoup
    import time

    headers = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"}

    if params != "":
        params = params

    if method == 'get':
        res = requests.get(url, headers=headers, params=params)
    elif method == 'post':
        res = requests.post(url, headers=headers, params=params)
    else:
        print("Wrong Method!! Check your request method!")
        exit()

    soup = BeautifulSoup(res.text, 'html.parser')

    time.sleep(1)
    return soup

def get_json(url, method, params = ""):
    import requests
    import json

    headers = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"}

    if params != "":
        params = params    

    if method == 'get':
        res = requests.get(url, headers=headers, params=params)
    elif method == 'post':
        res = requests.post(url, headers=headers, params=params)
    else:
        print("Wrong Method!! Check your request method!")
        exit()

    html = requests.post(url, params=params, headers=headers).text

    jsonData = json.loads(html)
    return jsonData


def write_csv(location, contents = ""):
    ## location is file location to read or save
    ## mode only 'w' or 'a'
    import codecs
    import csv

    with codecs.open(location, 'w', 'utf-8') as file:
        writer = csv.writer(file, delimiter=',', quotechar='"')
        writer.writerow(contents)



def insert_data_to_db(db, sql, lst):
    import pymysql

    conn = get_conn(db)

    with conn:
        cursor = conn.cursor()
        cursor.execute(sql, lst)
    


def get_top100list():
    import re
    import datetime
    import codecs
    import csv

    now = datetime.datetime.now()
    n = now.strftime('%Y%m%d')

    url = "https://www.melon.com/chart/"
    method = 'get'
    html = get_html(url, method)

    selector = 'tbody tr'
    html_tags = html.select(selector)
    pattern = re.compile("'(.*)'")

    like_url = "https://www.melon.com/commonlike/getSongLike.json"

    saveFile = './results/melon_top_100_list({}).csv'.format(n)
    print(saveFile)
    with codecs.open(saveFile, 'w', 'utf-8') as file:
        writer = csv.writer(file, delimiter=',', quotechar='"')
        for html_tag in html_tags:
            rank = html_tag.select_one("span.rank").text
            songId = html_tag.get('data-song-no')
            title = html_tag.select_one('div.ellipsis.rank01 a').text.strip()
            artist = ",".join([artist_name.text for artist_name in html_tag.select('div.ellipsis.rank02 span a')])
            albumId = re.findall(pattern, html_tag.select_one('div.wrap a').get('href'))[0]
            albumTitle = html_tag.select_one('div.wrap a').get('title')

            params = { "contsIds" : songId }
            like_json = get_json(like_url, method, params = params)
            likecnt = like_json["contsLike"][0]["SUMMCNT"]

            result = [rank, songId, title, artist, likecnt, albumId, albumTitle]
            print(rank, songId, title, artist, likecnt, albumId, albumTitle)
            print("-------------------------------------------------------")
            writer.writerow(result)
    print("+++++++++++++++++++++++++", saveFile, " saved +++++++++++++++++++++++++")

def get_albuinfo(mysql_albumId):
    import time

    url = "https://www.melon.com/album/detail.htm"
    params = {"albumId" : mysql_albumId }
    html = get_html(url, 'get', params=params)

    selector = 'div.wrap_info div.entry'
    html_tag = html.select_one(selector)

    albumId = mysql_albumId
    title = html_tag.select_one("#conts > div.section_info > div > div.entry > div.info > div.song_name").text.replace("앨범명", "").strip()
    releaseDate = html_tag.select_one("#conts > div.section_info > div > div.entry > div.meta > dl > dd:nth-child(2)").text.replace(".", "")
    publisher = html_tag.select_one("#conts > div.section_info > div > div.entry > div.meta > dl > dd:nth-child(6)").text
    label = html_tag.select_one("#conts > div.section_info > div > div.entry > div.meta > dl > dd:nth-child(8)").text

    url2 = "https://www.melon.com/album/albumGradeInfo.json"
    params2 = { "albumId" : mysql_albumId }
    score_json = get_json(url2, 'get', params = params2)
    score = score_json['infoGrade']['TOTAVRGSCORE']

    print(albumId, title, score, releaseDate, publisher, label)
    print("<<<<<<<<<<<<<< Album {} Crawl Completed! >>>>>>>>>>>>>>>".format(title))

    time.sleep(1)
    return [albumId, title, score, releaseDate, publisher, label]


def get_songinfo(mysql_songId, mysql_albumId):
    import time

    url = "https://www.melon.com/song/detail.htm"
    params = {"songId" : mysql_songId }
    html = get_html(url, 'get', params=params)

    selector = 'div.wrap_info div.entry'
    html_tag = html.select_one(selector)
    songId = mysql_songId
    sub_title = html_tag.select_one("#downloadfrm > div > div > div.entry > div.info > div.song_name").text.replace("곡명", "").strip()
    if "19금" in sub_title:
        title = sub_title.replace("19금", "").strip()
    else:
        title = sub_title
    # artist = html_tag.select_one("#downloadfrm > div > div > div.entry > div.info > div.artist > a > span:nth-child(1)").text
    genre = html_tag.select_one("#downloadfrm > div > div > div.entry > div.meta > dl > dd:nth-child(6)").text
    albumId = mysql_albumId

    print(songId, title, genre, albumId)
    print("<<<<<<<<<<<<<< {} Crawl Completed! >>>>>>>>>>>>>>>".format(title))

    time.sleep(1)
    return [songId, title, genre, albumId]

def get_artistId(mysql_songId):
    import time
    import re

    url = "https://www.melon.com/chart/"
    method = 'get'
    html = get_html(url, method)

    selector = "tr[data-song-no='{}'] div.ellipsis.rank02 span a".format(mysql_songId)
    html_tags = html.select(selector)

    pattern = re.compile("'([0-9]*)'")
    pattern1 = re.compile("\"(.*)\s-")

    results = []
    for html_tag in html_tags:
        a = (re.findall(pattern, html_tag.get("href"))[0],html_tag.text)
        results.append(a)
    
    return results

if __name__ == "__main__":
    # get_artistId("31340985")

    # url = "https://www.melon.com/song/detail.htm"
    # params = { "songId" : "31113240" }
    # html = get_html(url, 'get', params=params)
    # print(html)

    # url2 = "https://www.melon.com/album/detail.htm"
    # params2 = {"albumId" : "10223837" }
    # html2 = get_html(url2, 'get', params=params2)
    # print(html2)
    # get_albuinfo("10223837")
    get_songinfo("31571110", "10244499")

  
