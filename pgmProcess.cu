
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
// __device__ float distanceSquared( int p1[], int p2[] )
// {
//     p1[1] = (float) p1[1];
//     p1[0] = (float) p1[0];
//     p2[1] = (float) p2[1];
//     p2[0] = (float) p2[0];
//     return (p1[0] - p2[0])*(p1[0] - p2[0]) + (p1[1] - p2[1])*( p1[1] - p2[1]);
// }