#!/usr/bin/env python3
# coroutine.py
# Glenn G. Chappell
# 3 Feb 2016
#
# For CS 331 Spring 2016
# Coroutines in Python
# Written in Python 3.x


# small_fibos
# Generator (a kind of coroutine): yields Fibonacci numbers less than
# given limit.
def small_fibos(limit):
    a, b = 0, 1
    while True:
        if a >= limit:
            break
        yield a
        a, b = b, a+b


# Use the above generator
print("Small Fibonacci numbers")
for f in small_fibos(150):
    print(f, " ", end="")
print()

