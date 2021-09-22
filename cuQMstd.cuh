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
        double* host_debug;

        int SIZE_X;
        int SIZE_Y;
        int SIZE_Z;

    unsigned long long SIZE0 = int(SIZE_X*SIZE_Y*SIZE_Z*sizeof(double));
    
    void initialize()
    {
        
        
        cudaMalloc((void**)&ADDRESS,SIZE0);
        cudaMalloc((void**)&V,SIZE0);
        cudaMalloc((void**)&Y,SIZE0);
        cudaMalloc((void**)&dY,SIZE0);
        cudaMalloc((void**)&ddY,SIZE0);
        host_debug = (double*)malloc(SIZE0);
    }
    
    void assign(double* DATA)
    {
        cudaMemcpy(ADDRESS,DATA,SIZE0,cudaMemcpyHostToDevice);
    }

    void display()
    {
        cudaMemcpy(host_debug,ADDRESS,SIZE0,cudaMemcpyDeviceToHost);
        for(int i=0;i<SIZE_X;i++)
        {
            for(int j=0;j<SIZE_Y;j++)
            {
                for(int k=0;k<SIZE_Z;k++)
                {
                    std::cout<<*(host_debug+i+j+k)<<' ';
                }
                std::cout<<'\n';
            }
            for(int i=0;i<SIZE_X;i++)
            {
                std::cout<<"_";
            }
            std::cout<<"\n";
        }
    }
        
};