###########################################
# 과목명 : 빅데이터와 비즈니스 애널리틱스 #
# 과제명 : 2 - KNN 만들기                 #
# 이름 : 김재훈                           #
# 학번 : **********                       #
# 학과 : 경영학부                         #
###########################################
rm(list = ls()) # object remove
###########################################

# CSV file import  -  credit 데이터를 df에 할당한다
df <- read.csv("credit.csv", stringsAsFactors = TRUE)
View(df)

# df 데이터 프레임의 구조
str(df)

# default 여부 테이블
table(df$default)

# default 변수의 비율
round(prop.table(table(df$default)) *100, digits =1)

# 변수 속성 변환 - 더미변수로 바꾸어 준다.
# 더미변수로 바꾸는 법은 구글에서 검색하였습니다.
housing <- model.matrix(~housing ,data = df)[, -1]
checking_balance <- model.matrix(~checking_balance ,data = df)[, -1]
credit_history <- model.matrix(~credit_history ,data = df)[, -1]
purpose <- model.matrix(~purpose ,data = df)[, -1]
savings_balance <- model.matrix(~savings_balance ,data = df)[, -1]
employment_duration <- model.matrix(~employment_duration ,data = df)[, -1]
other_credit <- model.matrix(~other_credit ,data = df)[, -1]
job <- model.matrix(~job ,data = df)[, -1]
phone <- model.matrix(~phone ,data = df)[, -1]

# 수치변수는 새로운 변수에 각각 할당.
months_loan_duration <- df$months_loan_duration
amount <- df$amount
percent_of_income <- df$percent_of_income 
years_at_residence <- df$years_at_residence
other_credit <- df$other_credit
existing_loans_count <- df$existing_loans_count
dependents <- df$dependents

# default
default <- df$default

#더미변수와 수치변수를 모두 가지는 새로운 데이터셋을 만든다.
df <- cbind(housing, checking_balance, credit_history, purpose, savings_balance, employment_duration, other_credit, job, phone,
            months_loan_duration, amount, percent_of_income, years_at_residence, other_credit, existing_loans_count, dependents, default)


# 훈련 데이터와 테스트 데이터 생성
df_train <- df[1:900, -35]
df_test <- df[901:1000, -35]

# 훈련 데이터와 테스트 데이터에 대한 라벨 생성
df_train_labels <- df[1:900, 35]
df_test_labels <- df[901:1000, 35]



# "class" 라이브러리 로드
library(class)
df_test_pred <- knn(train = df_train,
                    test = df_test,
                    cl = df_train_labels,
                    k = 21)


# "gmodels" 라이브러리 로드
library(gmodels)

# 예측값과 실제값의 교차표 생성
CrossTable(x = df_test_labels,
           y= df_test_pred,
           prop.c = FALSE)


# k = 5 일 때
df_test_pred <- knn(train = df_train,
                    test = df_test,
                    cl = df_train_labels,
                    k = 5)
CrossTable(x = df_test_labels,
           y= df_test_pred,
           prop.chisq = FALSE)


# k = 15 일 때
df_test_pred <- knn(train = df_train,
                    test = df_test,
                    cl = df_train_labels,
                    k = 15)
CrossTable(x = df_test_labels,
           y= df_test_pred,
           prop.chisq = FALSE)


# k = 20 일 때
df_test_pred <- knn(train = df_train,
                    test = df_test,
                    cl = df_train_labels,
                    k = 20)
CrossTable(x = df_test_labels,
           y= df_test_pred,
           prop.chisq = FALSE)




# 정규화 함수
normalize = function(x){
  return(   (x-min(x))/(max(x)-min(x))     )
}
colnames(df)

# df 데이터 정규화 (더미변수는 이미 0 또는 1 밖에 없으므로 정규화하지 않았다)
df[,23] <- normalize(df[,23])
df[,28] <- normalize(df[,28])
df[,29] <- normalize(df[,29])
df[,30] <- normalize(df[,30])
df[,31] <- normalize(df[,31])
df[,32] <- normalize(df[,32])
df[,33] <- normalize(df[,33])
df[,34] <- normalize(df[,34])

# 훈련 데이터와 테스트 데이터 생성
df_train <- df[1:900, -35]
df_test <- df[901:1000, -35]

# 훈련 데이터와 테스트 데이터에 대한 라벨 생성
df_train_labels <- df[1:900, 35]
df_test_labels <- df[901:1000, 35]



# "class" 라이브러리 로드
library(class)
df_test_pred <- knn(train = df_train,
                      test = df_test,
                      cl = df_train_labels,
                      k = 21)


# "gmodels" 라이브러리 로드
library(gmodels)

# 예측값과 실제값의 교차표 생성
CrossTable(x = df_test_labels,
           y= df_test_pred,
           prop.c = FALSE)


# k = 5 일 때
df_test_pred <- knn(train = df_train,
                      test = df_test,
                      cl = df_train_labels,
                      k = 5)
CrossTable(x = df_test_labels,
           y= df_test_pred,
           prop.chisq = FALSE)


# k = 15 일 때
df_test_pred <- knn(train = df_train,
                      test = df_test,
                      cl = df_train_labels,
                      k = 15)
CrossTable(x = df_test_labels,
           y= df_test_pred,
           prop.chisq = FALSE)


# k = 20 일 때
df_test_pred <- knn(train = df_train,
                      test = df_test,
                      cl = df_train_labels,
                      k = 20)
CrossTable(x = df_test_labels,
           y= df_test_pred,
           prop.chisq = FALSE)





#이번에는 z-score로 구해보았습니다.

df <- cbind(housing, checking_balance, credit_history, purpose, savings_balance, employment_duration, other_credit, job, phone,
            months_loan_duration, amount, percent_of_income, years_at_residence, other_credit, existing_loans_count, dependents, default)

# df 데이터 표준화 (더미변수는 이미 0 또는 1 밖에 없으므로 정규화하지 않았다)
df[,23] <- scale(df[,23])
df[,28] <- scale(df[,28])
df[,29] <- scale(df[,29])
df[,30] <- scale(df[,30])
df[,31] <- scale(df[,31])
df[,32] <- scale(df[,32])
df[,33] <- scale(df[,33])
df[,34] <- scale(df[,34])

# 훈련 데이터와 테스트 데이터 생성
df_train <- df[1:900, -35]
df_test <- df[901:1000, -35]

# 훈련 데이터와 테스트 데이터에 대한 라벨 생성
df_train_labels <- df[1:900, 35]
df_test_labels <- df[901:1000, 35]


# "class" 라이브러리 로드
library(class)
df_test_pred <- knn(train = df_train,
                    test = df_test,
                    cl = df_train_labels,
                    k = 21)


# "gmodels" 라이브러리 로드
library(gmodels)

# 예측값과 실제값의 교차표 생성
CrossTable(x = df_test_labels,
           y= df_test_pred,
           prop.c = FALSE)

# k = 5 일 때
df_test_pred <- knn(train = df_train,
                    test = df_test,
                    cl = df_train_labels,
                    k = 5)
CrossTable(x = df_test_labels,
           y= df_test_pred,
           prop.chisq = FALSE)

# k = 15 일 때
df_test_pred <- knn(train = df_train,
                    test = df_test,
                    cl = df_train_labels,
                    k = 15)
CrossTable(x = df_test_labels,
           y= df_test_pred,
           prop.chisq = FALSE)

# k = 20 일 때
df_test_pred <- knn(train = df_train,
                    test = df_test,
                    cl = df_train_labels,
                    k = 20)
CrossTable(x = df_test_labels,
           y= df_test_pred,
           prop.chisq = FALSE)