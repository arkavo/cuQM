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

__global__ void SETUP(double* dest, double val)
{
    int idx = threadIdx.x + blockIdx.x*blockDim.x;
    *(dest+idx) = val;
}

__global__ void DERIVATIVE_1(double* y, double* ddy, double* V, double* E,double step, int L)
{
    idx = threadIdx.x + blockIdx.x*blockDim.x;
    {
        if idx>0 && idx<(L-1)
        *(dy+idx) = (*(y+1+idx)-*(y-1+idx))/(2*step);
    }
}


int main(int argc,char* argv[])
{
    int L = stoi(argv[1]);    
    std::cout<<"Length: "<<L<<"\n";
    particle test;
    test.mass = 0;
    cout<<test.mass<<endl;

    unsigned long long SIZE_0 = ((int)sizeof(double)*L);
    double* V_HST;
    double* V_DEV;
    
    
    double* Y_DEV;
    double* dY_DEV;
    double* ddY_DEV;
    double* Y_Final;
    //setup
    int loops = 100;
    V_HST = (double*)malloc(SIZE_0);
    Y_Final = (double*)malloc(SIZE_0);
    cudaMalloc((void**)&V_DEV,SIZE_0);
    cudaMalloc((void**)&Y_DEV,SIZE_0);
    cudaMalloc((void**)&dY_DEV,SIZE_0);
    cudaMalloc((void**)&ddY_DEV,SIZE_0);
    
    set_energy(V_HST,L,2.2);
    cudaMemcpy(V_DEV,V_HST,SIZE_0,cudaMemcpyHostToDevice);
    SETUP <<<4,4>>> (Y_DEV,0);
    SETUP <<<4,4>>> (Y_DEV,0);
    SETUP <<<4,4>>> (Y_DEV,0);
    SETUP <<<4,4>>> (Y_DEV,0);
    
    while(loops>0)
    {

    }

    display(V_HST,L);
    return 0;
}