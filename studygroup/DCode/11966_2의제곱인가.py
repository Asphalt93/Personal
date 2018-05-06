# 백준 11966번 문제
# https://www.acmicpc.net/problem/11966

N = input("")
N = int(N)
NN = bin(N)
NN = list(str(NN))
if str(NN.count('1')) == '1' :
    print (1)
else : print(0)
