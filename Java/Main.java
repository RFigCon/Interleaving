class Main {

    static final int ITERATIONS = 10_000;
    
    public static void main (String args[]){

        long time_start, time_end, time_micro;

        if(args.length == 0 ) return;

        if(args[0].equalsIgnoreCase("optm")){

            time_start = System.nanoTime();

            Optm.time_it(true, ITERATIONS);
            time_micro = Optm.time_it(true, ITERATIONS);

            time_end = System.nanoTime();

        }else if(args[0].equalsIgnoreCase("fast")){

            time_start = System.nanoTime();

            Fast.time_it(true, ITERATIONS);
            time_micro = Fast.time_it(true, ITERATIONS);

            time_end = System.nanoTime();

        }else{
            System.out.println("Bad Arguments");
            return;
        }
        

        System.out.println( "TOTAL:\t" + (time_micro/1000) + " \tmilli seconds");
        System.out.println( "AVG:\t" + (time_micro/ITERATIONS) + " \tmicro seconds");
        System.out.println("TOTAL PROGRAM TIME:\t" + (time_end-time_start)/1000/1000 + " milli seconds");
    }
}
