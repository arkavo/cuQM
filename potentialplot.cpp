/*
Purpose:
  To analyse differnt potential energy functions and find out the scaled Eigenvalues
of Energy for the said potential functions
  Form of functions:
    V(x) = k(|x|)^n
    where x is the length dimension and k is a constant n is an integer
*/
#include <iostream>
#include <fstream>
#include <math.h>

using namespace std;
const int xp = 8;           //exponent
float dx = 0.01;
float dE = 0.1;             //Energy step (data resolution)
float step_length = 0.01;   //x step, data resolution
float error = 0.01;         //Error threshold below which we will accept integer values
float e_begin = 0.0; //analysis begin and end range
float e_end = 1000.0;
float value(float E, int a) //Function for analysing a particular E
{
    float sum = 0.0;
    for (float x = 0.0; (E - pow(x, a) >= 0); x += step_length)
    {
        sum += (sqrt(2 * (E - pow(x, a)))) * dx;
    }
    if (sum - floor(sum) < error)
        return sum;
    else
        return 0.0;
}

int main() //Body code
{
    ofstream data;
    data.open("values.txt"); //direct file output
    float E = 0.0;
    for (E = e_begin; E < e_end; E += dE)
    {
        if (value(E, xp) != 0.0)
        {
            data << value(E, xp) << " " << E << "\n";
        }
    }
    data.close();
}
/*Additional notes:
Code will create output file which will contain 2 columns
1st column will be the momentum sum p.dx
2nd Column will be the Energy Eigenvalue
output file should be printed plot ready
*/