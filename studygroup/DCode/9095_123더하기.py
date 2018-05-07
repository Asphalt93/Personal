# 백준 9095번 문제
# https://www.acmicpc.net/problem/9095

import sys

xnumber = int(input(""))

def fn(n) :
    s = 0
    a = [1, 2, 4, 7]
    if n < 5 :
        print(a[n-1])
    else:
        while s < n:
            b = a[s+1] + a[s+2] + a[s+3]
            a.append(b)
#            print(b)
#            print(a)
            s = s + 1
        print(a[n-1])
x = 0
while x < xnumber :
    xx = int(sys.stdin.readline())
    fn(xx)
    x = x + 1
