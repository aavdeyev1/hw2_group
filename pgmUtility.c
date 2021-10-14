
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string.h>

#include "pgmUtility.h"

// Implement or define each function prototypes listed in pgmUtility.h file.
// NOTE: Please follow the instructions stated in the write-up regarding the interface of the functions.
// NOTE: You might have to change the name of this file into pgmUtility.cu if needed.


int * pgmRead( char **header, int *numRows, int *numCols, FILE *in )
{
    int i, j;

    // read in header of the image first
    for( i = 0; i < rowsInHeader; i ++)
    {
        if ( header[i] == NULL )
        {
            return NULL;
        }
        if( fgets( header[i], maxSizeHeadRow, in ) == NULL )
        {
            return NULL;
        }
    }
    // extract rows of pixels and columns of pixels
    sscanf( header[rowsInHeader - 2], "%d %d", numCols, numRows );  // in pgm the first number is # of cols

    // Now we can intialize the pixel of 2D array, allocating memory
    int *pixels = ( int * ) malloc( ( *numRows ) * ( *numCols) * sizeof( int * ) ); //This is for 1d array
//    for( i = 0; i < *numRows; i ++)
//    {
//        pixels[i] = ( int * ) malloc( ( *numCols ) * sizeof( int ) );
//        if ( pixels[i] == NULL )
//        {
//            return NULL;
//        }
//    }

    // read in all pixels into the pixels array.
    for( i = 0; i < *numRows; i ++ )
        for( j = 0; j < *numCols; j ++ )
            if ( fscanf(in, "%d ", &pixels[(i * *numCols + j)] < 0)) //(i * numCol + j)
                return NULL;

    return pixels;
}

int pgmWrite( const char **header, const int *pixels, int numRows, int numCols, FILE *out )
{
    int i, j;

    // write the header
    for ( i = 0; i < rowsInHeader; i ++ )
    {
        fprintf(out, "%s", *( header + i ) );
    }

    // write the pixels
    for( i = 0; i < numRows; i ++ )
    {
        for ( j = 0; j < numCols; j ++ )
        {
            if ( j < numCols - 1 )
                fprintf(out, "%d ", pixels[(i * numCols + j)]);
            else
                fprintf(out, "%d\n", pixels[(i * numCols + j)]);
        }
    }
    return 0;
}

//---------------------------------------------------------------------------
//
int pgmDrawCircle( int *pixels, int numRows, int numCols, int centerRow,
                  int centerCol, int radius, char **header )
{

}

//---------------------------------------------------------------------------
int pgmDrawEdge( int *pixels, int numRows, int numCols, int edgeWidth, char **header )
{

}

//---------------------------------------------------------------------------

int pgmDrawLine( int *pixels, int numRows, int numCols, char **header,
                int p1row, int p1col, int p2row, int p2col )
{

}

//-------------------------------------------------------------------------------
double distance( int p1[], int p2[] )
{
    return sqrt( pow( p1[0] - p2[0], 2 ) + pow( p1[1] - p2[1], 2 ) );
}

// print array 
void printArr(int *a, int dimy, int dimx)
{
    printf("==============================================================================\n");
    for(int row=0; row<dimy; row++)
    {
        for(int col=0; col<dimx; col++)
            printf("%-4d ", a[row*dimx+col] );
        printf("\n");
    }
    printf("==============================================================================\n");
}

