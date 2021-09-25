#include "cuQMstd.cuh"
#include <iostream>
//#include "cuda.h"

int main()
{
    SPACE sample1;
    
    sample1.initialize(100,1,1);
    
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
                *(space_arr + i + j*sample1.SIZE_X + k*sample1.SIZE_X*sample1.SIZE_Y) = double(i+j+k -i*j*k);
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
    //sample1.assign(space_arr);
    cudaMemcpy(sample1.ADDRESS,space_arr,sample1.SIZE_X*sample1.SIZE_Y*sample1.SIZE_Z*sizeof(double),cudaMemcpyHostToDevice);
    
    //sample1.display();
    cudaMemcpy(sampleARR,sample1.ADDRESS,sample1.SIZE_X*sample1.SIZE_Y*sample1.SIZE_Z*sizeof(double),cudaMemcpyDeviceToHost);
    
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
    std::cout<<*(sampleARR+1000000-1)<<'\n';
    std::cout<<'\n';
    return 0;
}