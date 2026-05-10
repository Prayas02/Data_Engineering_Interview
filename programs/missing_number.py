import os
os.system("cls")  
from rich.traceback import install
install()

def missing_number(n,arr):
    sum1=0
    sum1=(n*(n+1))/2
    sum2=0

    for i in arr:
        sum2=sum2+i
    return sum1-sum2

def main():
    arr=[1,2,4,5]
    missing_num=missing_number(5,arr)
    print(missing_num)


if __name__ == "__main__":
    main()



