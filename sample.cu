#include "cuQMstd.cuh"
#include <iostream>

int main()
{
    SPACE sample1;
    sample1.SIZE_X = 10;
    sample1.SIZE_Y = 1;
    sample1.SIZE_Z = 1;
    
    sample1.initialize();
    double* space_arr;
    space_arr = (double*)malloc(10*sizeof(double));
    for(int i=0;i<10;i++)
    {
        for(int j=0;j<10;j++)
        {
            for(int k=0;k<10;k++)
            {
                *(space_arr+i+j+k) = i+j+k -i*j*k;
                //std::cout<<space_arr[i][j][k]<<'\n';
            }
        }
    }
    
    /*std::cout<<sample1.ADDRESS<<'\n'
    <<sample1.V<<'\n'
    <<sample1.Y<<'\n'
    <<sample1.dY<<'\n'
    <<sample1.ddY<<'\n';   
    */
    sample1.assign(space_arr);
    sample1.display();
    return 0;
}