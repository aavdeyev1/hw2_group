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

    int *d_pixels=0; // device pointers
    size_t bytes = numRows * numCols * sizeof( int );

  //   h_a = (int*)malloc(num_bytes);
    cudaMalloc( (void*)&d_pixels, bytes );

    if( 0==h_a || 0==d_a )
    {
        printf("couldn't allocate memory\n");
        return 1;
    }

    cudaMemset( d_pixels, 0, bytes );

  //   dim3 grid, block;
  //   block.x = 3;
  //   block.y = 4;
  //   grid.x  = ceil( (float)dimx / block.x );
  //   grid.y  = ceil( (float)dimy / block.y );
  //   char *somestr = (char *)malloc(9*sizeof(char));
    
    
  //   // Use kernel to fill d_a array
  //   kernel<<<grid, block>>>( d_a, dimx, dimy );
    cudaMemcpy( h_a, d_a, num_bytes, cudaMemcpyDeviceToHost );
  //   strcpy(somestr, " kernel ");
  // // boo = calcDist(j, i, centerCol, centerRow, radius);

  //         //if our 'boolean' is 'true'...
  //   pixels[(i * numCols + j)] = 0;

  //   free( h_a );
    cudaFree( d_a );

  //   free(somestr);

  return 0; // :)

}

//---------------------------------------------------------------------------
int pgmDrawEdgeGPU( int *pixels, int numRows, int numCols, int edgeWidth, char **header )
{

}

//---------------------------------------------------------------------------

int pgmDrawLineGPU( int *pixels, int numRows, int numCols, char **header,
  int p1row, int p1col, int p2row, int p2col )
{

}
