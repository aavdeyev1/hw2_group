
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

    //use distance function to find the distance
    float disSq = distanceSquared(p1, p2);

    if ((disSq <= (float)(radius * radius )) && ix < numCols) { //if distance is within radius of center point...
        pixels[idx] = 0;
    }
    
}

__global__ void edgeKernel( int *a, int dimx, int dimy, int w )
{
	int ix   = blockIdx.x*blockDim.x + threadIdx.x;
	int iy   = blockIdx.y*blockDim.y + threadIdx.y;
	int idx = iy*dimx + ix;
	if(ix<dimx && iy<dimy)//checks if it is in bounds
		if(ix<w||iy<w||ix>=(dimx-w)||iy>=(dimy-w))//check if it is on the edge
				a[idx]  = 0;
}


__global__ void gpuLineDraw(int* array4GPU, int numRows, int numCols, int p1row, int p1col, int p2row, int p2col, float slope, float b, int tempMaxX, int tempMaxY, int tempMinX, int tempMinY, float range) {

    //calculate global X id // use this to determine if in range of the line
    int xId = threadIdx.x + blockDim.x * blockIdx.x;
    //calculate global Y id // use this to determine if in range of the line
    int yId = threadIdx.y + blockDim.y * blockIdx.y;
    //calculate global thread ID
    int globalId = xId + (yId * numCols);


    //if threads outside range of "2d" array do nothing
    if (xId < numCols && yId < numRows) {
        //if threads are within tempMinX <-> tempMaxX and tempMinY <-> tempMaxY
        if (xId <= tempMaxX && xId >= tempMinX && yId <= tempMaxY && yId >= tempMinY) {//threads within the area where the line is drawn
            float xVal = (slope * xId + b);//this displays the y value that should be filled in at this X// this is on the line
            float yVal = (float)yId;//this is the y value we are currently at may or maynot be on the line
            // if threads y value is on line change to 0
            if (yVal < xVal + range && yVal > xVal - range) {
                array4GPU[globalId] = 0;
            }
        }
    }
}