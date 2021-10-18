
#include "pgmProcess.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
/**
 *  Function Name:
 *      distance()
 *      distance() returns the Euclidean distance between two pixels. This function is executed on CUDA device
 *
 *  @param[in]  p1  coordinates of pixel one, p1[0] is for row number, p1[1] is for column number
 *  @param[in]  p2  coordinates of pixel two, p2[0] is for row number, p2[1] is for column number
 *  @return         return distance between p1 and p2
 */
__device__ float distanceSquared( int p1[], int p2[] )
{
    p1[1] = (float) p1[1];
    p1[0] = (float) p1[0];
    p2[1] = (float) p2[1];
    p2[0] = (float) p2[0];
    return (p1[0] - p2[0])*(p1[0] - p2[0]) + (p1[1] - p2[1])*( p1[1] - p2[1]);
}

//returns either 0 or 1
//0 = outside of radius; pixel will not be changed
//1 = within radius bounds; pixel will be changed to black
__global__ void calcDist(int *pixels, int numRows, int numCols, int centCol, int centRow, int radius) {
    int ix   = blockIdx.x*blockDim.x + threadIdx.x;
    int iy   = blockIdx.y*blockDim.y + threadIdx.y;
    int idx = iy*numCols + ix;
    
    int p1[2] = {ix, iy}; //array to hold our x and y values for given point
    int p2[2] = {centCol, centRow}; //given centerpoint will never be changed
    
    // float rad = (float) radius; //variable to hold a double version or radius
    //for comparisons

    //use distance function to find the distance
    float disSq = distanceSquared(p1, p2);
    // pixels[idx] = (int)ceil(disSq);
    // pixels[idx] = idx;

    if ((disSq <= (float)(rad * rad)) || ix < numCols) { //if distance is within radius of center point...
        pixels[idx] = 0;
    }
    
}