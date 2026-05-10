import os
os.system("cls")  
from rich.traceback import install
install()

def remove_sorted(arr):
    arr[:]=sorted(set(arr))

def remove_sorted2(arr):
    i=0
    j=1
    while j<(len(arr)):
        if arr[j]!=arr[i]:
            arr[i+1]=arr[j]
            i+=1
        j+=1
    return i+1

def main():
    arr=[1,2,2,3,3,4,5,5,6,6,7]
    remove_sorted(arr)
    print(arr)
    arr1=[1,2,2,3,3,4,5,5,5,6,6,7,7,8]
    unq=remove_sorted2(arr1)
    print(arr1, unq)


if __name__ == "__main__":
    main()


"""
i=first element, the next place in the array will be occupied by  an element that is not equal to i
j=1, if j is same as i , then just increment
if j is not equal to i , then update j value in i+1 and increment i
"""


def find_duplicates(nums):
    seen = set()
    dups = set()

    for num in nums:
        if num in seen:
            dups.add(num)
        else:
            seen.add(num)

    return list(dups)