###########################################
# 과목명 : 빅데이터와 비지니스 애널리틱스 #
# 과제명 : 6 - 추천 시스템 만들기         #
# 이름 : 김재훈                           #
# 학번 : **********                       #
# 학과 : 경영학과                         #
###########################################
rm(list = ls()) #object remove
##########################################


library(recommenderlab)

naver <- read.csv("MOVIE.csv", head = FALSE, sep=",")
r <- as(naver, "realRatingMatrix") 

trainingData <- sample(814,714)
trainingSet <- r[trainingData]

trainingSet <- trainingSet[rowCounts(trainingSet)>3]
#as(trainingSet, "Matrix")

scheme <- evaluationScheme(trainingSet, method="split", train = 0.8, given  = 4, goodRating = 8, k = 5 )


# Generate Models 
mUBCF <- Recommender(trainingSet, method="UBCF", parameter = "Cosine")
mIBCF <- Recommender(trainingSet, method="IBCF", parameter = "Cosine")

Testset <- r[-trainingData]


# Recommend List Generate, Graph Generate
UBCFlist <- predict(mUBCF, Testset, n = 7)

IBCFlist <- predict(mIBCF, Testset, n = 7)

as(UBCFlist, "list")
as(IBCFlist, "list")


# Simulation
alUBCF <- list ( 
  "user-based CF_cosine" = list(name ="UBCF",
                                param=list(method="Cosine")),
  "user-based CF_pearson" = list(name ="UBCF",
                                 param=list(method="Pearson")))

alIBCF <- list ( 
  "item-based CF_cosine" = list(name ="IBCF",
                                param=list(method="Cosine")),
  "item-based CF_pearson" = list(name ="IBCF",
                                 param=list(method="Pearson")))


# Result
result1 <- evaluate(scheme, alUBCF, n=c(1,3,5))
result1 
avg(result1)

result2 <- evaluate(scheme, alIBCF, n=c(1,3,5))
result2
avg(result2)

plot(result1, annotate = TRUE, legend="bottomright")
plot(result1,"prec/rec",annotate = TRUE, legend="bottomright")
plot(result2, annotate = TRUE, legend="topleft")
plot(result2,"prec/rec",annotate = TRUE, legend="topleft")
