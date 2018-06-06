# 백준 1920번 문제
# https://www.acmicpc.net/problem/1920

import sys

# array
N = input("")
nlist = set(input("").split(" "))
nchar = len(nlist)

# △ HLOOKUP

# value
M = input("")
mlist = input("").split(" ")
set_mlist = set(mlist)

xkey = set_mlist.intersection(nlist)

for x in mlist :
    if x in xkey:
        print(int(1))
    else :
        print(int(0))
