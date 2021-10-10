import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import csv

df = pd.read_csv('data.csv',index_col=False)
#print(df)
r,c = df.shape
sum = 0
for i in range(r):
    sum += df.iloc[i]**2
#for value in df:
#    print(value)
print(float(sum))
sum = sum**0.5
#print(sum)
data = np.zeros(r)
#print(data)
for i in range(r):
    data[i] = df.iloc[i] / sum

plt.plot(data)
plt.savefig('plot.png')