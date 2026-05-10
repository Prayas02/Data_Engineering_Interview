import os
from collections import Counter
os.system("cls")  
from rich.traceback import install
install()

def sorted1(arr):
    
    for i in range(len(arr)-1):
        if arr[i+1]<arr[i]:
            return False
    return True

def main():
    l=[1,2,3,4,5,5,6,7,7]
    l1=[1,2,3,4,3,3,6,7,8]
    print(sorted1(l))
    print(sorted1(l1))

    print('------------------------------------')

    s1='listen'
    s2='silent'
    print(Counter(s1) == Counter(s2))     # O(n)
    print(sorted(s1) == sorted(s2))       # O(nlogn)

if __name__ == "__main__":
    main()
    

"""
at no point the next element should be less than the previous element i.e if i+1<i return
"""