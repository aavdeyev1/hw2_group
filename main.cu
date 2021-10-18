#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <string.h>
// #include "cuda_runtime.h"
// #include "device_launch_parameters.h"
#include "pgmUtility.h"
#include "pgmUtilityGPU.h"
#include "pgmProcess.h"

void usage();

int main(int argc, char *argv[]){

    // int p1[] = {1, 1};
    // int p2[] = {0, 0};x
    // double distance;
    // distance =  distanceSquared( p1, p2 );
    // printf("THIS THE ONE: %f", distance);
    
    FILE * fp = NULL;
    FILE * out = NULL;
    FILE * outGPU = NULL; 

    char ** header = (char**) malloc( sizeof(char *) * rowsInHeader);
    int i;
    int * pixels = NULL;
    int * pixelsGPU = NULL;
    for(i = 0; i < 4; i++){
        header[i] = (char *) malloc (sizeof(char) * maxSizeHeadRow);
    }
    int numRows, numCols;

    int p1y = 0;
    int p1x = 0;
    int p2y = 0;
    int p2x = 0;

    int m, n, l, x, ch;
    int edgeWidth, circleCenterRow, circleCenterCol, radius;
    char originalImageName[100], newImageFileName[100];
    if(argc != 5 && argc != 7 && argc != 8)
    {
                usage();
        return 1;
        }
    else
    {            
        l = strlen( argv[1] );
        if(l != 2){
            usage();
            return 1;
        }
        ch = (int)argv[1][1];
        if(ch < 97)
            ch = ch + 32;
        switch( ch )
        {
            case 'c':  
                if(argc != 7){
                    usage();
                    break;
                }
                circleCenterRow = atoi(argv[2]);
                circleCenterCol = atoi(argv[3]);
                radius = atoi(argv[4]);
                strcpy(originalImageName, argv[5]);
                strcpy(newImageFileName, argv[6]);

                fp = fopen(originalImageName, "r");
                if(fp == NULL){
                    usage();
                    return 1;
                }
                out = fopen(newImageFileName, "w");
                if(out == NULL){
                    usage();
                    fclose(fp);
                    return 1;
                }
                outGPU = fopen(strcat(newImageFileName, "GPU"), "w");
                if(outGPU == NULL){
                    usage();
                    fclose(fp);
                    return 1;
                }


                pixels = pgmRead(header, &numRows, &numCols, fp);
                // printArr(pixels, numRows, numCols);
                // int p1[] = {1, 1};
                // int p2[] = {0, 0};
                // double distance;
                // distance =  distanceSquared( p1, p2 );
                // printf("THIS THE ONE: %f", distance);
                // pixelsGPU = ( int * ) malloc( ( numRows ) * ( numCols) * sizeof( int ) );
                // memcpy(pixelsGPU, pixels, ( numRows ) * ( numCols) * sizeof( int ) );
                
                // CPU
                pgmDrawCircle(pixels, numRows, numCols, circleCenterRow, circleCenterCol, radius, header );
                printArr(pixels, numRows, numCols);
                // pgmWrite((const char **)header, (const int *)pixels, numRows, numCols, out );  
                pixels = pgmRead(header, &numRows, &numCols, fp);

                // GPU
                pgmDrawCircleGPU(pixels, numRows, numCols, circleCenterRow, circleCenterCol, radius, header );
                printArr(pixels, numRows, numCols);
                // pgmWrite((const char **)header, (const int *)pixelsGPU, numRows, numCols, outGPU );  

                break;
            case 'e':  
                if(argc != 5){
                    usage();
                    break;
                }
                edgeWidth = atoi(argv[2]);
                strcpy(originalImageName, argv[3]);
                strcpy(newImageFileName, argv[4]);
                fp = fopen(originalImageName, "r");
                if(fp == NULL){
                    usage();
                    return 1;
                }
                out = fopen(newImageFileName, "w");
                if(out == NULL){
                    usage();
                    fclose(fp);
                    return 1;
                }
                outGPU = fopen(strcat(newImageFileName, "GPU"), "w");
                if(outGPU == NULL){
                    usage();
                    fclose(fp);
                    return 1;
                }

                pixels = pgmRead(header, &numRows, &numCols, fp);
                pixelsGPU = pixels;

                // CPU
                pgmDrawEdge(pixels, numRows, numCols, edgeWidth, header);
                pgmWrite((const char **)header, (const int *)pixels, numRows, numCols, out );
                
                // GPU
                // pgmDrawEdgeGPU(pixelsGPU, numRows, numCols, edgeWidth, header);
                // pgmWrite((const char **)header, (const int *)pixelsGPU, numRows, numCols, outGPU );
                
                break;

            case 'l':  
                if(argc != 8){
                    usage();
                    break;
                }
                p1y = atoi(argv[2]);
                p1x = atoi(argv[3]);

                p2y = atoi(argv[4]);
                p2x = atoi(argv[5]);


                strcpy(originalImageName, argv[6]);
                strcpy(newImageFileName, argv[7]);

                fp = fopen(originalImageName, "r");
                if(fp == NULL){
                    usage();
                    return 1;
                }
                out = fopen(newImageFileName, "w");
                if(out == NULL){
                    usage();
                    fclose(fp);
                    return 1;
                }
                outGPU = fopen(strcat(newImageFileName, "GPU"), "w");
                if(outGPU == NULL){
                    usage();
                    fclose(fp);
                    return 1;
                }

                pixels = pgmRead(header, &numRows, &numCols, fp);
                pixelsGPU = pixels;

                // CPU
                pgmDrawLine(pixels, numRows, numCols, header, p1y, p1x, p2y, p2x);
                pgmWrite((const char **)header, (const int *)pixels, numRows, numCols, out );
                
                // GPU
                // pgmDrawLineGPU(pixelsGPU, numRows, numCols, header, p1y, p1x, p2y, p2x);
                // pgmWrite((const char **)header, (const int *)pixelsGPU, numRows, numCols, outGPU );
                
                break;
        }      
    }

    // Not needed for 1D representation
    // i = 0;
    // for(;i < numRows; i++)
    //     free(pixels[i]);
    free(pixels);
    free(pixelsGPU);
    i = 0;
    for(;i < rowsInHeader; i++)
        free(header[i]);
    free(header);
    if(out != NULL)
        fclose(out);
    if(fp != NULL)
        fclose(fp);

    m = 0;
    n = 0;
    x = 0;
    printf("m: %d, n: %d, x: %d\n", m, n, x);
    return 0;
}

void usage()
{
        printf("Usage:\n    -e edgeWidth  oldImageFile  newImageFile\n    -c circleCenterRow circleCenterCol radius  oldImageFile  newImageFile\n    -l  p1row  p1col  p2row  p2col  oldImageFile  newImageFile\n");

}
