#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include "pgmUtilityGPU.h"

// Implement or define each function prototypes listed in pgmUtility.h file.
// NOTE: Please follow the instructions stated in the write-up regarding the interface of the functions.
// NOTE: You might have to change the name of this file into pgmUtility.cu if needed.


//---------------------------------------------------------------------------
//
int pgmDrawCircleGPU( int *pixels, int numRows, int numCols, int centerRow,
    int centerCol, int radius, char **header )
{

}

//---------------------------------------------------------------------------
int pgmDrawEdgeGPU( int *pixels, int numRows, int numCols, int edgeWidth, char **header )
{
    int *d_pixels=0; // device pointers
    int bytes = numRows * numCols * sizeof( int );

  //   h_a = (int*)malloc(num_bytes);
    cudaMalloc( (void**)&d_pixels, bytes );

    if( 0==d_pixels )
    {
        printf("couldn't allocate memory\n");
        return -1;
    }
    cudaMemcpy( d_pixels, pixels, bytes, cudaMemcpyHostToDevice);

    dim3 grid, block;

    block.x = 32;
    block.y = 32;
    grid.x  = ceil( (float)numCols / block.x );
    grid.y  = ceil( (float)numRows / block.y );
    
    
  edgeKernel<<<grid, block>>>( d_pixels , numCols, numRows, edgeWidth );
  cudaMemcpy( pixels, d_pixels, bytes, cudaMemcpyDeviceToHost );
  //printArr(pixels, "edge ", numRows, numCols);
  cudaFree( d_pixels );
  return 1;
}

//---------------------------------------------------------------------------

int pgmDrawLineGPU( int *pixels, int numRows, int numCols, char **header,
  int p1row, int p1col, int p2row, int p2col )
{

}
