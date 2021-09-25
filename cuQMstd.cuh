#include <cmath>
#include <fstream>
#include <iostream>
//#include "cuda.h"

struct vector3
{
    float x,y,z;
};


/*
__global__ void ASSIGN(double* ADDRESS,double *DATA)
{
    int idx = threadIdx.x + blockDim.x * blockIdx.x;
    *(ADDRESS + idx) = *(DATA + idx);
}
*/
__global__ void DERIVATIVE_STEP(double* y, double* ddy, double* V, double* E, int L)
{
    int idx = threadIdx.x + blockIdx.x*blockDim.x;
    if((idx>0) && (idx<(L-1)))
    {
        *(ddy+idx) = ((*(V+idx) - (*E)) * *(y+idx));
    }
    else
    {
        *(ddy+idx) = (*(V+idx) - *E) ;
    }
}

__global__ void UPDATE_STEP(double* Y,double* dY, double* ddY,double step,int L)
{
    int idx = threadIdx.x + blockIdx.x*blockDim.x;
    if((idx>0)&&(idx<(L-1)))
    {
        *(dY+idx) += (*(ddY+idx+1)+*(ddY+idx-1))*step/2.;
    }
    else
    {
        *(dY+idx) += *(ddY+idx) * step;
    }
}
__global__ void FINAL_STEP(double* Y,double* dY,double step,int L)
{
    int idx = threadIdx.x + blockIdx.x*blockDim.x;
    *(Y+idx) += *(dY+idx) * step;
}

__global__ void NORMALIZE_CONSTANT(double* Y,double* res)
{
    int idx = threadIdx.x + blockIdx.x*blockDim.x;
    *res += pow(*(Y+idx),2);
}

__global__ void NORMALIZE_FUNCTION(double* Y, double* res)
{
    int idx = threadIdx.x + blockIdx.x*blockDim.x;
    *(Y+idx) = *(Y+idx) / *res; 
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

    unsigned long long SIZE0;
    
    void initialize(int X,int Y,int Z)
    {
        SIZE_X = X;
        SIZE_Y = Y;
        SIZE_Z = Z;
        
        SIZE0 = int(SIZE_X*SIZE_Y*SIZE_Z*sizeof(double));
        cudaMalloc((void**)&ADDRESS,SIZE0);
        cudaMalloc((void**)&V,SIZE0);
        cudaMalloc((void**)&Y,SIZE0);
        cudaMalloc((void**)&dY,SIZE0);
        cudaMalloc((void**)&ddY,SIZE0);
        host_debug = (double*)malloc(SIZE0);
        std::cout<<"Initialized\n";
    }
    
    void assign(double* DATA)
    {
        cudaMemcpy(ADDRESS,DATA,SIZE0,cudaMemcpyHostToDevice);
        std::cout<<"Assigned\n";
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
                    std::cout<<*(host_debug + i + j*SIZE_X + k*SIZE_X*SIZE_Y)<<' ';
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
    
    void calx(int threads,double* E,double* V)
    {
        int blocks = int(SIZE_X/threads); 
        DERIVATIVE_STEP<<<blocks,threads>>>(Y,ddY,V,E,SIZE_X);
    }
};