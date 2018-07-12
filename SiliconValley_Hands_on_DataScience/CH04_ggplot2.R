library(gapminder)
library(dplyr)
library(ggplot2)

# 나라별로 연도별 평균 기대 수명, 일인당 GDP, 인구수 데이터가 있다.
"""
country     142개의 다른 값을 가진 인자변수
continent   5가지 값을 가진 인자변수
year        숫자형의 연도 변수. 1952년에서 2007년까지 5년 간격으로 되어있다.
lifeExp     이 해에 태어난 이등의 평균 기대 수명
pop         인구
gdpPercap   일인당 국민소득
"""
gapminder

head(gapminder)
tail(gapminder)
glimpse(gapminder)

gapminder$lifeExp
gapminder$gdpPercap
gapminder[, c('lifeExp', 'gdpPercap')]
gapminder %>% select(gdpPercap, lifeExp)

summary(gapminder$lifeExp)
summary(gapminder$gdpPercap)

#상관계수
cor(gapminder$lifeExp, gapminder$gdpPercap)

opar <- par(mfrow=c(2,2))
hist(gapminder$lifeExp)
hist(gapminder$gdpPercap)
#hist(sqrt(gapminder$gdpPercap), nclass=50) #변수변환
hist(log10(gapminder$gdpPercap), nclass=50) #변수변환
plot(log10(gapminder$gdpPercap), gapminder$lifeExp, cex=.5)
par(opar)

#로그변환을 한 후에는 상관관계가 0.81로 증가한다. (이전에는 0.58)
cor(gapminder$lifeExp, log10(gapminder$gdpPercap))
"""
상관관계 함수 cor()는 기본적으로 method='pearson'을 디폴트로 적용하여 피어슨 상관계수를 계산한다.
피어슨 상관계수는 변수의 관계가 직선인 선형 관계를 측정한다.
따라서 변수의 관계가 비선형일 경우에는 피어슨 상관계수는 적절하지 않으며,
method='kendall' 혹은 method='spearman' 옵션을 사용하여 좀 더 비모수적인 방법인 켄달 혹은 스피어맨 상관계수를 구해야한다.
"""

gapminder %>% ggplot(aes(x=lifeExp)) + geom_histogram()
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_histogram()
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_histogram() + scale_x_log10()
gapminder %>% ggplot(aes(x=gdpPercap, y=lifeExp)) + geom_point() + scale_x_log10() + geom_smooth()

example(ggplot)

df <- data.frame(gp = factor(rep(letters[1:3], each = 10)), 
                 y = rnorm(30))
glimpse(df)

"""
여기서 letters[1:3] 명령은 'a','b','c' 벡터를 생성하고
rep(letters[1:3], each = 10)은 각 글자를 10번씩 반복한 벡터를 만들어준다.
factor()명령은 문자 벡터를 범주형 인자벡터로 바꿔준다.
"""

ds <- df %>% group_by(gp) %>% summarize(mean = mean(y), sd = sd(y))
ds

ggplot(df, aes(x = gp, y = y)) +
  geom_point() +
  geom_point(data = ds, aes(y = mean),
             colour = 'red', size = 3)

ggplot(df) +
  geom_point(aes(x = gp, y = y)) +
  geom_point(data = ds, aes(x = gp, y = mean),
             colour = 'red', size = 3)

ggplot() +
  geom_point(data = df, aes(x = gp, y = y)) +
  geom_point(data = ds, aes(x = gp, y = mean),
             colour = 'red', size = 3) +
  geom_errorbar(data = ds, aes(x = gp, y = mean,
                               ymin = mean - sd, ymax = mean + sd),
                colour = 'red', width = 0.4)


#아래 두 명령문은 같은 결과를 출력한다.
ggplot(gapminder, aes(lifeExp)) + geom_histogram()
gapminder %>% ggplot(aes(lifeExp)) + geom_histogram()

#히스토그램
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_histogram()
#로그변환한 히스토그램
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_histogram() + scale_x_log10()
#도수폴리곤
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_freqpoly() + scale_x_log10()
#커널밀도추정함수
gapminder %>% ggplot(aes(x=gdpPercap)) + geom_density() + scale_x_log10()

summary(gapminder)


##한 범주형 변수##
diamonds %>% ggplot(aes(cut)) + geom_bar()

table(diamonds$cut)
prop.table(table(diamonds$cut))
round(prop.table(table(diamonds$cut))*100, 1)

diamonds %>% 
  group_by(cut) %>% 
  tally() %>%  #count() 기능
  mutate(pct = round(n / sum(n) * 100, 1)) #summarise() 기능


##두 수량형 변수##
diamonds %>% ggplot(aes(carat, price)) + geom_point()
diamonds %>% ggplot(aes(carat, price)) + geom_point(alpha=.01)

mpg %>% ggplot(aes(cyl, hwy)) + geom_point()
mpg %>% ggplot(aes(cyl, hwy)) + geom_jitter()

"""
<산점도 시각화를 살펴볼 때 주의할 내용>

1. 데이터의 개수가 너무 많을 떄에는 천 여 개 정도의 점들을 표본화한다.

2. 데이터의 개수가 너무 많을 때에는 alpha= 값을 줄여서 점들을 좀더 투명하게 만들어본다.

3. 일변량 데이터의 예처럼 x나 y변수에 제곱근 혹은 로그변환이 필요한지 살펴본다.

4. 데이터의 상관관계가 강한지 혹은 약한지 살펴본다.

5. 데이터의 관계가 선형인지 혹은 비선형인지 살펴본다.

6. 이상점이 있는지 살펴본다.

7. X,Y변수가 변수 간의 인과 관계를 반영하는지 생각해본다. 한 변수가 다른 변수에 영향을 미치는 자연스러운 관계가 있다면 원인이 되는 변수를 X로, 결과가 되는 벼수를 Y로 놓는 것이 자연스럽니다.
"""

