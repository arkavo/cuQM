#include <cmath>
#include <fstream>
#include <iostream>
//#include "cuda.h"

struct vector3
{
    float x,y,z;
};

__global__ void DERIVATIVE_STEP(double* Y, double* ddY, double* V, double E, int L)
{
    int idx = threadIdx.x + blockIdx.x*blockDim.x;
    if(idx<L)
    {
        if((idx==0)||(idx==L-1))
        {
            *(ddY+idx) = (*(V+idx) - E) ;
        }
        else
        {
            *(ddY+idx) = ((*(V+idx) - (E)) * *(Y+idx));
        }
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
        double step;
        int SIZE_X;
        int SIZE_Y;
        int SIZE_Z;

    unsigned long long SIZE0;
    
    void initialize(int x,int y,int z)
    {
        SIZE_X = x;
        SIZE_Y = y;
        SIZE_Z = z;
        
        SIZE0 = int(SIZE_X*SIZE_Y*SIZE_Z*sizeof(double));
        step = 1. / SIZE_X;
        cudaMalloc((void**)&ADDRESS,SIZE0);
        cudaMalloc((void**)&V,SIZE0);
        cudaMalloc((void**)&Y,SIZE0);
        cudaMalloc((void**)&dY,SIZE0);
        cudaMalloc((void**)&ddY,SIZE0);
        host_debug = (double*)malloc(SIZE0);
        std::cout<<"Initialized\n";
    }
    
    void assign(double* DATA,double* POTENTIAL)
    {
        cudaMemcpy(Y,DATA,SIZE0,cudaMemcpyHostToDevice);
        cudaMemcpy(V,POTENTIAL,SIZE0,cudaMemcpyHostToDevice);
        std::cout<<"Assigned\n";
    }

    void display()
    {
        cudaMemcpy(host_debug,ddY,SIZE0,cudaMemcpyDeviceToHost);
        
        for(int k=0;k<SIZE_Z;k++)
        {
            for(int j=0;j<SIZE_Y;j++)
            {
                for(int i=0;i<SIZE_X;i++)
                {
                    std::cout<<*(host_debug + i + j*SIZE_X + k*SIZE_X*SIZE_Y)<<' ';
                }
                //std::cout<<'\n';
            }
            /*for(int i=0;i<SIZE_X;i++)
            {
                std::cout<<"_";
            }*/
            std::cout<<"\n";
        }
    }
    
    void calx(int threads,double E)
    {
        int blocks = int(SIZE_X/threads); 
        for(int i=0;i<100;i++)
        {
            //std::cout<<step;
            DERIVATIVE_STEP <<<blocks,threads>>> (Y,ddY,V,E,SIZE_X);
            UPDATE_STEP <<<blocks,threads>>> (Y,dY,ddY,step,SIZE_X);
            FINAL_STEP <<<blocks,threads>>> (Y,dY,step,SIZE_X);
        }
    }
};