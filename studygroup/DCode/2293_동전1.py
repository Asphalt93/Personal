# 백준 2293번 문제
# https://www.acmicpc.net/problem/2293

import sys
nk = sys.stdin.readline().rstrip()
xnk = nk.split(" ")
coins = list()
coins.sort()
n = int(xnk[0])
m = int(xnk[0])
xm = int(xnk[0])
k = int(xnk[1])
xvalue = range(1,k+1)
#print('n : ',n,'k : ',k)

while n > 0 :
    xn = input()
    coins.append(int(xn))
    n = n - 1

#----------------------밑 작업 끝---------------------#

#------------------2차원 배열 만들기------------------#

matrix = [[0 for col in range(k+1)] for row in range(m+1)]

for i in range(1,m+1) :
    matrix[i][0] = 1

#첫번째 줄 경우의 수 구하기
for i in xvalue :
    if int(i)%int(coins[0]) == 0 :
        matrix[1][i] = 1
    else :
        continue

# 그 이외의 줄 경우의 수 구하기
y = 2
x = 1
while y < m+1 :
#    matrix[y] = matrix[y-1]
#    print('Before :',matrix[y])
    for i in xvalue :
#        print('i : ',i, 'coins : ',coins[x])
        if int(i) // int(coins[x]) == 0:
            matrix[y][i] = matrix[y - 1][i]
        elif int(i) // int(coins[x]) > 0 :
            matrix[y][i] = matrix[y][i-int(coins[x])] + matrix[y-1][i]
#    print('After : ',matrix[y],'\n')
    x = x + 1
    y = y + 1
#for row in matrix :
#    print(row)
print(matrix[-1][-1])
