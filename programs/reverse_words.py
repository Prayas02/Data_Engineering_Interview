import os
os.system("cls")  
from rich.traceback import install
install()

def main():
    
    s='hello world'
    l=s.split()
    print(' '.join(l[: :-1]))
    
    l1=s.split()
    s1=''
    for word in l1[::-1]:
        s1=s1+' '+word[::-1]
    print(s1[1:])
    


if __name__ == "__main__":
    main()



