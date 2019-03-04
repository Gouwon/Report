# midwest 데이터를 data.frame으로 불러온 후, 전체인구와 아시아계인구 데이터의 특징을 설명하시오. (state별 비교 설명)

midwest = as.data.frame(ggplot2::midwest)
data.frame(midwest)
library(psych)
describe(midwest[c('popasian', 'poptotal')])
summary(midwest[c('popasian', 'poptotal')])
midwest1 = aggregate(data=midwest, popasian~state, mean)
midwest11 = aggregate(data=midwest, poptotal~state, mean)
midwest111 = cbind(midwest1, midwest11$poptotal)
head(midwest1)
plot(midwest111$popasian, midwest111$`midwest11$poptotal`)
boxplot(midwest111$popasian~midwest1$state, data=midwest1, xlab = "state", ylab="popasian")
boxplot(midwest111$`midwest11$poptotal`~midwest1$state, data=midwest1, xlab = "state", ylab="poptotal")
aggregate(data=midwest, percasian~state, mean)

## 데이터를 기준으로 살펴봤을 때, 미 중서부 지역에서 사람이 가장 많이 사는 곳과 가장 적게 사는 곳의 인구수는 5105067명과 1701명이고, 아시아계의 경우는 한 명도 살지 않는 곳에서부터 188565명이 사는 곳도 있었다.
## 437개의 county를 통합하여 5개주를 중심으로 분석을 하자면, 전체 인구수 순으로는 오하이오(OH), 일리노이(IL), 미시건(MI), 위스콘신(WI), 인디애나(IN)였다.
## 반면 아시아계 인구 거주순으로 보았을 때, 일리노이, 미시건, 오하이오, 위스콘신, 인디애나의 순서를 보였다. 
## 각 주별 아시아게 인구의 비율을 비교해보면 일리노이가 56.3%, 위스콘신 55.6%, 미시건 50.7%, 오하이오 43.3%, 인디애나 38.3%를 나타냈다.



# poptotal 변수(컬럼)를 total로, popasian 변수를 asian으로 변수명을 변경하는 코드를 작성하시오.

midwest2 = midwest
colnames(midwest2)
names(midwest2)[5] = c("total")
names(midwest2)[10] = c("asian")


# 전체 아시아계 인구수와, asian 변수를 이용해 `전체 아시아계 인구 대비 아시아계 인구 백분율` 파생변수(asianpct)를 추가하고, 히스토그램을 그리시오.

popasiantotal = sum(midwest2$asian)
midwest2$asianpct = (midwest2$asian / popasiantotal) * 100
hist(midwest2$asianpct)
midwest22 = midwest2[midwest2$asianpct < 0.005,]
hist(midwest22$asianpct, breaks = 500)

# 도시(state 또는 county)기준으로 아시아계 인구가 어떻게 분포하는지 설명하시오.

head(midwest2)
midwest21 = aggregate(data=midwest2, asianpct~county, mean)
head(midwest21[order(-midwest21$asianpct),]) 

midwest22 = midwest2[midwest2$asianpct > 1,]
hist(midwest22$asianpct, breaks = 10)
## 상기한 것을 제외한 분석결과, 아시아계 전체 인구의 1% 이상이 거주하는 곳은 15곳이었다.
## 이 중에서 asianpct가 가장 높은 상위 5개 county는 COOK, DU PAGE, OAKLANK, CUYAHOGA, MILWAUKEE, WASHTENAW 이다.
## 나머지 대다수 county는 1% 이하인 곳이었다. 

midwest22 = midwest2[midwest2$asianpct < 0.01,]
dim(midwest22)
hist(midwest22$asianpct, breaks =30)
## asianpct가 0.01% 이하인 곳만 추려도 165개의 county가 있었으며, 가장 최하위 5개의 county는 MENOMINEE(0%), BENTON(0.01746197%), IRON(0.03492394%), SCOTT(0.05238592%), CARROLL(0.05238592%)이었다.



# 아시아계 인구 백분율(asianpct)의 전체 평균을 구하고, 평균을 초과하면 "lg", 그 외는 "sm"을 부여하는 파생변수(asianrate)를 추가하는 코드를 작성하시오.

average_asianpct = mean(midwest21$asianpct)
average_asianpct
midwest2$asianrate = ifelse(midwest2$asianpct > average_asianpct, "lg", "sm")
head(midwest21)
head(midwest2)

# "lg"와 "sm"에 해당하는 지역이 얼마나 되는지 빈도 막대그래프(qplot)을 그려보시오.

qplot(midwest2$asianrate)
