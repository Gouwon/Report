# mpg 데이터에서 통합 연비(도시와 고속도로 평균)가 높은 순으로 출력하시오.

mpg = as.data.frame(ggplot2::mpg)
mpg1 = mpg
mpg1$average_mileage = (mpg1[, "cty"] + mpg1[, "hwy"]) / 2
head(mpg1, 10)

# mpg 데이터에서 생산연도별 연료 종류에 따른 통합연비를 연도순으로 출력하시오.

mpg2 = aggregate(data=mpg1, average_mileage~(year+fl), mean)
head(mpg2)
mpg2[order(mpg2$year),]
