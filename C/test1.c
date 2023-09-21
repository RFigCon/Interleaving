#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

unsigned char *read_from_file(char file_name[], long* size){

    FILE *file_orig = fopen(file_name, "r");

    FILE *file_copy = fopen(file_name, "r");

    long file_size = -1;

    int ch;
    //printf("\nFinding size:\n");
    do{
        ch = fgetc(file_copy);
        file_size++;
        //printf("%c", ch);
    }while(ch != EOF);

    unsigned char *buffer = malloc(file_size + 1);

    //printf("\nNow Reading:\n");
    int idx = 0;
    while(idx != file_size){
        buffer[idx] = fgetc(file_orig);
        //printf("%c", buffer[idx]);
        idx++;
    }
    //printf("\nBuffer: %s\n", buffer);
    buffer[file_size] = 0;
    *size = file_size;

    fclose(file_orig);
    fclose(file_copy);
    return buffer;
}

void write_to_file(char file_name[], unsigned char const *stream){
    FILE *fp = fopen(file_name, "w");
    fputs(stream, fp);
    fclose(fp);
}

void interleave(unsigned char const *source, long const source_size, unsigned char *target_start, unsigned int cols){
    
    unsigned char *target_p = target_start;
    // unsigned int target_idx = 0;
    unsigned int lines = (int)(source_size/cols) + 1;
    unsigned int idx = 0;

    for(unsigned int col_idx = 0; col_idx<cols; col_idx++){
        for(unsigned int line_idx = 0; line_idx<lines; line_idx++){

            idx = line_idx*cols + col_idx;
            if(idx >= source_size) break;
            *target_p = source[idx];
            target_p++;

            // target_start[target_idx] = source[idx];
            // target_idx++;
        }
    }
    *target_p = 0;

    // target_start[target_idx] = 0;
}

void deinterleave(unsigned char const *source, long const source_size, unsigned char *target_start, unsigned int cols){
    
    unsigned char *target_p = target_start;
    //unsigned int target_idx = 0;

    unsigned int const lines = cols;
    cols = source_size/lines;
    if(source_size%lines != 0) cols++;

    unsigned int const remainder = (source_size%cols);
    unsigned int const empty_spaces = cols - remainder;
    unsigned int const moved_chrs = (empty_spaces-1) * (cols-1);

    unsigned int idx = 0;

    for(unsigned int col_idx = 0; col_idx<cols; col_idx++){
        for(unsigned int line_idx = 0; line_idx<lines; line_idx++){

            idx = line_idx*cols + col_idx;
            if (remainder != 0){
                if (idx + moved_chrs == source_size) break;
                if (idx + moved_chrs > source_size)
                    idx -= (empty_spaces - (lines-line_idx) );

            }
            
            if (idx >= source_size) break;
            
            *target_p = source[idx];
            target_p++;

            // target_start[target_idx] = source[idx];
            // target_idx++;
        }
    }
    *target_p = 0;

    // target_start[target_idx] = 0;
    // return target_start;
}

int const ITERATIONS = 10000;

long time_it(char test){
    struct timeval start, end;

    //gettimeofday(&start, NULL);

    long size;
    unsigned char* source = read_from_file("..\\TheRaven.txt", &size);
    //unsigned char const *source = read_from_file("lol.txt", &size);
    int counter = 0;
    unsigned char *str_inter = malloc(size+1);
    unsigned char *str_deinter = malloc(size+1);
    //unsigned char str_test[size+1];


    gettimeofday(&start, NULL);

    for(; counter<ITERATIONS; counter++){
        interleave(source, size, str_inter, 4);
        deinterleave(str_inter, size, str_deinter, 4);
    }

    free(source);

    gettimeofday(&end, NULL);


    /* Check if it's working: */
    if(test == 1){
        source = read_from_file("..\\TheRaven.txt", &size);
        interleave(source, size, str_inter, 4);
        deinterleave(str_inter, size, str_deinter, 4);
        
        write_to_file("TheRaven_inter.txt", str_inter);
        write_to_file("TheRaven_deinter.txt", str_deinter);
        free(source);
    }

    free(str_inter);
    free(str_deinter);

    //gettimeofday(&end, NULL);

    long seconds = (end.tv_sec - start.tv_sec);
    long micros = (seconds * 1000000) + (end.tv_usec - start.tv_usec);
    
    return micros;
}

int main(){

    long const discard = time_it(0);
    
    long const time_micro = time_it(1);

    printf("TOTAL: %d milli seconds\nAVG: %d micro seconds", time_micro/1000, time_micro/ITERATIONS);

}