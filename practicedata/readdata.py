import csv
import numpy as np

##datetime = dataset.createVariable('time', np.float64, ('time',))

#open csv air pollution file

with open('AirQualityDataHourly.csv', 'r') as reader:   
    header = reader.readline()

    #create empty arrays for variables that will be read in 
    date = [] 
    time = []
    #for each line read in the string before the first comma and append this 
    #to date array
    for line in reader.readlines(): 
        d = line.strip().split(",")[0]
        d = str(d)
        date.append(d)
    #for each line read in the string before the second comma and append
    #this to time array 
        t = line.strip().split(",")[1]
        t = str(t)
        time.append(t)
print date
print time
    
    

#PMdata.datetime = []
#PMdata.conchourly = []
#PMdata.stationstatus = []
#PMdata.location = []


#from datetime import datetime
#a = '2016-01-01 00:00:00'

#                Hyphens here  v  v       
#d = datetime.strptime(a,'%Y-%m-%d %H:%M:%S')
#d = PMdata.datetime[]
#print d       
    
