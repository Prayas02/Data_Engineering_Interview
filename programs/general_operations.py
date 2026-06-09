import os
os.system("cls")  
from rich.traceback import install
install()

def flatten_list(nested):
    result = []
    for item in nested:
        if isinstance(item, list):
            result.extend(flatten_list(item))  # recurse
        else:
            result.append(item)
    return result

def top_n(sentence,n):

    lst=sentence.split(' ')
    freq={}
    for word in lst:
        freq[word]=freq.get(word,0)+1
    print(freq.items())  # list of tuples

    top_words = sorted(freq.items(), key=lambda x: x[1], reverse=True)[:n]
    return top_words

def group_by(transactions):
    result = {}

    for name, amount in transactions:
        if name in result:
            result[name] += amount
        else:
            result[name] = amount

    return(result)

def main():
        
    nested = [1, [2, 3], [4, [5, 6]]]
    ans = flatten_list(nested)
    print(ans)

    sentence='cat cat dog dog mouse dog mouse'
    result=top_n(sentence,2)
    print(result)

    transactions = [
    ("Alice", 100),
    ("Bob", 200),
    ("Alice", 300),
    ("Bob", 150),
    ("Charlie", 400)
    ]

    result=group_by(transactions)
    print(result)

if __name__ == "__main__":
    main()



