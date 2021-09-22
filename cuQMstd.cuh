#include <cmath>
#include <fstream>
#include <iostream>
#include "cuda.h"

struct vector3
{
    float x,y,z;
};



__global__ void ASSIGN(double* ADDRESS,double *DATA)
{
    int idx = threadIdx.x + blockDim.x * blockIdx.x;
    *(ADDRESS + idx) = *(DATA + idx);
}

class SPACE
{
    public:
        double* ADDRESS;
        double* V;
        double* Y;
        double* dY;
        double* ddY;

        int SIZE_X;
        int SIZE_Y;
        int SIZE_Z;

    void initialize()
    {
        unsigned long long SIZE0 = int(SIZE_X*SIZE_Y*SIZE_Z*sizeof(double));
        
        cudaMalloc((void**)&ADDRESS,SIZE0);
        cudaMalloc((void**)&V,SIZE0);
        cudaMalloc((void**)&Y,SIZE0);
        cudaMalloc((void**)&dY,SIZE0);
        cudaMalloc((void**)&ddY,SIZE0);
    }
    
    void assign(double* DATA)
    {
        ASSIGN <<<4,int(SIZE_X/4)>>> (ADDRESS,DATA);
    }
        
};