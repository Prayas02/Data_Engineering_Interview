import os
os.system("cls")  
from rich.traceback import install
install()

def non_repeating(nums):
    freq={}
    for n in nums:
        freq[n]=freq.get(n,0)+1
    print(freq)

    for x,y in freq.items():
        if y !=1:
            pass
        else:
            return(x)
        
    # for num in nums:
    #     if freq[num]==1:
    #         return num

def second_non_repeating(freq):
    count=0
    for x,y in freq.items():
        if y ==1:
            count+=1
            if count==2:
                return(x)
            
def second_index(arr,num):
    count=0
    for i,n in enumerate(arr):
        if n==num:
            count+=1
            if count==2:
                return i



def main():
    nums=[2,3,4,2,3,5]
    print(sorted(nums))   
    print(list(reversed(nums)))    # iterator --> lazy
    x=non_repeating(nums)
    print(x)

    freq={2: 2, 3: 2, 4: 1, 5: 1}
    x=second_non_repeating(freq)
    print(x)

    i=second_index(nums,2)
    print(i)
    i=second_index(nums,3)
    print(i)


if __name__ == "__main__":
    main()



