import std.stdio;
import std.datetime;
import std.datetime.stopwatch : StopWatch;
import std.file;
import std.array;

/** 
 * 
 * This version uses char[] instead of allocator!string
 * It also allocs memory only once for each char[] instead of allocating in every call of interleave and deinterleave
 * 
 */

string read_from_file(const string file_name){
    return readText(file_name);
}

void write_to_file(const string file_name, const char[] content){
    std.file.write(file_name, content);
}

void interleave(const string source, char[] target, const uint cols){
    
    auto size = source.length;
    immutable uint lines = cast(uint)size/cols + 1;
    uint src_idx = 0;
    uint trg_idx = 0;

    for(uint col_idx = 0; col_idx<cols; col_idx++){
        for(uint line_idx = 0; line_idx<lines; line_idx++){

            src_idx = line_idx*cols + col_idx;
            if(src_idx >= size) break;
            target[trg_idx++] = source[src_idx];

        }
    }

}

void deinterleave(const char[] source, char[] target, const uint col_num){

    immutable uint len = cast(uint)source.length;
    immutable uint lines = col_num;
    uint cols = len/lines;
    if(len%lines != 0) cols++;

    immutable uint remainder = (len%cols);
    immutable uint empty_spaces = cols - remainder;
    immutable uint moved_chrs = (empty_spaces-1) * (cols-1);

    uint src_idx = 0;
    uint trg_idx = 0;

    for(uint col_idx = 0; col_idx<cols; col_idx++){
        for(uint line_idx = 0; line_idx<lines; line_idx++){

            src_idx = line_idx*cols + col_idx;
            
            if (remainder != 0){
                if (src_idx + moved_chrs == len) break;
                if (src_idx + moved_chrs > len)
                    src_idx -= (empty_spaces - (lines-line_idx) );

            }
            if (src_idx >= len) break;
            
            target[trg_idx++] = source[src_idx];

        }
    }

}

immutable int ITERATIONS = 10_000;

long time_it(StopWatch sw, bool test = false){

    //immutable(char)[] == string
    immutable(char)[] str = read_from_file("..\\TheRaven.txt");
    char[] str_inter = new char[](str.length);
    char[] str_deinter = new char[](str.length);
    sw.start();
    
    for(int counter = 0; counter<ITERATIONS; counter++){
        interleave(str, str_inter, 4);
        deinterleave(str_inter, str_deinter, 4);
    }

    sw.stop();

    if(test){
        write_to_file("TheRaven_inter.txt", str_inter);
        write_to_file("TheRaven_deinter.txt", str_deinter);
    }
    return sw.peek.total!"usecs";
}

void main(){
    
    
    StopWatch sw = StopWatch();
    if (sw.running) sw.stop();
    sw.reset();

    const discard = time_it(sw);
    sw.reset();
    const time_micro = time_it(sw, true);

    writeln("TOTAL:\t", time_micro/1000, " \tmilli seconds\nAVG:\t",  time_micro/ITERATIONS, " \tmicro seconds");
    

}



