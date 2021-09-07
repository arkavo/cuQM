import numpy as np
import matplotlib.pyplot as plt
L = 100
dy = 0.02
Vx = np.zeros(L)
Vx[0] = 10
Vx[-1]= 10
plt.plot(Vx)

"""
H = p**2/2m + 0
Hy = Ey
=> -a y'' = Ey
=> ay'' + Ey = 0
"""
Y = np.zeros_like(Vx)
dY = np.zeros_like(Vx)
ddY = np.zeros_like(Vx)
Tol = 0.1
Max = 1000
tmp_Y = np.zeros_like(Vx)
#print(Vx)
while(Max>0):
    #Max = np.abs(Y[0] - tmp_Y[0])
    Max -= 1
    print(Max,end='\n')
    Y = tmp_Y
    for i in range(1,L-1):
        ddY[i] = (Vx[i+1]-Vx[i-1]) / 2 +(Y[i+1]-Y[i-1]) / 2
    for i in range(L):
        dY[i] += ddY[i]*dy
    for i in range(L):
        tmp_Y[i] += dY[i]*dy
    #print(tmp_Y)
    for i in range(L):
        if(Max < np.abs(Y[i]-tmp_Y[i])):
            Max = np.abs(Y[i]-tmp_Y[i])
plt.plot(Y)
#plt.plot(ddY)
plt.savefig('py_ver/well.jpg')
