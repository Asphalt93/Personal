# 백준 1037번 문제
# https://www.acmicpc.net/problem/1037

import sys

Number_N = int(sys.stdin.readline().rstrip())

Yak_list = sys.stdin.readline().rstrip().split(" ")

xlist = list()

for x in Yak_list :
    xlist.append(int(x))

xlist.sort()

#print(xlist)

ans = int(xlist[0]) * int(xlist[-1])

print(ans)
