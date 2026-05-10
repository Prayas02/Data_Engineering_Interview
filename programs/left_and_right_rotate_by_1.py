import os
os.system("cls")  
from rich.traceback import install
install()

def left_rotate_by_1(arr):
    n=len(arr)
    i=0
    temp=arr[0]
    while i<(len(arr)-1):
        arr[i]=arr[i+1]
        i+=1
    arr[n-1]=temp
    
def right_rotate_by_1(arr):
    n=len(arr)
    i=n-2
    temp=arr[n-1]
    while i>=0:
        arr[i+1]=arr[i]
        i-=1
    arr[0]=temp





def main():
    arr=[1,2,3,4,5,6]
    left_rotate_by_1(arr)
    print(arr)
    arr=[1,2,3,4,5,6]
    right_rotate_by_1(arr)
    print(arr)


if __name__ == "__main__":
    main()



