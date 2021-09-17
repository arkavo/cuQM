import subprocess as sp
sp.call(['nvcc','test.cu','-o','test'])
sp.call(['./test.exe','100','4'])
sp.call(['py','analyze.py'])