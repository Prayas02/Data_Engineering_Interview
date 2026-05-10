import os
os.system("cls")  
from rich.traceback import install
install()

def second(arr):
    max=-1
    sec=-1
    for i in arr:
        if i>max:
            max=i
    for m in arr:
        if m>sec and m<max:
            sec=m
    return sec

def second_second(arr):
    max=arr[0]
    sec=-1
    for i in arr:
        if i>max:
            sec=max
            max=i
        elif i>sec and i<max:
            sec=i
    return sec


def main():
    tests = [
        [4, 1, 2, 3, 5],
        [1, 2, 3, 4, 5],
        [10, 3, 5, 8, 2],
        [9, 1, 5, 3, 7],
        [1, 2, 3, 4, 10],
        [5, 1, 5, 3, 4],
        [5, 1, 5, 4, 3, 4],
        [7, 7, 7, 7],
        [1, 2, 5, 3, 4]
    ]

    for arr in tests:
        print(arr, "->", second(arr))

    print('*'*50)

    for arr in tests:
        print(arr, "->", second_second(arr))



if __name__ == "__main__":
    main()


"""
max=first element, if the next element in the array is > max, update max and put prev max value at sec
if the next element is only > sec and not > max, then only update sec
"""