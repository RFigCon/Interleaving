import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintWriter;

//Using StringBuilder
fun readFromFile(fileName : String) : String?{
    try{
        val reader : BufferedReader = BufferedReader( FileReader(fileName))
        var content : String = ""
        var next : String? = reader.readLine()
        var line : String? = next;
        while(line!=null && line!="\n"){
            next = reader.readLine();
            content += line;
            if(next!=null)
                content += '\n';
            line = next;
        }
        reader.close()
        return content
    }catch(e : Exception){
        e.printStackTrace()
        return null
    }
    
}

fun writeToFile(fileName : String, output : String){
    try{
        val writer : PrintWriter = PrintWriter(fileName);
        writer.println(output);
        writer.close();
    }catch(e : Exception){
        e.printStackTrace();
    }
    
}

fun interleave(source : String, cols : Int) : String{

    val result : StringBuilder = StringBuilder("")
    val lines : Int = (source.length/cols).toInt() + 1

    var idx : Int = 0
    var col_idx = 0
    while(col_idx<cols){

        var line_idx = 0
        while(line_idx<lines){

            idx = line_idx*cols + col_idx
            if(idx >= source.length) break
            result.append(source[idx])
            line_idx++
        }
        col_idx++
    }

    return result.toString()
}

fun deinterleave(source : String, cols_param : Int) : String{

    val result : StringBuilder = StringBuilder("")
    var len : Int = source.length

    var lines : Int = cols_param
    var cols = len/lines
    if(len%lines != 0) cols++

    val remainder : Int = (len%cols)
    val empty_spaces : Int = cols - remainder
    val moved_chrs : Int = (empty_spaces-1) * (cols-1)

    var idx : Int = 0
    var col_idx : Int = 0
    while(col_idx<cols){
        var line_idx = 0
        while(line_idx<lines){

            idx = line_idx*cols + col_idx
            
            if (remainder != 0){
                if (idx + moved_chrs == len) break
                if (idx + moved_chrs > len)
                    idx -= (empty_spaces - (lines-line_idx) )

            }
            if (idx >= len) break
            
            result.append(source[idx]);
            line_idx++
        }
        col_idx++
    }

    return result.toString()
}

val ITERATIONS = 10_000;

fun time_it(test : Boolean = false) : Long {

    val str : String = readFromFile("..\\TheRaven.txt")!!
    var str_inter : String = ""
    var str_deinter : String = ""

    val time_start : Long = System.nanoTime()
    
    var counter : Int = 0
    while(counter<ITERATIONS){
        str_inter = interleave(str, 4)
        str_deinter = deinterleave(str_inter, 4)
        counter++
    }

    val time_end : Long = System.nanoTime()
    if(test){
        writeToFile("TheRaven_inter.txt", str_inter);
        writeToFile("TheRaven_deinter.txt", str_deinter);
    }
    return (time_end-time_start)/1000
}

fun main(args : Array<String>){

    val discard = time_it()
    
    val time_micro = time_it(true)

    val avg_duration_us = time_micro/ITERATIONS
    val full_duration_ms = time_micro/1000
    println( "TOTAL:\t$full_duration_ms \tmilli seconds\nAVG:\t$avg_duration_us \tmicro seconds")

}