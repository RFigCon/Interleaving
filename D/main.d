import std.stdio;
import std.datetime;
import std.datetime.stopwatch : StopWatch;
import std.file;
import std.array;

string read_from_file(const string file_name){
    return readText(file_name);
}

void write_to_file(const string file_name, const string content){
    std.file.write(file_name, content);
}

string interleave(const string source, const uint cols){
    
    auto result = appender!string;
    auto size = source.length;
    result.reserve(size);
    immutable uint lines = cast(uint)size/cols + 1;
    uint idx = 0;

    for(uint col_idx = 0; col_idx<cols; col_idx++){
        for(uint line_idx = 0; line_idx<lines; line_idx++){

            idx = line_idx*cols + col_idx;
            if(idx >= size) break;
            result.put(source[idx]);

        }
    }

    return result.data;
}

string deinterleave(const string source, uint cols){
    auto result = appender!string;
    result.reserve(source.length);
    immutable uint len = cast(uint)source.length;

    immutable uint lines = cols;
    cols = len/lines;
    if(len%lines != 0) cols++;

    immutable uint remainder = (len%cols);
    immutable uint empty_spaces = cols - remainder;
    immutable uint moved_chrs = (empty_spaces-1) * (cols-1);

    uint idx = 0;

    for(uint col_idx = 0; col_idx<cols; col_idx++){
        for(uint line_idx = 0; line_idx<lines; line_idx++){

            idx = line_idx*cols + col_idx;
            
            if (remainder != 0){
                if (idx + moved_chrs == len) break;
                if (idx + moved_chrs > len)
                    idx -= (empty_spaces - (lines-line_idx) );

            }
            if (idx >= len) break;
            
            result.put(source[idx]);

        }
    }

    return result.data;
}

immutable int ITERATIONS = 10_000;

long time_it(StopWatch sw, bool test = false){

    immutable str = read_from_file("..//TheRaven.txt");
    int counter = 0;
    string str_inter = "";
    string str_deinter = "";
    sw.start();
    
    for(; counter<ITERATIONS; counter++){
        str_inter = interleave(str, 4);
        str_deinter = deinterleave(str_inter, 4);
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
