# 백준 10817번 문제
# https://www.acmicpc.net/problem/10817

a = input()
a = a.split(" ")
x = int(a[0])
y = int(a[1])
z = int(a[2])
aa = list()
aa.append(x)
aa.append(y)
aa.append(z)
aa.sort()
print(aa[-2])
