import os
os.system("cls")  
from rich.traceback import install
install()

def remove_sorted(arr):
    arr[:]=sorted(set(arr))

def remove_sorted2(arr):
    i=0
    j=1
    while j<(len(arr)):
        if arr[j]!=arr[i]:
            arr[i+1]=arr[j]
            i+=1
        j+=1
    return i+1



def main():
    arr=[1,2,2,3,3,4,5,5,6,6,7]
    remove_sorted(arr)
    print(arr)
    arr1=[1,2,2,3,3,4,5,5,5,6,6,7,7,8]
    unq=remove_sorted2(arr1)
    print(arr1, unq)

    word = "abcabcbb"
    print(''.join(list(set(word))))
    print(''.join(list(sorted(set(word)))))

if __name__ == "__main__":
    main()


"""
i=first element, the next place in the array will be occupied by  an element that is not equal to i
j=1, if j is same as i , then just increment
if j is not equal to i , then update j value in i+1 and increment i
"""


l1 = [1, 2, 2, 3, 4]
l2 = [2, 3]

# Convert l2 to a set for optimized O(1) lookups
l2_set = set(l2)

# Filter out elements that exist in l2_set
result = [item for item in l1 if item not in l2_set]

print(result)  
# Output: [1, 4]


arr=[1,2,2,3,3,4,5,5,6,6,7]

l1=[]
l2=set()

for el in arr:
    if el not in l1:
            l1.append(el)
    else:
        l2.add(el)
        
print(l1,l2)