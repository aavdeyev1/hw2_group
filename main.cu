#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <string.h>

#include <fstream>
#include <iostream>

#include "pgmUtility.h"
#include "pgmUtilityGPU.h"
#include "pgmProcess.h"

void usage();

int main(int argc, char *argv[]){
    // CPU processed files are stored as the filename given in the args
    // GPU processed files are stored under the same filename but prefixed with GPU_
    std::ofstream myfile;
    clock_t startCPU;
    double cpuStart;
    clock_t endCPU;
    double cpuEnd;

    clock_t startGPU;
    double gpuStart;
    clock_t endGPU;
    double gpuEnd;

    long double diffCPU;
    long double diffGPU;


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

    int l, ch;
    int edgeWidth, circleCenterRow, circleCenterCol, radius;
    char newImageFileName[100], originalImageName[100];
    char gpu[] = "GPU_";
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

                // Get filenames from command line args
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
                outGPU = fopen(strcat(gpu, newImageFileName), "w");
                if(outGPU == NULL){
                    usage();
                    fclose(fp);
                    return 1;
                }


                pixels = pgmRead(header, &numRows, &numCols, fp);
                pixelsGPU = ( int * ) malloc(numCols*numRows*sizeof(int));
                memcpy(pixelsGPU, pixels, numCols*numRows*sizeof(int));
                
                // CPU
                startCPU = clock();
                cpuStart = (double) startCPU/CLOCKS_PER_SEC;
                pgmDrawCircle(pixels, numRows, numCols, circleCenterRow, circleCenterCol, radius, header );
                pgmWrite((const char **)header, (const int *)pixels, numRows, numCols, out );  
                endCPU = clock();
                cpuEnd = (double) endCPU/CLOCKS_PER_SEC;
                // GPU
                startGPU = clock();
                gpuStart = (double) startGPU/CLOCKS_PER_SEC;               
                pgmDrawCircleGPU(pixelsGPU, numRows, numCols, circleCenterRow, circleCenterCol, radius, header );
                pgmWrite((const char **)header, (const int *)pixelsGPU, numRows, numCols, outGPU );  
                endGPU = clock();
                gpuEnd = (double) endGPU/CLOCKS_PER_SEC;


                diffCPU = cpuEnd - cpuStart;
                diffGPU = gpuEnd - gpuStart;

                //then send them all to the an output file
                myfile.open ("TimeResults");
                myfile << "CPU Process Time: " << diffCPU << "\n";
                myfile << "GPU Process Time: " << diffGPU << "\n\n";
                myfile.close();                                

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
                outGPU = fopen(strcat(gpu, newImageFileName), "w");
                if(outGPU == NULL){
                    usage();
                    fclose(fp);
                    return 1;
                }

                pixels = pgmRead(header, &numRows, &numCols, fp);

                pixelsGPU = ( int * ) malloc(numCols*numRows*sizeof(int));
                memcpy(pixelsGPU, pixels, numCols*numRows*sizeof(int));

                // CPU
                startCPU = clock();
                cpuStart = (double) startCPU/CLOCKS_PER_SEC;
                pgmDrawEdge(pixels, numRows, numCols, edgeWidth, header);
                pgmWrite((const char **)header, (const int *)pixels, numRows, numCols, out );
                endCPU = clock();
                cpuEnd = (double) endCPU/CLOCKS_PER_SEC;
                // GPU
                startGPU = clock();
                gpuStart = (double) startGPU/CLOCKS_PER_SEC;
                pgmDrawEdgeGPU(pixelsGPU, numRows, numCols, edgeWidth, header);
                pgmWrite((const char **)header, (const int *)pixelsGPU, numRows, numCols, outGPU );
                endGPU = clock();
                gpuEnd = (double) endGPU/CLOCKS_PER_SEC;

                diffCPU = cpuEnd - cpuStart;
                diffGPU = gpuEnd - gpuStart;

                //then send them all to the an output file
                myfile << "CPU Process Time: " << diffCPU << "\n";
                myfile << "GPU Process Time: " << diffGPU << "\n\n";
                myfile.close();                                

                break;

            case 'l':  
                if(argc != 8){
                    printf("HERE: %d", argc);
                    usage();
                    break;
                }
                p1y = atoi(argv[2]);
                p1x = atoi(argv[3]);

                p2y = atoi(argv[4]);
                p2x = atoi(argv[5]);


                // Get filenames from command line args
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
                outGPU = fopen(strcat(gpu, newImageFileName), "w");
                if(outGPU == NULL){
                    usage();
                    fclose(fp);
                    return 1;
                }


                pixels = pgmRead(header, &numRows, &numCols, fp);
                pixelsGPU = ( int * ) malloc(numCols*numRows*sizeof(int));
                memcpy(pixelsGPU, pixels, numCols*numRows*sizeof(int));
                
                // CPU
                startCPU = clock();
                cpuStart = (double) startCPU/CLOCKS_PER_SEC;                
                pgmDrawLine(pixels, numRows, numCols, header, p1y, p1x, p2y, p2x);
                pgmWrite((const char **)header, (const int *)pixels, numRows, numCols, out );
                endCPU = clock();
                cpuEnd = (double) endCPU/CLOCKS_PER_SEC;               
                // GPU
                startGPU = clock();
                gpuStart = (double) startGPU/CLOCKS_PER_SEC;                
                pgmDrawLineGPU(pixelsGPU, numRows, numCols, header, p1y, p1x, p2y, p2x);
                pgmWrite((const char **)header, (const int *)pixelsGPU, numRows, numCols, outGPU );
                endGPU = clock();
                gpuEnd = (double) endGPU/CLOCKS_PER_SEC;

                diffCPU = cpuEnd - cpuStart;
                diffGPU = gpuEnd - gpuStart;

                //then send them all to the an output file
                myfile << "CPU Process Time: " << diffCPU << "\n";
                myfile << "GPU Process Time: " << diffGPU << "\n\n";
                myfile.close();                                
                break;
        }      
    }
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

    return 0;
}

void usage()
{
        printf("Usage:\n    -e edgeWidth  oldImageFile  newImageFile\n    -c circleCenterRow circleCenterCol radius  oldImageFile  newImageFile\n    -l  p1row  p1col  p2row  p2col  oldImageFile  newImageFile\n");

}
