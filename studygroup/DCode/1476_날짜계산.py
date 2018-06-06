# 백준 1476번 문제
# https://www.acmicpc.net/problem/1476

import sys

#준규 나라 연도
ESM = sys.stdin.readline().rstrip().split(" ")
xESM = [int(ESM[0]),int(ESM[1]),int(ESM[2])]


#E S M 만들기
E = list()
S = list()
M = list()
for x in range(1,16) :
    E.append(x)
for x in range(1,29) :
    S.append(x)
for x in range(1,20) :
    M.append(x)

#계수기처럼 만들기

ANS = [E[0],S[0],M[0]]
count = 1
while xESM != ANS :
    E.append(E[0])
    E.remove(E[0])
    S.append(S[0])
    S.remove(S[0])
    M.append(M[0])
    M.remove(M[0])
    ANS = [E[0],S[0],M[0]]
    count = count + 1

print(count)
