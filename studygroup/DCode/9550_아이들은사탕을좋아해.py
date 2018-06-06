# 백준 9550번 문제
# https://www.acmicpc.net/problem/9550

import sys

Test_number = int(sys.stdin.readline().rstrip())

def i_love_candy() :
    ans_bucket = list()
    NK_list = sys.stdin.readline().rstrip().split(" ")
    N = int(NK_list[0])
    K = int(NK_list[1])
    n_candy = sys.stdin.readline().rstrip().split(" ")
    for x in n_candy :
        ans_bucket.append(int(x)//K)
    print(sum(ans_bucket))

while Test_number > 0 :
    i_love_candy()
    Test_number = Test_number - 1
