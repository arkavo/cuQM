import numpy as np
import pandas as pd
a = np.linspace(0,100)
vx_data = pd.DataFrame(a)
print(a)
vx_data.reset_index(drop=True,inplace=True)
print(vx_data)

vx_data.to_csv('data.csv')