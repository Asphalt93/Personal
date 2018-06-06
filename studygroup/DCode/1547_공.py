# 백준 1547번 문제
# https://www.acmicpc.net/problem/1547

import sys

M = int(sys.stdin.readline().rstrip())

xtable = [ [], [0], [], [], [] ]


def xchange(n) :
    n_cup = n.rstrip().split(" ")
    x = int(n_cup[0])
    y = int(n_cup[1])
    xtable[0] = xtable[x]
    xtable[4] = xtable[y]
    xtable[y] = xtable[0]
    xtable[x] = xtable[4]
    xtable[0] = []
    xtable[4] = []

while M > 0 :
    xchange(input())
    M = M - 1

xbucket = list()
for X in range(1,4) :
    if len(xtable[X]) == 1 :
        xbucket.append(X)

if len(xbucket) == 0 :
    print(-1)
else :
    print(xbucket[0])
