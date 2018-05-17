###########################################
# 과목명 : 빅데이터와 비즈니스 애널리틱스 #
# 과제명 : 3 - NB 만들기                  #
# 이름 : 김재훈                           #
# 학번 : **********                       #
# 학과 : 경영학부                         #
###########################################
rm(list = ls()) # object remove
###########################################

## step.1 preparing the data #####

setwd("C:\\BBA")

# CSV file import
credit <- read.csv("credit.csv", stringsAsFactors = TRUE)

# Data structure of Credit.csv
str(credit)
#View(credit)

# Change the data type of default into factor.
credit$default <- factor(credit$default)

# Check the variable
str(credit$default)
table(credit$default)


# Set seed 12345
set.seed(12345)

# Generate Train & Test set.
credit_train <- credit[1:900,]
credit_test <- credit[901:1000,]

credit_train_default <- credit_train$default
credit_train <- credit_train[-c(2,5,10,17)]

credit_test_default <- credit_test$default
credit_test <- credit_test[-c(2,5,10,17)]

# Training a model on the data
library(e1071)
credit_classifier <- naiveBayes(credit_train, credit_train_default)
credit_classifier


# Evaluating model performance
credit_pred <- predict(credit_classifier, credit_test)
length(credit_pred)

library(gmodels)
CrossTable(credit_pred, credit_test_default,
           prop.chisq = FALSE, prop.r = FALSE, prop.t = FALSE,
           dnn = c('predicted','actual'))




##### Until Here, we didn't use column 2, 5, 10 <- which followed the guideline of assignment #####


'We are going to use column number 2, 5, 10 from this sentence'
'So its an additional work'


rm(list = ls()) # object remove

## step.1 preparing the data #####

setwd("C:\\BBA")

# CSV file import
credit <- read.csv("credit.csv", stringsAsFactors = TRUE)

# Data structure of Credit.csv
str(credit)

# Change the data type of default into factor.
credit$default <- factor(credit$default)

# Check the variable
str(credit$default)
table(credit$default)

# Transform continuous data into discrete number.
temp_amount <- credit$amount
temp_MLD <- credit$months_loan_duration
summary(temp_amount)
summary(temp_MLD)

length(sort(unique(temp_amount))) # 921
length(sort(unique(temp_MLD))) # 33
'Incase of temp_amount, dividing into 5 classes seems effective.
And for temp_MLD, 3.'

boxplot(temp_amount)
boxplot(temp_MLD)

temp_amount <- temp_amount %/% 4550
table(temp_amount)

temp_MLD <- temp_MLD %/% 34
table(temp_MLD)

credit$amount <- factor(temp_amount)
credit$months_loan_duration <- factor(temp_MLD)

# Set seed 12345
set.seed(12345)

# Generate Train & Test set.
credit_train <- credit[1:900,]
credit_test <- credit[901:1000,]

# Training a model on the data
library(e1071)
credit_classifier <- naiveBayes(credit_train[-17], credit_train$default)
credit_classifier


# Evaluating model performance
credit_pred <- predict(credit_classifier, credit_test[-17])
length(credit_pred)

library(gmodels)
CrossTable(credit_pred, credit_test$default,
           prop.chisq = FALSE, prop.r = FALSE, prop.t = FALSE,
           dnn = c('predicted','actual'))


'When we compare the CrossTable of previous one and current one, 
the current one shows slightly better performance when we measure the proportion of True Positive and True Negative'
