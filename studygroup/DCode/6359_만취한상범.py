# 백준 6359번 문제
# https://www.acmicpc.net/problem/6359

import sys
T = int(sys.stdin.readline().rstrip())

def i_S2_soju() : # 두유 노우 코리안 위스키? 두유 노우 소주?
    n = int(sys.stdin.readline().rstrip())
    array = [0 for col in range(n+1)] # 처음이니까 문을 다 연다
    for x in range(2,n+1) :
        for y in range(1,(n//x)+1) :
            if array[(x * y)] == 0 :
                array[(x * y)] = 1
            else :
                array[(x * y)] = 0
    print(int(n)-sum(array[:n+1])) # 생각해보니 열고 닫는 걸 거꾸로 생각했다..

while T > 0 :
    i_S2_soju()
    T = T - 1
