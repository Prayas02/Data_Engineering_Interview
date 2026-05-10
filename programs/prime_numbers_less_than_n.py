import os
os.system("cls")  
from rich.traceback import install
install()

def prime_Sum(n):
    
    count1=0
    i=2
    
    while i <=n:
        flag=False
        j=2    # j starts from 2
        while j<=i**0.5:
            if i%j==0:
                flag=True
                break
            j+=1
        if flag==False:
            count1=count1+i
        i+=1
            
        
        
    return count1

def prime_Sum2(n):
    
    count1=0  # number count
    i=2
    
    while i <=n:
        count2=0   # divisor count
        j=1     # j starts from 1
        while j<=i**0.5:
            if i%j==0:
                count2+=1
                if i//j!=j:
                    count2+=1
            j+=1
        if count2==2:
            count1=count1+i
        i+=1
            
        
        
    return count1


def main():
    print(prime_Sum(5))
    print(prime_Sum(10))
    print(prime_Sum2(5))
    print(prime_Sum2(10))


if __name__ == "__main__":
    main()