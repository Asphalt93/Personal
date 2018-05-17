###########################################
# 과목명 : 빅데이터와 비즈니스 애널리틱스 #
# 과제명 : 4 - 신경망 만들기              #
# 이름 : 김재훈                           #
# 학번 : **********                       #
# 학과 : 경영학부                         #
###########################################
rm(list = ls()) # object remove
###########################################

## step.1 preparing the data #####

credit <- read.csv("credit.csv", stringsAsFactors = TRUE)

set.seed(12345)

str(credit)

credit_train <- credit[1:900,]
credit_test <- credit[901:1000,]

credit_train <- cbind(credit_train, credit_train$default == 'no')
credit_train <- cbind(credit_train, credit_train$default == 'yes')
names(credit_train)[18:19] <- c('no', 'yes')

credit_test <- cbind(credit_test, credit_test$default == 'no')
credit_test <- cbind(credit_test, credit_test$default == 'yes')
names(credit_test)[18:19] <- c('no', 'yes')

View(credit_train)


## Step 2: Training a model on the data ----
library(neuralnet)

#
credit_train <- credit_train[c(-1, -3, -4, -6, -7, -11, -12, -14, -16)]
credit_test <- credit_test[c(-1, -3, -4, -6, -7, -11, -12, -14, -16)]


# ANN with 1 hidden layer
credit_model <- neuralnet(yes ~ months_loan_duration + amount + percent_of_income + years_at_residence + age + existing_loans_count + dependents,
                            data = credit_train)


# Network Visualization
plot(credit_model)


## Step 3: Evaluating model performance ----
model_results <- compute(credit_model, credit_test[1:7])

predicted_default <- model_results$net.result


# making table
pred <- apply(predicted_default, 1, which.max)
pred <- c('no', 'yes')[pred]
table(pred, credit_test$default)



## Step 4: Improving model performance ----
# ANN with 5 hidden layer
credit_model2 <- neuralnet(yes ~ months_loan_duration + amount + percent_of_income + years_at_residence + age + existing_loans_count + dependents,
                             data = credit_train, hidden = 5)



# Network visualization
plot(credit_model2)


# Result Evaluation
model_results2 <- compute(credit_model2, credit_test[1:7])
predicted_default2 <- model_results2$net.result
cor(predicted_default2, credit_test$yes)


pred2 <- apply(predicted_default2, 1, which.max)
pred2 <- c('no', 'yes')[pred2]
table(pred, credit_test$default)
