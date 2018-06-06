# 백준 11052번 문제
# https://www.acmicpc.net/problem/11052

import sys

fish = int(sys.stdin.readline().rstrip())
price_list = sys.stdin.readline().rstrip().split(" ")

matrix = [[0 for col in range(fish+1)] for row in range(3)]

for price in price_list :
    matrix[1][price_list.index(price)+1] = int(price)
    matrix[2][price_list.index(price)+1] = int(price)

for x in range(2,fish+1) :
    candidates = list()
    for y in range(0,x) :
        candidate = matrix[2][y] + matrix[2][x-y]
        candidates.append(candidate)
    matrix[2][x] = max(candidates)



print (matrix[2][-1])
