import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

#trial dataset
A = np.linspace(0, 100*np.pi,num=180)
A = np.sin(A*A)

B = np.linspace(0, 100)
def feature(data):

    feats = {
        'zeros':0,
        'max':0,
        'min':0,
        'avg':0,
        'stdev':0,
        'discontiuities':0,
        'breaks':0
    }

    for i in range(len(data)-1):
        if data[i]*data[i+1] <=0 and np.abs(data[i]+data[i+1]):
            feats['zeros'] += 1
    
    feats['max'] = np.max(data)
    feats['min'] = np.min(data)
    feats['avg'] = np.average(data)
    feats['stdev'] = np.std(data)
    
    return feats

print(feature(B))
print(feature(np.diff(A)))
print(feature(np.diff(A,2)))