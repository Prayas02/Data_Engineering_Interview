import os
os.system("cls")  
from rich.traceback import install
install()

def left_rotate(l,d):

    temp=[]

    i=0
    while i<d:
        temp.append(l[i]) 
        i+=1
    
    j=0
    n=len(l)
    while j<n-d:
        l[j]=l[j+d]
        j+=1
    
    k=n-d
    i=0
    while k<n:
        l[k]=temp[i]
        k+=1
        i+=1

def reverse(l, start, end):

    while start < end:
        l[start], l[end] = l[end], l[start]
        start += 1
        end -= 1



def main():

    l=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    d = int(input("Enter rotation count: "))
    left_rotate(l,d)
    print(l)

    arr=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    n = len(arr)
    d = d % n

    # reverse first d elements
    reverse(arr, 0, d-1)

    # reverse remaining elements
    reverse(arr, d, n-1)

    # reverse whole list
    reverse(arr, 0, n-1)

    print(arr)


if __name__ == "__main__":
    main()



