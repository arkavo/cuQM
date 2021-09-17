#include <stdio.h>
#include <iostream>
#include <cmath>
#include <time.h>
#include <chrono>
#include <string>
#include <limits.h>
#include <fstream>

using namespace std;

struct vector3
{
    float x;
    float y;
    float z;
};

class particle
{
    public:
        float mass;
        float charge;
        vector3 position;
        vector3 velocity;
};

void set_energy(double* dest,int L,double E)
{
    for(int i=0;i<L;i++)
    {
        *(dest+i) = E;
    }
}
void display(double* dest,int L)
{
    for(int i=0;i<L;i++)
    {
        std::cout<<*(dest+i)<<"\n";
    }
}

__global__ void ASSIGN(double* dest, double val)
{
    int idx = threadIdx.x + blockIdx.x*blockDim.x;
    *(dest + idx) = val;
}

__global__ void DERIVATIVE_STEP(double* y, double* ddy, double* V, double* E,double step, int L)
{
    int idx = threadIdx.x + blockIdx.x*blockDim.x;
    if((idx>0) && (idx<(L-1)))
    {
        *(ddy+idx) = (*(y+1+idx)-*(y-1+idx))/(2* (-1/step)) + *(V+idx) - (*E);
    }
    else
    {
        *(ddy+idx) = (*(V+idx) - *E) * (step);
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
    *(Y+idx) = *(dY+idx) * step;
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

int main(int argc,char* argv[])
{
    std::ofstream file;
    file.open("data.csv");
    
    int L = stoi(argv[1]);    
    int threads = stoi(argv[2]);
    int blocks = int(L/threads);
    //int threads = 5;
    std::cout<<"Length: "<<L<<"\n";
    
    unsigned long long SIZE_0 = ((int)sizeof(double)*L);
    double* V_HST;
    double* V_DEV;
    double Ev = -1.5;
    double* E;
    double step = -0.05;
    double* Y_DEV;
    double* dY_DEV;
    double* ddY_DEV;
    double* Y_Final;
    //setup
    int loops = 80000;
    V_HST = (double*)malloc(SIZE_0);
    Y_Final = (double*)malloc(SIZE_0);
    
    cudaMalloc((void**)&V_DEV,SIZE_0);
    cudaMalloc((void**)&Y_DEV,SIZE_0);
    cudaMalloc((void**)&dY_DEV,SIZE_0);
    cudaMalloc((void**)&ddY_DEV,SIZE_0);
    cudaMalloc((void**)&E,sizeof(double));
    
    set_energy(V_HST,L,-3.0);
    *V_HST = 0;
    *(V_HST+L-1) = 0;
    cudaMemcpy(V_DEV,V_HST,SIZE_0,cudaMemcpyHostToDevice);
    cudaMemcpy(E,&Ev,int(sizeof(double)),cudaMemcpyHostToDevice);
    
    ASSIGN <<<blocks,threads>>> (V_DEV, 0.); 
    ASSIGN <<<blocks,threads>>> (Y_DEV, 0.);
    ASSIGN <<<blocks,threads>>> (dY_DEV, 0.);
    ASSIGN <<<blocks,threads>>> (ddY_DEV, 0.);
    
    while(loops>0)
    {
        loops-=1;
        //std::cout<<loops<<"\n";
        DERIVATIVE_STEP <<<blocks,threads>>> (Y_DEV,ddY_DEV,V_DEV,E,step,L);
        UPDATE_STEP <<<blocks,threads>>> (Y_DEV,dY_DEV,ddY_DEV,step,L);
        FINAL_STEP <<<blocks,threads>>> (Y_DEV,dY_DEV,step,L);
    }
    cudaMemcpy(Y_Final,Y_DEV,SIZE_0,cudaMemcpyDeviceToHost);
    std::cout<<"\n";
    display(Y_Final,L);
    for(int i=0;i<L;i++)
    {
        file<<Y_Final[i]<<"\n";
    }
    cudaFree(V_DEV);
    cudaFree(Y_DEV);
    cudaFree(dY_DEV);
    cudaFree(ddY_DEV);
    
    return 0;
}