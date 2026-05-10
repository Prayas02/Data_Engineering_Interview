import os
os.system("cls")  
from rich.traceback import install
install()

def hashmap(l,target):

    hash={}
    for i,num in enumerate(l):
        compliment=target-num
        if compliment in hash:
            return(hash[compliment],i)
        hash[num]=i

def two_pointer(numbers,target):
    i=0
    j=(len(numbers))-1
    while i<j:
        if numbers[i]+numbers[j]==target:
            return [i,j]
        elif numbers[i]+numbers[j]<target:
            i+=1
        else:
            j-=1

def main():
    l=[7,11,2,15]
    target=9
    tup=hashmap(l,target)
    print(tup)
    lis=two_pointer(l,target)
    print(lis)




if __name__ == "__main__":
    main()


# return indexes of the 2 numbers whose sum is target
# time complexity is O(n)
# space is O(n) for hashmap and O(1) for 2 pointers
# sorting takes nlogn if array is unsorted

