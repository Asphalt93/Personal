###########################################
# 과목명 : 빅데이터와 비즈니스 애널리틱스 #
# 과제명 : 5 - SVM 만들기                 #
# 이름 : 김재훈                           #
# 학번 : **********                       #
# 학과 : 경영학부                         #
###########################################
rm(list = ls()) # object remove
###########################################


## step.1 preparing the data #####

credit <- read.csv("credit.csv")
set.seed(12345)
str(credit)

# Split the data
credit_train <- credit[1:900,]
credit_test <- credit[901:1000,]

## Step 2: Training a model on the data ----

library(kernlab)
credit_classifier <- ksvm(default~.,
                          data = credit_train,
                          kernel = "polydot")



## Step 3: Evaluating model performance ----

credit_predictions <- predict(credit_classifier, credit_test)

agreement <- credit_predictions == credit_test$default

library(gmodels)
CrossTable(credit_predictions, credit_test$default,
           prop.chisq = FALSE, prop.r = FALSE, prop.t = FALSE,
           dnn = c('predicted','actual'))



#### Bonus Quest - Enhencing the performance of SVM ####

credit <- read.csv("credit.csv")
set.seed(12345)
str(credit)


# Preprocessing - take a log function if the data series has too much skewness.
hist(credit$amount)
hist(log(credit$amount))

hist(credit$months_loan_duration)
hist(log(credit$months_loan_duration))

hist(credit$age)
hist(log(credit$age))


credit$amount <- log(credit$amount)
credit$age <- log(credit$age)
credit$months_loan_duration <- log(credit$months_loan_duration)

# Split the data
credit_train <- credit[1:900,]
credit_test <- credit[901:1000,]

## Step 2: Training a model on the data ----

library(kernlab)
credit_classifier <- ksvm(default~.,
                          data = credit_train,
                          kernel = "polydot")

## Step 3: Evaluating model performance ----

credit_predictions <- predict(credit_classifier, credit_test)

agreement <- credit_predictions == credit_test$default

library(gmodels)
CrossTable(credit_predictions, credit_test$default,
           prop.chisq = FALSE, prop.r = FALSE, prop.t = FALSE,
           dnn = c('predicted','actual'))

