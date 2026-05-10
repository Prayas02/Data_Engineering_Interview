import os
os.system("cls")  
from rich.traceback import install
install()

def sum_n(n):
    if n==1:
        return 1
    else:
        return n+sum_n(n-1)
    
def rev_arr(arr,i,n):
    if i==n//2:
        return
    else:
        temp=arr[i]
        arr[i]=arr[n-1-i]
        arr[n-1-i]=temp
        rev_arr(arr,i+1,n)

def pallindrome(str,i,n):
    if i==len(str)//2:
        return True
    if str[i]!=str[n-1-i]:
        return False
    return pallindrome(str,i+1,n)

def fib(n):
    if n==0:
        return 0
    elif n==1:
        return 1
    else:
        return fib(n-1)+fib(n-2)



def main():
    print(sum_n(10))
    arr=[1,2,3,4,5,6,7]
    rev_arr(arr,0,7)
    print(arr)
    arr1=[1,2,3,4,5,6,7,8]
    rev_arr(arr1,0,8)
    print(arr1)
    str='malayalam'
    print(pallindrome(str,0,9))
    str='prayas'
    print(pallindrome(str,0,6))
    print(fib(8))

if __name__ == "__main__":
    main()