#두 개 이상의 연속 변수를 다룰 떄는 산점도 행렬이 효과적이다.
pairs(diamonds %>% sample_n(1000))

mpg %>% ggplot(aes(class, hwy)) + geom_jitter(col='gray') +
  geom_boxplot(alpha=0.5)

mpg %>% mutate(class=reorder(class, hwy, median)) %>% 
  ggplot(aes(class, hwy)) + geom_jitter(col='gray') +
  geom_boxplot(alpha=0.5)

#reorder()명령을 사용하여 class함수를 각 그룹에서 hwy변수의 중간값의 올림차순으로 범주를 정해주었다.
mpg %>% 
  mutate(class=factor(class, levels=
                        c("2seater", "subcompact","compact","midsize","minivan","suv","pickup"))) %>% 
  ggplot(aes(class,hwy)) + geom_jitter(col='gray') + geom_boxplot(alpha=.5)

mpg %>% 
  mutate(class=factor(class, levels=
                        c("2seater", "subcompact","compact","midsize","minivan","suv","pickup"))) %>% 
  ggplot(aes(class,hwy)) + geom_jitter(col='gray') + geom_boxplot(alpha=.5) + coord_flip()

"""
<병렬상자그림을 사용할 때 주의할 점>

1. 범주형 x변수의 적절한 순서를 고려한다. reorder() 명령처럼 통계량에 기반을 둔 범주의 순서를 정할 수도 있고, factor(levels=) 명령을 사용하여 수동으로 정하는 것이 나을 수도 있다.

2. 수량형 y변수의 제곱근과 로그변환이 도움이 될 수 있다.

3. 수량형 y변수의 분포가 어떠한가? 종모양인가? 왼쪽 혹은 오른쪽으로 치우쳐 있는가? 이상점이 있는가?

4. 각 x범주 그룹의 관측치는 충분한가? 이것을 알아내기 위해서는 alpha= 옵션으로 반투명 상자를 그리고, geom_point()로 개별 관측치를 표현해보자.

5. x와 y축을 교환할 필요는 없는가? coord_flip() 함수를 사용한다.

6. 유용한 차트를 얻기 위해서는 다양한 옵션을 시도해야 한다. 반복적이고 점진적으로 차트를 개선해나간다.
"""


##두 범주형 변수##
glimpse(data.frame(Titanic))

#xtabs()는 도수 분포를 알아내기 위해서 쓴다.
xtabs(Freq~Class+Sex+Age+Survived, data.frame(Titanic))

#데이터가 xtabs 고차원 행렬로 정리되면 모자이크플롯으로 시각화한다.
mosaicplot(Titanic, main = "Survival on the Titanic")
mosaicplot(Titanic, main = "Survival on the Titanic", color = TRUE)

#어른과 아이 중 누가 더 생존율이 높을까?
apply(Titanic, c(3,4), sum)
round(prop.table(apply(Titanic, c(3,4), sum), margin=1),3)

#남녀 생존율은 어떻게 될까?
apply(Titanic, c(2,4), sum)
round(prop.table(apply(Titanic, c(2,4), sum), margin=1),3)

#이것을 group_by로 할 경우
t2 = data.frame(Titanic)
t2 %>% group_by(Sex) %>% 
  summarize(n = sum(Freq),
            survivors=sum(ifelse(Survived=="Yes", Freq, 0))) %>% 
  mutate(rate_survival=survivors/n)

##geom에 대한 접근 방법
gapminder %>% filter(year==2007) %>% 
  ggplot(aes(gdpPercap, lifeExp)) +
  geom_point() + scale_x_log10() +
  ggtitle("Gapminder data for 2007")

gapminder %>% filter(year==2007) %>% 
  ggplot(aes(gdpPercap, lifeExp)) +
  geom_point(aes(size = pop, col = continent)) + scale_x_log10() +
  ggtitle("Gapminder data for 2007")

##facet_* 함수를 사용한다.
gapminder %>% 
  ggplot(aes(year, lifeExp, group=country)) +
  geom_line()

gapminder %>% 
  ggplot(aes(year, lifeExp, group=country, col=continent)) +
  geom_line()

gapminder %>% 
  ggplot(aes(year, lifeExp, group=country, col=continent)) +
  geom_line() +
  facet_wrap(~ continent)

'''
<시각화 과정의 원칙>

1. 데이터에 대한 설명을 읽는다. 문맥을 파악한다.

2. glimpse() 함수로 데이터구조를 파악한다. 행의 개수는? 변수의 타입은?

3. pairs() 산점도행렬로 큰 그림을 본다. 언뜻 눈에 띄는 이상한 점이나 흥미로운 점이 없는지 살펴본다. 행의 수가 너무 클 경우에는 sample_n() 함수로 표본화한다. 변수의 수가 너무 큰 경우에는 10여 개 이하의 데이터별로 살펴본다.

4. 주요 변수를 하나씩 살펴본다. 수량형 변수는 히스토그램, 범주형 변수는 막대그래프를 사용한다. geom_histogram()과 geom_bar() 함수를 이용한다.

5. 두 변수 간의 상관 관계를 살펴본다. 산점도나 상자그림을 사용한다. geom_point()와 geom_boxplot() 함수를 이용한다.

6. 고차원의 관계를 연구한다. 제3, 제4의 변수를 geom_*의 속성에 추가해본다. 적절할 경우에는 facet_wrap() 함수를 사용한다.

7. 양질의 의미 있는 결과를 얻을 떄까지 위의 과정을 반복한다.

8. 의미 있는 플롯은 문서화한다. 플롯을 생성한 코드도 버전 관리한다.
'''