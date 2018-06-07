getwd()
setwd('chapter3')

custdata <- read.table('custdata.tsv', header = T, sep='\t')

summary(custdata)

#히스토그램
library(ggplot2)

ggplot(custdata) +
  geom_histogram(aes(x=age),
                 binwidth = 5,
                 fill = 'grey')

#밀도도표
library(scales)

ggplot(custdata)+
  geom_density(aes(x=income)) +
  scale_x_continuous(labels = dollar)

#로그스케일
ggplot(custdata) +
  geom_density(aes(x=income)) +
  scale_x_log10(breaks = c(100,1000,10000,100000,600000), labels = dollar) +
  annotation_logticks(sides = 'bt')

#막대그래프
ggplot(custdata) + geom_bar(aes(x=marital.stat), fill="gray")

#수평막대그래프
ggplot(custdata)+
  geom_bar(aes(x=state.of.res), fill='gray') +
  coord_flip() +
  theme(axis.text.y = element_text(size=rel(0.8)))

#수평막대그래프 + 정렬
statesums <- table(custdata$state.of.res)
statef <- as.data.frame(statesums)
colnames(statef) <- c("state.of.res", "count")
summary(statef)

statef <- transform(statef,
                    state.of.res = reorder(state.of.res, count))

summary(statef)

ggplot(statef) + geom_bar(aes(x=state.of.res, y=count),
                          stat = "identity",
                          fill = 'gray') +
  coord_flip() +
  theme(axis.text.y = element_text(size = rel(0.8)))

# 선그래프 그리기
x <- runif(100) # 0과 1 사이의 정규분포를 랜덤하게 생성한다.
y <- x^2 + 0.2*x # y의 값은 x의 2차 함수이다.
ggplot(data.frame(x=x, y=y), aes(x=x, y=y)) + geom_line()

# 산점도와 스무딩 곡선
custdata2 <- subset(custdata,
                    (custdata$age > 0 & custdata$age < 100 & custdata$income > 0))
cor(custdata2$age, custdata2$income)

ggplot(custdata2, aes(x=age,  y=income)) +
  geom_point() + ylim(0,20000)

ggplot(custdata2, aes(x=age,  y=income)) +
  stat_smooth(method = "lm") +
  geom_point() + ylim(0,20000)

ggplot(custdata2, aes(x=age,  y=income)) +
  geom_smooth() +
  geom_point() + ylim(0,20000)

ggplot(custdata2, aes(x=age, y=as.numeric(health.ins))) +
  geom_point(position=position_jitter(w=0.05, h=0.05)) +
  geom_smooth()


# 헥사빈 도표
library(hexbin)
ggplot(custdata2, aes(x=age, y=income)) +
  geom_hex(binwidth=c(5, 10000)) + 
  geom_smooth(color="white", se=F) + 
  ylim(0,200000)


# 2개의 범주형 변수를 위한 막대 그래프
# 누적막대그래프
ggplot(custdata) + geom_bar(aes(x=marital.stat, fill = health.ins))
# 병렬막대그래프
ggplot(custdata) + geom_bar(aes(x=marital.stat, fill = health.ins),
                            position = "dodge")
# 채워진 막대
ggplot(custdata) + geom_bar(aes(x=marital.stat, fill = health.ins),
                            position = "fill")


# 그래프에 러그 추가하기
ggplot(custdata, aes(x=marital.stat)) +
  geom_bar(aes(fill = health.ins), position = "fill") +
  geom_point(aes(y=-0.05), size = 0.75, alpha = 0.3,
             position = position_jitter(h=0.01))
# 러그는 데이터가 많은 곳에서는 뺵뺵하게 그려지고, 데이터가 적으면 성듬성하게 그려진다.
