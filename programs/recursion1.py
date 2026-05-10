import os
os.system("cls")  
from rich.traceback import install
install()


def print_1_to_n(n):

    if n==11:
        return
    else:
        print(n,end=' ')
        print_1_to_n(n+1)

def print_1_to_n_rev(n):

    if n==0:
        return
    else:
        print_1_to_n_rev(n-1)
        print(n,end=' ')

def print_n_to_1(n):

    if n==0:
        return
    else:
        print(n,end=' ')
        print_n_to_1(n-1)

def print_n_to_1_rev(n):

    if n==11:
        return
    else:
        print_n_to_1_rev(n+1)
        print(n,end=' ')
        

def main():
    print_1_to_n(1)
    print()
    print_1_to_n_rev(10)
    print()
    print_n_to_1(10)
    print()
    print_n_to_1_rev(1)


if __name__ == "__main__":
    main()

