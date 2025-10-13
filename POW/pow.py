import hashlib
import time


def pow(nickname: str, nonce: int, difficulty: int):
    start_time = time.time()

    flag = False
    
    while not flag:
        
        data = f"{nickname}{nonce}".encode()
        hash_result = hashlib.sha256(data).hexdigest()
        prefix = '0' * difficulty
        if (hash_result.startswith(prefix)):
            end_time = time.time()
            elapsed_time = end_time - start_time
            print(f"data: {data}, hash: {hash_result}, time: {elapsed_time:.6f} seconds")
            flag = True
        else:
            nonce += 1

if __name__ == "__main__":
    pow("jthylkl", 0, 6)
