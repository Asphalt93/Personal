# 백준 5543번 문제
# https://www.acmicpc.net/problem/5543

n = 1
burger = list()
beverage = list()
while n < 6 :
    a = int(input(""))
    if n < 4 :
        burger.append(a)
    else :
        beverage.append(a)
    n = n + 1
burger.sort()
beverage.sort()
print(burger[0]+beverage[0]-50)
