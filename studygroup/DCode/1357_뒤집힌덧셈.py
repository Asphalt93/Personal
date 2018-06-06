# 백준 1357번 문제
# https://www.acmicpc.net/problem/1357

import sys

fvalue = sys.stdin.readline().rstrip().split(" ")

a = list(fvalue[0])
b = list(fvalue[1])
#print('a, b' ,a,b)
n = 1
xsum = 0
for x in a :
    lego = int(x)*(10**(n-1))
    xsum = lego + xsum
    n = n + 1

n = 1
ysum = 0
for y in b :
    lego = int(y)*(10**(n-1))
    ysum = lego + ysum
    n = n + 1
#print('x : ',xsum,'y : ',ysum)

c = list(str(xsum + ysum))
n = 1
zsum = 0
for z in c :
    lego = int(z)*(10**(n-1))
    zsum = lego + zsum
    n = n + 1

print(zsum)
