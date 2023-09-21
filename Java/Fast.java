import java.io.BufferedReader;
import java.io.FileReader;
import java.io.PrintWriter;

//Using a StringBuilder
class Fast{

    private static final String SOURCE_FILE = "..\\TheRaven.txt";
    private static final String INTER_FILE = "TheRaven_inter.txt";
    private static final String DEINTER_FILE = "TheRaven_deinter.txt";

    private static String readFromFile(final String fileName){
        try{
            BufferedReader reader = new BufferedReader( new FileReader(fileName));
            String content = "";
            String next = reader.readLine();
            String line = next;
            while(line!=null && line!="\n"){
                next = reader.readLine();
                content += line;
                if(next!=null)
                    content += '\n';
                line = next;
            }
            reader.close();
            return content;
        }catch(Exception e){
            e.printStackTrace();
        }
        return null;
        
    }

    private static void writeToFile(final String fileName, final String output){
        try{
            PrintWriter writer = new PrintWriter(fileName);
            writer.println(output);
            writer.close();
        }catch(Exception e){
            e.printStackTrace();
        }
        
    }

    private static String interleave(final String source, final int cols){
    
        StringBuilder result = new StringBuilder("");
        final int lines = (int)(source.length()/cols) + 1;
        int idx = 0;

        for(int col_idx = 0; col_idx<cols; col_idx++){
            for(int line_idx = 0; line_idx<lines; line_idx++){

                idx = line_idx*cols + col_idx;
                if(idx >= source.length()) break;
                result.append(source.charAt(idx));

            }
        }
        
        return result.toString();
    }

    private static String deinterleave(final String source, int cols){
    
        StringBuilder result = new StringBuilder("");
        final int len = source.length();

        final int lines = cols;
        cols = len/lines;
        if(len%lines != 0) cols++;

        final int remainder = (len%cols);
        final int empty_spaces = cols - remainder;
        final int moved_chrs = (empty_spaces-1) * (cols-1);

        int idx = 0;

        for(int col_idx = 0; col_idx<cols; col_idx++){
            for(int line_idx = 0; line_idx<lines; line_idx++){

                idx = line_idx*cols + col_idx;
                
                if (remainder != 0){
                    if (idx + moved_chrs == len) break;
                    if (idx + moved_chrs > len)
                        idx -= (empty_spaces - (lines-line_idx) );

                }
                if (idx >= len) break;
                
                result.append(source.charAt(idx));

            }
        }

        return result.toString();
    }

    public static long time_it(boolean test, final int ITERATIONS){

        final String str = readFromFile(SOURCE_FILE);
        String str_deinter = "";
        String str_inter = "";

        final long time_start = System.nanoTime();
        
        for(int counter = 0; counter<ITERATIONS; counter++){
            str_inter = interleave(str, 4);
            str_deinter = deinterleave(str_inter, 4);
        }

        final long time_end = System.nanoTime();

        if(test){
            writeToFile(INTER_FILE, str_inter);
            writeToFile(DEINTER_FILE, str_deinter);
        }
        
        return (time_end-time_start)/1000;
    }

}
