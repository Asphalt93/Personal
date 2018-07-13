library(dplyr)
library(ggplot2)

sleep <- data.frame(sleep)

#약1을 먹었을 때 수면시간의 증가만을 추려내기
y <- sleep$extra[sleep$group == 1]
y

summary(y)
sd(y)

par(mfrow=c(2,2))
hist(y) #히스토그램 도수분포
boxplot(y) #박스플롯
qqnorm(y); qqline(y) #정규분포 Q-Q플롯
hist(y, prob = TRUE); lines(density(y), lty=2) #커널밀도 추정치

"""
기술통계량(descriptive statistics)로부터 나온 값들에서 어떤 결론(narrative; 설명)을 이끌어낼 수 있을까?

sleep 데이터를 분석하는 목표는 세 가지이다.

1. 이 수면제는 효과가 있는가? - 가설검정
2. 이 수면제의 효과는 얼마인가? - 신뢰구간
3. 누군가 다른 사람이 이 수면제를 복용하면 어떤 효과가 있을 것인가? - 추측

이 질문에 대한 교과서적 방법은 가장 많이 사용되는 속칭 '일변량 t-검정'이다.
"""

#alternative hypothesis: true mean is not equal to 0
t.test(y)
#alternative hypothesis: true mean is greater than 0
t.test(y, alternative = 'greater')

###

curve(dnorm(x, 0, 1.8), -4, 4)

options(digits = 3)
set.seed(1606)
(y_star <- rnorm(10,0,1.8))
mean(y_star-0); sd(y_star)
(t_star <- mean(y_star-0)/ (sd(y_star)/sqrt(length(y_star))))

set.seed(1606)
B <- 1e4
n <- 10
xbars_star <- rep(NA,B)
sds_star <- rep(NA,B)
ts_star <- rep(NA,B)
for(b in 1:B){
  y_star <- rnorm(n, 0, 1.789)
  m <- mean(y_star)
  s <- sd(y_star)
  xbars_star[b] <- m
  sds_star[b] <- s
  ts_star[b] <- m/(s/sqrt(n))
}

opar <- par(mfrow=c(2,2))
hist(xbars_star, nclass=100)
abline(v=0.75, col='red')
hist(sds_star, nclass=100)
abline(v=1.789, col='red')
hist(ts_star, nclass=100)
abline(v=1.3257, col='red')
qqnorm(ts_star); qqline(ts_star)
par(opar)

length(which(ts_star > 1.3257)) / B

set.seed(1696)
B <- 1e2　
conf_intervals <- 
  data.frame(b=rep(NA,B),
             lower=rep(NA,B),
             xbar=rep(NA,B),
             upper=rep(NA,B))
true_mu <- 1.0
for(b in 1:B){
  (y_star <- rnorm(10, true_mu, 1.8))
  conf_intervals[b, ] = c(b=b,
                          lower=t.test(y_star)$conf.int[1],
                          xbar=mean(y_star),
                          upper=t.test(y_star)$conf.int[2])
        }
conf_intervals <- conf_intervals %>%
  mutate(lucky = (lower<=true_mu & true_mu<=upper))

glimpse(conf_intervals)
table(conf_intervals$lucky)
conf_intervals %>% ggplot(aes(b, xbar, col=lucky)) +
  geom_point() +
  geom_errorbar(aes(ymin=lower, ymax=upper)) +
  geom_hline(yintercept=true_mu, col='red')
