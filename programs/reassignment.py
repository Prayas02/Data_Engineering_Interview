import os
os.system("cls")  
from rich.traceback import install
install()

def main():
    nums=[1,2,3,6,4,5]
    ref=nums
    nums[:]=sorted(nums) # in place sorting
    print(nums)
    print(ref)

    nums=[1,2,3,6,4,5]
    ref=nums
    nums=sorted(nums) # nums now points to sorted nums
    print(nums)
    print(ref)

    arr=[1,2,3]
    arr_copy=arr
    arr.append(4)
    print(arr)
    print(arr_copy)

    arr=[1,2,3]
    arr_copy=arr[:] # new array is created with elements of original array
    arr.append(4)
    print(arr)
    print(arr_copy)


if __name__ == "__main__":
    main()

