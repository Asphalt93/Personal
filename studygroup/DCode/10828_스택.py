# 백준 10828번 문제
# https://www.acmicpc.net/problem/10828

import sys

bucket = list()

def xpush(n):
    bucket.append(int(n))

def xpop():
    if len(bucket) > 0 :
        print(bucket[-1])
        bucket.pop()
    else : print(-1)

def xsize():
    print(len(bucket))

def xempty():
    if len(bucket) == 0 :
        print(1)
    else : print(0)

def xtop ():
    if len(bucket) > 0 :
        print(bucket[-1])
    else : print(-1)


xnumber = int(sys.stdin.readline())
xn = 0

while xn < xnumber :
    a = input("")
    if a.startswith('push') :
        b = a.split(" ")
        xpush(int(b[1]))
    if a.startswith('pop') :
        xpop()
    if a.startswith('size') :
        xsize()
    if a.startswith('empty') :
        xempty()
    if a.startswith('top') :
        xtop()
    xn = xn + 1
