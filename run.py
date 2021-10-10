import subprocess as sp

config = {
    'X' : 1000,
    'Y' : 1,
    'Z' : 1,
    'threads' : 4,
}

sp.call(['./test.exe',str(config['X']),str(config['Y']),str(config['Z']),str(config['threads'])])
sp.call(['py','analyze.py'])