#include <cmath>
#include <fstream>
#include <iostream>
#include "cuda.h"

struct vector3
{
    float x,y,z;
};



__global__ void ALLOCATE(double* ADDRESS,double *DATA)
{
    int idx = threadIdx.x + blockDim.x * blockIdx.x;
    *(ADDRESS + idx) = *(DATA + idx);
}

class SPACE
{
    public:
        double ADDRESS;
        int SIZE_X;
        int SIZE_Y;
        int SIZE_Z;
        
};