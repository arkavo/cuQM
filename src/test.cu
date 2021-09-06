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

int main()
{
    particle test;
    test.mass = 0;
    cout<<test.mass<<endl;
    return 0;
}