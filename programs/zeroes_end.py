import os
os.system("cls")  
from rich.traceback import install
install()



def pushZerosToEnd(arr):
	i=-1
	j=0
	while j<len(arr):
		if arr[j]!=0:
			arr[i+1]=arr[j]
			i+=1
			if i!=j:
				arr[j]=0
		j+=1
	

def main():
	arr=[1,2,0,0,4,5,0,0,6,0,8,0,9]
	arr1=[0,0,6,7,0,0]
	pushZerosToEnd(arr)
	print(arr)
	pushZerosToEnd(arr1)
	print(arr1)
	



if __name__ == "__main__":
    main()

"""
Same logic as removing duplicates
"""