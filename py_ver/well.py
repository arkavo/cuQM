import numpy as np
import matplotlib.pyplot as plt
L = 500
dx = 0.2
step = -0.2
Vx = np.zeros(L)
Vx[0] = 100
Vx[-1]= 100
#plt.plot(Vx)

"""
H = p**2/2m + 0
Hy = Ey
=> -a y'' = Ey
=> ay'' + Ey = 0
"""
Y = np.ones_like(Vx,dtype=float)
E = -6
dY = np.zeros_like(Vx,dtype=float)
ddY = np.zeros_like(Vx,dtype=float)

Tol = 10000
Max = 10

tmp_Y = np.zeros_like(Vx,dtype=float)
for i in range(L):
    tmp_Y[i] = Y[i]
#print(Vx)
while(Tol>0):
    Tol -= 1
    #for i in range(L):
    #    Y[i] = tmp_Y[i]
    for i in range(L):
        if i>0 and i<L-1:
            ddY[i] = (Vx[i] - E - (Y[i+1]-Y[i-1])/2.)*step
        else:
            ddY[i] = (Vx[i] - E)*step
    for i in range(L):
        if i>0 and i<L-1:
            dY[i] += (ddY[i-1]+ddY[i+1])*dx/2
        else:
            dY[i] += ddY[i]*dx
    for i in range(L):
        Y[i] += dY[i]*dx
        #if dY[i]*dx < Tol:
        #    break
    print(str(Tol)+"/10000",end='\r')
    #for i in range(L):
    #    if(Max < np.abs(Y[i]-tmp_Y[i])):
    #        Max = np.abs(Y[i]-tmp_Y[i])
    #        print(Max)
sum = 0
prob = []
for i in range(L):
    sum += Y[i]**2
    prob.append(Y[i]**2)
sum = sum**(0.5)
Y = Y/(sum)
print("A = "+str(float(sum)),end='\n')
plt.plot(Y)
prob = np.array(prob)
plt.plot(prob/float(sum**2))
#plt.plot(ddY)
plt.savefig('well.jpg')