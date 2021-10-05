#include "cuQMstd.cuh"
#include <iostream>
#include <stdio.h>
#include <time.h>
#include <chrono>
#include <string>
//#include "cuda.h"

int main(int argc, char* argv[])
{
    SPACE sample1;
    int threads = 4;
    if(argc==2)
    {
        threads = std::stoi(argv[1]);
    }
    sample1.initialize(10,1,1);
    
    double* space_arr;
    double* sampleARR;
    space_arr = (double*)malloc(sample1.SIZE_X*sample1.SIZE_Y*sample1.SIZE_Z*sizeof(double));
    sampleARR = (double*)malloc(sample1.SIZE_X*sample1.SIZE_Y*sample1.SIZE_Z*sizeof(double));
    for(int i=0;i<sample1.SIZE_X;i++)
    {
        for(int j=0;j<sample1.SIZE_Y;j++)
        {
            for(int k=0;k<sample1.SIZE_Z;k++)
            {
                *(space_arr + i + j*sample1.SIZE_X + k*sample1.SIZE_X*sample1.SIZE_Y) = 1.0; //double(i+j+k -i*j*k);
                *(sampleARR + i + j*sample1.SIZE_X + k*sample1.SIZE_X*sample1.SIZE_Y)= 2.0;
                //std::cout<<space_arr[i][j][k]<<'\n';
            }
        }
    }
    /*
    for(int i=0;i<sample1.SIZE_X;i++)
    {
        for(int j=0;j<sample1.SIZE_Y;j++)
        {
            for(int k=0;k<sample1.SIZE_Z;k++)
            {
                std::cout<<*(space_arr + i + j*sample1.SIZE_X + k*sample1.SIZE_X*sample1.SIZE_Y)<<"\n";
            }
        }
    }
    std::cout<<'\n';
    */
    /*std::cout<<sample1.ADDRESS<<'\n'
    <<sample1.V<<'\n'
    <<sample1.Y<<'\n'
    <<sample1.dY<<'\n'
    <<sample1.ddY<<'\n';   
    */
    auto hst_st = std::chrono::high_resolution_clock::now();
    
    sample1.assign(sampleARR,space_arr);
    
    //cudaMemcpy(sample1.ADDRESS,space_arr,sample1.SIZE_X*sample1.SIZE_Y*sample1.SIZE_Z*sizeof(double),cudaMemcpyHostToDevice);
    
    sample1.display();
    
    //cudaMemcpy(sampleARR,sample1.ADDRESS,sample1.SIZE_X*sample1.SIZE_Y*sample1.SIZE_Z*sizeof(double),cudaMemcpyDeviceToHost);
    sample1.calx(threads,5.,space_arr);
    
    auto hst_en = std::chrono::high_resolution_clock::now();
    
    sample1.display();
    
    std::chrono::duration<float> duration = hst_en-hst_st;
    std::cout<<"\nDuration: "<<duration.count()<<"\n";

    std::cout<<"Sizes X Y Z "<<sample1.SIZE_X<<sample1.SIZE_Y<<sample1.SIZE_Z<<'\n';
    /*
    for(int i=0;i<sample1.SIZE_X;i++)
    {
        for(int j=0;j<sample1.SIZE_Y;j++)
        {
            for(int k=0;k<sample1.SIZE_Z;k++)
            {
                std::cout<<*(sampleARR + i + j*sample1.SIZE_X + k*sample1.SIZE_X*sample1.SIZE_Y);
            }
        }
    }
    */
    //insanely fast, print is the bootle neck
    std::cout<<*(sampleARR+sample1.SIZE_X*sample1.SIZE_Y*sample1.SIZE_Z -1)<<'\n';
    std::cout<<'\n';
    return 0;
}