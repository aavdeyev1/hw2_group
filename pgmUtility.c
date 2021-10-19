
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
    printf("IN PGNUTILITY 1: %d, %d\n", *numCols, *numRows);

    // read in header of the image first
    for( i = 0; i < rowsInHeader; i ++)
    {
        if ( header[i] == NULL )
        {
            printf("IN PGNUTILITY NULL1: %d, %d\n", *numCols, *numRows);
            return NULL;
        }
        if( fgets( header[i], maxSizeHeadRow, in ) == NULL )
        {
            printf("IN PGNUTILITY NULL2: %d, %d\n", *numCols, *numRows);
            return NULL;
        }
    }
    // extract rows of pixels and columns of pixels
    sscanf( header[rowsInHeader - 2], "%d %d", numCols, numRows );  // in pgm the first number is # of cols
    printf("IN PGNUTILITY: %d, %d\n", *numCols, *numRows);
    // Now we can intialize the pixel of 2D array, allocating memory
    // NOT sizeof(int *)!!!
    int *pixels = ( int * ) malloc( ( *numRows ) * ( *numCols) * sizeof( int )); //This is for 1d array
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
            if ( fscanf(in, "%d ", &pixels[i * *numCols + j]) < 0) // Causing error
            //(i * numCol + j)
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
    int i, j, boo; //boo = ghetto boolean

    for (i = 0; i < numRows; i++) {
        
        for (j = 0; j< numCols; j++) {
            //call the new method here............
            boo = calcDist(j, i, centerCol, centerRow, radius);

            //if our 'boolean' is 'true'...
            if (boo) {
                //change the specified pixel location to black
                pixels[(i * numCols + j)] = 0;
            }
        } //end column for loop (x)

    } //end row for loop (y)

    return 0; // :)
}

//---------------------------------------------------------------------------
int pgmDrawEdge( int *pixels, int numRows, int numCols, int edgeWidth, char **header )
{
    int changed=0;
	//itterate through all of the pixels
	for(int i=0;i<numRows;i++){
		for(int j=0;j<numCols;j++){
			//checks if i or j is on the edge
			if(i<edgeWidth||j<edgeWidth||i>=(numRows-edgeWidth)||j>=(numCols-edgeWidth))
				if(pixels[(i * numCols + j)]!=0){
					pixels[(i * numCols + j)]=0;//Set the pixel to black	
					changed=1;
				}
			//printf("%3d",pixels[(i * numCols + j)]);	
		}	
		//printf("\n");
	}
	return changed;
}

//---------------------------------------------------------------------------

int pgmDrawLine(int* pixels, int numRows, int numCols, char ** header,
    int p1row, int p1col, int p2row, int p2col)
    //  y1         x1         y2         x2
{

    // Find equation of line from 2 points given
    float slope;
    float b;
    int tempMaxX, tempMaxY;
    int tempMinX, tempMinY;
    float range;
    slope = ((float)(p2row - p1row)) / ((float)(p2col - p1col));
    b = p1row - slope * p1col;

    range = slope / 2;
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
    
   

    if ((p2col - p1col) == 0) { // This is for vertical line

        for (int i = tempMinY; i <= tempMaxY; i++) {////// for(int i = p1row; i < p2row; i++)
            pixels[i * numCols + p1col] = 0;
        }
    }
    else if (p2row - p1row == 0) { // This is for horizontal line
        for (int i = tempMinX; i <= tempMaxX; i++) {
            pixels[i + (numCols * p1row)] = 0;
        }
    }
    else {        
        for (int i = tempMinX; i <= tempMaxX; i++) { // i/numRows
            float xVal = (slope * i + b);
            for (int j = tempMinY; j <= tempMaxY; j++) {
                float yVal = (float)j;                
                if (yVal < xVal + range && yVal > xVal - range) { // Change this so it's less exact and more of a range
                    pixels[(numCols * j) + (i)] = 0;
                }
            }
        }
    }

    return 0;
}

//-------------------------------------------------------------------------------
double distance( int p1[], int p2[] )
{
    return sqrt( pow( p1[0] - p2[0], 2 ) + pow( p1[1] - p2[1], 2 ) );
}

//returns either 0 or 1
//0 = outside of radius; pixel will not be changed
//1 = within radius bounds; pixel will be changed to black
int calcDist(int x, int y, int centCol, int centRow, int radius) {
    int p1[2] = {x, y}; //array to hold our x and y values for given point
    int p2[2] = {centCol, centRow}; //given centerpoint will never be changed
    
    double rad = (double) radius; //variable to hold a double version or radius
    //for comparisons

    //use distance function to find the distance
    double dis = distance(p1,p2);

    if (dis <= rad) { //if distance is within radius of center point...
        return 1; //return 'true'
    }

    //else if, distance is outside of radius bounds...
    return 0; //return false
    
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

