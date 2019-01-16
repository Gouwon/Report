## melon top 100 scraping

def get_music_ranking():
    import requests
    from bs4 import BeautifulSoup

    url = "https://www.melon.com/chart/index.htm"

    headers = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"}

    res = requests.get(url, headers=headers)
    soup = BeautifulSoup(res.text, 'html.parser')


    s_rank = "span.rank"
    lst_rank = soup.select(s_rank)
    s_lst50 = "#lst50"
    lst50 = soup.select(s_lst50)
    s_lst100 = "#lst100"
    lst100 = soup.select(s_lst100)

    lst_total = lst50 + lst100
    prcs_cnt = 0
    result = { } 

    for music in lst_total:
        prcs_cnt += 1
        contsid = music.get('data-song-no')
        result[contsid] = []

        if prcs_cnt <= 50:
            rank = music.select_one('#lst50 > td:nth-child(2) > div > span.rank').text
        else:
            rank = music.select_one('#lst100 > td:nth-child(2) > div > span.rank').text
        ranking = lst_rank[prcs_cnt].text
        info_list = music.select('div.ellipsis')
        sort = { 0 : "노래명", 1 : "음악가", 2 : "앨범명" }


        artists = [artist_name.text.strip() for artist_name in info_list[1].select('span.checkEllipsis a')]
        # artists = []
        # for artist in info_list[1].select('span.checkEllipsis a'):
        #     artist_name = artist.text.strip()
        #     artists.append(artist_name)

        result[contsid] = { "순  위" : ranking,
                            "노래명" : info_list[0].select_one('a').text.strip(),
                            "음악가" : ",".join(artists),
                            "앨범명" : info_list[2].select_one('a').text.strip(),
                            "좋아요" : "" }

    return result

def get_music_like_cnt_list(contsid_list):
    import requests
    import json

    like_cnt_list_url = "https://www.melon.com/commonlike/getSongLike.json"

    headers = {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"}
    params = {}
    param = ",".join(contsid_list)
    params["contsIds"] = param

    Response_json = requests.get(like_cnt_list_url, headers=headers, params=params).text
    jsonData = json.loads(Response_json)

    music_like_cnt_list = {}

    for music in jsonData['contsLike']:
        music_like_cnt_list[music['CONTSID']] = music['SUMMCNT']

    return music_like_cnt_list


if __name__ == "__main__":
    from pprint import pprint

    music_info_list = get_music_ranking()

    contsid_list = []
    for contsid in music_info_list:
        contsid_list.append(contsid)
    music_like_cnt_list = get_music_like_cnt_list(contsid_list)

    for contsid in music_like_cnt_list:
        music_info_list[str(contsid)]['좋아요'] = music_like_cnt_list[contsid]

    for contsid in music_info_list:
        pprint(music_info_list[contsid])
