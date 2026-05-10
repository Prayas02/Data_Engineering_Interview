import os
os.system("cls")  
from rich.traceback import install
from collections import Counter
install()

def main():
    l=[1,1,2,2,3,3,4,5,0]
    freq={}
    for x in l:
        freq[x]=freq.get(x,0)+1
    print(freq)

    m=[1,1,2,2,3,3,4,5,0]
    freq1=Counter(m)
    print(freq1)

    l='aabbccdef'
    freq={}
    for x in l:
        freq[x]=freq.get(x,0)+1
    print(freq)

    m='aabbccdef'
    freq1=Counter(m)
    print(freq1)
    print(type(freq1))


if __name__ == "__main__":
    main()

