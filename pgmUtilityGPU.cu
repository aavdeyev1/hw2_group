#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include "pgmUtility.h"
#include "pgmUtilityGPU.h"
#include "pgmProcess.h"

// Implement or define each function prototypes listed in pgmUtility.h file.
// NOTE: Please follow the instructions stated in the write-up regarding the interface of the functions.
// NOTE: You might have to change the name of this file into pgmUtility.cu if needed.


//---------------------------------------------------------------------------
//
int pgmDrawCircleGPU( int *pixelsGPU, int numRows, int numCols, int centerRow,
    int centerCol, int radius, char **header )
{

    int *h_pixels=0, *d_pixels=0; // device pointers
    int bytes = numRows * numCols * sizeof( int);

    h_pixels = (int*)malloc(bytes);
    cudaMalloc( &d_pixels, bytes );

    if( 0==d_pixels )
    {
        printf("couldn't allocate memory\n");
        return -1;
    }
    
    // cudaMemset( d_pixels, 0, bytes );
    cudaMemcpy( d_pixels, pixelsGPU, bytes, cudaMemcpyHostToDevice);

    dim3 grid, block;

    block.x = 32;
    block.y = 32;
    grid.x  = ceil( (float)numCols / block.x );
    grid.y  = ceil( (float)numRows / block.y );

    printf("%d, grid: %d, %d\nblock: %d, %d\n", bytes, grid.x, grid.y, block.x, block.y);
    
    
    //   // Use kernel to fill d_a array
    calcDist<<<grid, block>>>(d_pixels, numRows, numCols, centerCol, centerRow, radius);
    cudaMemcpy( h_pixels, d_pixels, bytes, cudaMemcpyDeviceToHost );
    memcpy(pixelsGPU, h_pixels, bytes);
    //   strcpy(somestr, " kernel ");
    // // boo = calcDist(j, i, centerCol, centerRow, radius);

    //         //if our 'boolean' is 'true'...
    //   pixels[(i * numCols + j)] = 0;

    free( h_pixels );
    cudaFree( d_pixels );

    //   free(somestr);

  return 0; // :)

}

//---------------------------------------------------------------------------
int pgmDrawEdgeGPU( int *pixels, int numRows, int numCols, int edgeWidth, char **header )
{
  return 0;
}

//---------------------------------------------------------------------------

int pgmDrawLineGPU( int *pixels, int numRows, int numCols, char **header,
  int p1row, int p1col, int p2row, int p2col )
{

  return 0;
}
