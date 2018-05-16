# 백준 1977번 문제
# https://www.acmicpc.net/problem/1977

import sys
M = int(sys.stdin.readline())
N = int(sys.stdin.readline())
an = [1]
xn = [3]
bucket = list()

n = 0
p_an = 1
while True :
#    print('an : ',an,'\n','xn : ',xn)
    if p_an > N :
        break
    elif p_an >= M :
        bucket.append(p_an)
    p_an = an[n] + xn[n]
    an.append(p_an)
    p_xn = xn[n] + 2
    xn.append(p_xn)
    n = n + 1
    continue
#print(bucket)
if len(bucket) == 0 :
    print(-1)
else :
    print(sum(bucket))
    print(bucket[0])
