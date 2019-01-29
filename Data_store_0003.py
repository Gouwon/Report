html = '''
<dl>
        <dt>국적</dt>
        <dd>대한민국</dd>

        <dt>활동장르</dt>
        <dd>Dance, Ballad, Drama</dd>
    
        <dt>데뷔</dt>
        <dd class="debut_song">
            <span class="ellipsis">
                2016.05.05
                <span class="bar">
                    TTT
                </span>
                <a href="#">TTTTTTTTTTTTT</a>
            </span>
        </dd>
        
        <dt>수상이력</dt>
        <dd class="awarded">
            <span class="ellipsis">
                2018 하이원 서울가요대상
                <span class="bar">|</span>본상
            </span>
        </dd>
    </dl>
'''

from bs4 import BeautifulSoup
import re

soup = BeautifulSoup(html, 'html.parser')
col_names = {"국적" : "nation", "활동장르" : "genre", "데뷔" : "debut", "수상이력" : "award"}
selector = 'dt,dd'
html_tags = soup.select(selector)

data = {}
for i, html_tag in enumerate(html_tags):
    if i % 2 == 0:
        p = re.sub("T|\s|\n", "", html_tags[i+1].text).strip()
        data[col_names[html_tag.text.strip()]] = p
    else: continue

sql_insert = '''insert into Singer(nation, genre, debut, award) 
                values(%(nation)s, %(genre)s, %(debut)s, %(award)s)
            '''
print('insert into Singer(nation, genre, debut, award) values(',data["nation"],', ',data["genre"],', ',data["debut"],', ',data["award"],')')
