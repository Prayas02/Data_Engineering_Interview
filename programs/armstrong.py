import os
os.system("cls")  
from rich.traceback import install
install()

def armstrongNumber (n):
    c=len(str(n))
    sum2=n
    sum1=0
    while n>0:
        arm=n%10
        sum1=sum1+arm**c
        n=n//10
    return sum1==sum2

def main():
    print(armstrongNumber(153))
    print(armstrongNumber(372))
    print(armstrongNumber(1634))

if __name__ == "__main__":
    main()

