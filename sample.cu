#include "cuQMstd.cuh"
#include <iostream>
#include <stdio.h>
#include <time.h>
#include <chrono>
#include <string>
#include <fstream>
//#include "cuda.h"

int main(int argc, char* argv[])
{
    std::ofstream file;
    file.open("data.csv");
    SPACE sample1;
    int threads = 4;
    int x = 1000;
    int y = 1;
    int z = 1;
    
    if(argc==5)
    {
        x = std::stoi(argv[1]);
        y = std::stoi(argv[2]);
        z = std::stoi(argv[3]);
        threads = std::stoi(argv[4]);
    }
    
    sample1.initialize(x,y,z);
    
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
                *(space_arr + i + j*sample1.SIZE_X + k*sample1.SIZE_X*sample1.SIZE_Y) = 200.0; //double(i+j+k -i*j*k);
                *(sampleARR + i + j*sample1.SIZE_X + k*sample1.SIZE_X*sample1.SIZE_Y)= 100.0;
            }
        }
    }
    
    auto hst_st = std::chrono::high_resolution_clock::now();
    
    sample1.assign(sampleARR,space_arr);
    
    //sample1.display();

    sample1.calx(threads,10.5);
    
    auto hst_en = std::chrono::high_resolution_clock::now();
    
    sample1.display();
    
    cudaMemcpy(sampleARR,sample1.Y,sample1.SIZE_X*sample1.SIZE_Y*sample1.SIZE_Z*sizeof(double),cudaMemcpyDeviceToHost);
    
    std::chrono::duration<float> duration = hst_en-hst_st;
    std::cout<<"\nDuration: "<<duration.count()<<"\n";

    std::cout<<"Sizes X Y Z "<<sample1.SIZE_X<<sample1.SIZE_Y<<sample1.SIZE_Z<<'\n';
    
    //insanely fast, print is the bootle neck
    
    std::cout<<*(sampleARR+sample1.SIZE_X*sample1.SIZE_Y*sample1.SIZE_Z -1)<<'\n';
    std::cout<<'\n';
    
    for(int i=0;i<sample1.SIZE_X*sample1.SIZE_Y*sample1.SIZE_Z;i++)
    {
        file<<*(sampleARR+i)<<'\n';
    }
    sample1.memclear();

    return 0;
}