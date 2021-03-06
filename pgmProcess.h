#ifndef pgmProcess_h
#define pgmProcess_h

/**
 *  Function Name:
 *      distance()
 *      distance() returns the Euclidean distance between two pixels. This function is executed on CUDA device
 *
 *  @param[in]  p1  coordinates of pixel one, p1[0] is for row number, p1[1] is for column number
 *  @param[in]  p2  coordinates of pixel two, p2[0] is for row number, p2[1] is for column number
 *  @return         return distance between p1 and p2
 */
__device__ float distanceSquared( int p1[], int p2[] );

__global__ void calcDist(int *pixels, int numRows, int numCols, int centCol, int centRow, int radius);

__global__ void edgeKernel( int *a, int dimx, int dimy, int w );

__global__ void gpuLineDraw(int* array4GPU, int numRows, int numCols, int p1row, int p1col, int p2row, int p2col, float slope, float b, int tempMaxX, int tempMaxY, int tempMinX, int tempMinY, float range);

#endif
