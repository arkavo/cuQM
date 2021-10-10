#include "cuQMstd.cuh"
#include <iostream>
#include <stdio.h>
#include <time.h>
#include <chrono>
#include <string>
#include <fstream>


void build(double* Y,double* V,double step,double tol, int size)
{
    bool ct = false;
    double E = 0.02;
    while(ct==false)
    {
        *Y = 100;
        *(Y+1) = (E - *V)**Y*step*step;
        for(int i=1;i<size-1;i++)
        {
            *(Y+i+1) = (E - *(V+i))* *(Y+i)*step*step + *(Y+i-1);
        }
        std::cout<<"Final value: "<<*(Y+size-1)<<" Eigen Energy: "<<E<<'\n';
        if(abs(*Y - *(Y+size-1))< tol)
        {
            ct = true;
            std::cout<<E<<'\n';
        }
        E += *(Y+size-1)*step;
    }
}

int main()
{
    std::ofstream file;
    file.open("data.csv");
    int L = 500;
    
    double* space_arr;
    double* sampleARR;
    
    space_arr = (double*)malloc(L*sizeof(double));
    sampleARR = (double*)malloc(L*sizeof(double));
    
    for(int i=0;i<L;i++)
    {
        *(space_arr+i) = 0.;
    }

    build(sampleARR,space_arr,0.05,0.005,L);
    
    for(int i=0;i<L;i++)
    {
        file<<*(sampleARR+i)<<'\n';
    }
}