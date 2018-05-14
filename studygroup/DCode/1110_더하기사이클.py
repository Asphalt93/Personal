# 백준 1110번 문제
# https://www.acmicpc.net/problem/1110

import sys
n = 1
x = sys.stdin.readline()
a = int(x)//10
b = int(x)%10
z = a + b
while True :
    z = 10*b + z%10
    if z == int(x) :
        print(n)
        break
    a = int(z//10)
    b = z%10
    z = a + b
    n = n + 1
    continue
