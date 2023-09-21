import time

def write_to_file(file_name, stream):
    out = open(file_name, "w", encoding="utf-8")
    out.write(stream)
    out.flush()
    out.close()

def read_from_file(file_name):
    input = open(file_name, "r", encoding="utf-8")
    stream = input.read().strip()
    input.close()
    return stream

def interleave(msg : str, cols : int):
    output = ""
    size = len(msg)
    lines = size/cols

    if lines%1 != 0 :
        lines = int(lines+1)
    else :
        lines = int(lines)

    idx_col = 0
    while idx_col<cols:
        idx_lin = 0
        while idx_lin<lines:
            idx = idx_lin*cols + idx_col
            if idx<size :
                output += msg[idx]
            idx_lin += 1
        idx_col+=1
    
    return output

def de_interleave(msg : str, cols : int):
    output = ""
    size = len(msg)
    lines = cols
    cols = size/lines

    if cols%1 != 0 :
        cols = int(cols+1)
    else :
        cols = int(cols)

    remainder = (size%cols)
    empty_spaces = cols - remainder
    moved_chrs = (empty_spaces-1) * (cols-1)

    idx_col = 0
    while idx_col<cols:
        idx_lin = 0
        while idx_lin<lines:
            idx = idx_lin*cols + idx_col
            
            if remainder != 0 :
                if idx + moved_chrs == size : break
                if idx + moved_chrs > size :
                    idx -= (empty_spaces - (lines-idx_lin) )

            if idx >= size : break
            
            output += msg[idx]
            idx_lin += 1
        idx_col+=1
    
    return output

source = read_from_file("..\\TheRaven.txt")
iter_num = 10_000
iterations = range(iter_num)

def time_it():
    start_time = time.time_ns()

    for n in iterations:
        str_inter = interleave(source, 4)
        str_deinter = de_interleave(str_inter, 4)

    end_time = time.time_ns()

    write_to_file("TheRaven_inter.txt", str_inter)
    write_to_file("TheRaven_deinter.txt", str_deinter)

    return end_time - start_time

time_it()

time_micro = time_it()/iter_num/1000
print( time_micro, "micro seconds" ) 

#print(str + "\n" + str_inter + "\n" + str_deinter)