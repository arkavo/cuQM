#include "cuQMstd.cuh"
#include <iostream>

int main()
{
    SPACE sample1;
    sample1.SIZE_X = 10;
    sample1.SIZE_Y = 10;
    sample1.SIZE_Z = 10;
    
    sample1.initialize();
    
    std::cout<<sample1.ADDRESS<<'\n'
    <<sample1.V<<'\n'
    <<sample1.Y<<'\n'
    <<sample1.dY<<'\n'
    <<sample1.ddY<<'\n';   
    
    return 0;
}