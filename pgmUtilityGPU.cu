#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include "pgmUtility.h"
#include "pgmUtilityGPU.h"
#include "pgmProcess.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

// Implement or define each function prototypes listed in pgmUtility.h file.
// NOTE: Please follow the instructions stated in the write-up regarding the interface of the functions.
// NOTE: You might have to change the name of this file into pgmUtility.cu if needed.


//---------------------------------------------------------------------------
//
int pgmDrawCircleGPU( int *pixelsGPU, int numRows, int numCols, int centerRow,
    int centerCol, int radius, char **header )
{

    int *h_pixels=0, *d_pixels=0; // host/device pointers
    int bytes = numRows * numCols * sizeof( int);

    h_pixels = (int*)malloc(bytes);
    cudaMalloc( &d_pixels, bytes );

    if( 0==d_pixels )
    {
        printf("couldn't allocate memory\n");
        return -1;
    }
    
    cudaMemcpy( d_pixels, pixelsGPU, bytes, cudaMemcpyHostToDevice);

    dim3 grid, block;

    block.x = 32;
    block.y = 32;
    grid.x  = ceil( (float)numCols / block.x );
    grid.y  = ceil( (float)numRows / block.y );

    printf("\ngrid: %d, %d\nblock: %d, %d\n", grid.x, grid.y, block.x, block.y);
    
    calcDist<<<grid, block>>>(d_pixels, numRows, numCols, centerCol, centerRow, radius);
    cudaMemcpy( h_pixels, d_pixels, bytes, cudaMemcpyDeviceToHost );
    memcpy(pixelsGPU, h_pixels, bytes);

    free( h_pixels );
    cudaFree( d_pixels );

  return 0; // :)

}

//---------------------------------------------------------------------------
int pgmDrawEdgeGPU( int *pixelsGPU, int numRows, int numCols, int edgeWidth, char **header )
{
  //   int *d_pixels=0; // device pointers
  //   int bytes = numRows * numCols * sizeof( int );

  // //   h_a = (int*)malloc(num_bytes);
  //   cudaMalloc( (void**)&d_pixels, bytes );

  //   if( 0==d_pixels )
  //   {
  //       printf("couldn't allocate memory\n");
  //       return -1;
  //   }
  //   cudaMemcpy( d_pixels, pixels, bytes, cudaMemcpyHostToDevice);

  //   dim3 grid, block;

  //   block.x = 32;
  //   block.y = 32;
  //   grid.x  = ceil( (float)numCols / block.x );
  //   grid.y  = ceil( (float)numRows / block.y );

  
  int *h_pixels=0, *d_pixels=0; // host/device pointers
    int bytes = numRows * numCols * sizeof( int);

    h_pixels = (int*)malloc(bytes);
    cudaMalloc( &d_pixels, bytes );

    if( 0==d_pixels )
    {
        printf("couldn't allocate memory\n");
        return -1;
    }
    
    cudaMemcpy( d_pixels, pixelsGPU, bytes, cudaMemcpyHostToDevice);

    dim3 grid, block;

    block.x = 32;
    block.y = 32;
    grid.x  = ceil( (float)numCols / block.x );
    grid.y  = ceil( (float)numRows / block.y );

    printf("\ngrid: %d, %d\nblock: %d, %d\n", grid.x, grid.y, block.x, block.y);
    
    
  edgeKernel<<<grid, block>>>( d_pixels , numCols, numRows, edgeWidth );

  cudaMemcpy( h_pixels, d_pixels, bytes, cudaMemcpyDeviceToHost );
  memcpy(pixelsGPU, h_pixels, bytes);

  free( h_pixels );
  cudaFree( d_pixels );

  // cudaMemcpy( pixels, d_pixels, bytes, cudaMemcpyDeviceToHost );
  // //printArr(pixels, "edge ", numRows, numCols);
  // cudaFree( d_pixels );
  return 1;
}

//---------------------------------------------------------------------------

int pgmDrawLineGPU( int *pixels, int numRows, int numCols, char **header,  int p1row, int p1col, int p2row, int p2col )
{

    float slope;
    float b;
    int tempMaxX, tempMaxY;
    int tempMinX, tempMinY;

    slope = ((float)(p2row - p1row)) / ((float)(p2col - p1col));
    b = p1row - slope * p1col;

    float range = slope / 2;
    if (slope > -1 || slope < 1) {
        range = .51;
    }

    if (p2row < p1row) {
        tempMinY = p2row;
        tempMaxY = p1row;
    }
    else {
        tempMinY = p1row;
        tempMaxY = p2row;
    }
    if (p2col < p1col) {
        tempMinX = p2col;
        tempMaxX = p1col;
    }
    else {
        tempMinX = p1col;
        tempMaxX = p2col;
    }



    //allocate memory on GPU
    int* array4GPU=0;
    size_t bytes = (sizeof(int) * numCols * numRows);
    cudaMalloc(&array4GPU, bytes);
    //copy memory from CPU - > GPU
    cudaMemcpy(array4GPU, pixels, bytes, cudaMemcpyHostToDevice);
    //calculate gridsize and block size
    dim3 grid, block;

    block.x = 32;
    block.y = 32;
    block.z = 1;
    grid.x  = ceil( (float)numCols / block.x );
    grid.y  = ceil( (float)numRows / block.y );
    grid.z = 1;
    // dim3 blockDim = (32, 32, 1);// (x,y,z)// 1024 threads a block
    // dim3 gridDim = (ceil(numCols / 32), ceil(numRows / 32), 1);//(x,y,z)
    //call the kernel

    gpuLineDraw <<< grid, block >>> (array4GPU, numRows, numCols, p1row, p1col, p2row, p2col, slope, b, tempMaxX, tempMaxY, tempMinX, tempMinY, range);

    //copy memory from GPU - > CPU
    cudaMemcpy(pixels, array4GPU, bytes, cudaMemcpyDeviceToHost);
    //free memory from gpu
    cudaFree(&array4GPU);


  return 0;
}

