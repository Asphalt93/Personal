# 백준 1094번 문제
# https://www.acmicpc.net/problem/1094

import sys
x = int(sys.stdin.readline())
bucket = [64,32,16,8,4,2,1]
ans = list()
for y in bucket :
    if y > x :
        bucket.remove(y)
#print(bucket)
for y in bucket :
    if x - y < 0 :
        None
    elif x - y >= 0 :
        x = x - y
        ans.append(y)
        #print(x)
        #print(ans)
print(len(ans))
