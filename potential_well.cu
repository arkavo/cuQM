#include <iostream>
#include <stdio.h>
#include <time.h>
#include <chrono>
#include <string>
#include <fstream>
#include <cmath>

double* wavefxn(int L, int n)
{
    double pi = 3.14159;
    double* V = (double*)malloc(L*sizeof(double));
    for(int i=0;i<L;i++)
    {
        *(V+i) = sin(2*pi*n*i/L);
    }
    return V;
}

void display(double* parameter,int L)
{
    for(int i=0;i<L;i++)
    {
        std::cout<<*(parameter+i)<<" ";
    }
    std::cout<<" ";
}

int main()
{
    int L = 100;
    int n = 1;
    double* res;
    res = wavefxn(L,n);
    display(res,L);
    return 0;
}