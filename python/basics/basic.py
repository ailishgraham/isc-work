#LISTS AND SLICES
x = 1
if x: print x, " is True"

mylist=[1, 2, 3, 4, 5]
print mylist[1]
print mylist[-2]
print mylist[:]
print mylist[1:3]

one_to_ten=range(1,11)
print one_to_ten
one_to_ten[0] = 10
print one_to_ten
one_to_ten.append(11)
print one_to_ten
one_to_ten.extend([12, 13, 14])
print one_to_ten

forward = []
backward = []
values = ["a","b","c","d"]
for item in values:
    forward.append(item)
    backward.insert(0, item)
print "forward is", forward
print "backward is", backward
r_forward = sorted(forward, reverse = True)
print r_forward
print backward
if values in r_forward == values in backward:
    print True

countries = ["uk","usa","uk","uae"]
#dir(countries)
print countries.count("uk")
countries.sort

#TUPLES

t = (1,) 
print t[-1]
numbers = range(100,201)
print numbers 

tup = tuple(numbers)
print tup[0], tup[-1]

my_list = [23, "hi", 2.4e-10]
for (i, name) in enumerate(my_list):
	print i,name

(first, middle, last) = my_list
print first, middle, last
(first, middle, last) = (middle, last, first)

#INPUT AND OUTPUT

#reading in entire contents
with open("weather.csv",'r') as reader: 
    data = reader.read()
print data

#reading file line by line
##with open("weather.csv") as reader: 
    ##line = reader.readline()
##while line:
    ##print line
    ##line = reader.readline()
    
##print "It's over"

#reading in selected data using a loop

with open("weather.csv",'r') as reader: 
    header = reader.readline()
    rain = []
    for line in reader.readlines():
        print line
        r = line.strip().split(",")[-1]
        r = float(r)
        rain.append(r) 
print rain
#writing results of rain list to myrain.txt file
with open("myrain.txt",'w') as writer:
    for r in rain:
        writer.write(str(r) + "\n")

#writing and reading binary data
import struct
bin_data = struct.pack("bbbb", 123,12,45,34)

with open("mybinary.dat","wb") as bwriter: 
    bwriter.write(bin_data)
with open("mybinary.dat","rb") as breader:
    bin_data2 = breader.read()
data = struct.unpack("bbbb", bin_data2)
print data

# strings
#looping through a string
s = 'I love to write Python'
for c in s:
    print c
print s[4]
print s[-1]
print len(s)

#splitting a string and looping
s = "I love to write python"
split_s = s.split()
print split_s
for word in split_s:
    if word.find("i") > -1:
        print "I found 'i' in: '{0}'".format(word)

#Useful aspects of strings

something = "Completely Different"
print dir(something)
something.count("t")
something.count("plete")
something.split("e")
thing2 = something.replace("Different","Silly")
print thing2


###### DO ALIASING EXERCISES ######

a = [0, 1, 2]
b = a
print a 
print b
b = "hello"
print a 
print b
a.append(3) 
print a
print b

a = "can I change"
b = a
print a 
print b
b = "maybe"
print a 
print b

import copy 

a = [0, 1, 2]
b = copy.deepcopy(a)
print a 
print b
b[0]= "hello"
print a
print b

l = [range(5), range(5)]
print l
x = l[0]
print x
x.remove(3)
print x
print l
newlist = copy.deepcopy(l)
print newlist

#FUNCTIONS

#simple double function

def double_it(number):
    return number*2

#hypotenuse triangle

def calc_hypo(a,b):
    hypo = (a**2 + b**2)**0.5
    return hypo
print calc_hypo(3, 4)

#adding checks to code

def calc_hypo(a,b):
    if type(a) not in (int, float) or type(b) not in (int, float):
        print "Bad argument"
        return False
    if a < 0 or b < 0:
        print "Bad argument"
        return False
    hypo = (a**2 + b**2)**0.5
    return hypo
print calc_hypo(3, 4)

    
#reading lines from files

##with open (filename, 'r') as reader:
    ##print reader.readline()
    ##x =reader.readlines()

#writing files

##with open(filename, "w") as writer:       writes blah blah blah to file
    ##writer.write("blah blah blah python...\n)
##with open(filename) as reader:
    ##print reader.read                     prints what we've written

#FUNCTIONS RECAP#

##def test(*arguments):
#    print len(arguments)
#    print arguments

#test()
#test(1,5)
#test(3,4,5,5,5,5,5)
#return same as input

#def func(x):
#    if type(x) == str:
#        print "you are words"
#        return 
#    else:
#        print "GREAT"
#        return x * 1000


# Sets and Dictionaries

#creating 2 sets to work with

a  = set([0, 1, 2, 3, 4, 5])
b = set ([2, 4, 6, 8])
print a.union(b)
print a.intersection(b) 

#collect up counts using a dictionary

band = ["mel","geri","victoria","mel","emma"]
counts = {}
for name in band:
    if name not in counts:
        counts[name] = 1
    else:
        counts[name] += 1
for name in counts:
    print name, counts[name]


if {}: 
    print "hi"

d = {"maggie": "uk", "ronnie": "usa"}
dir(d) 
print d.items()
print d.keys()
print d.values()
res = d.setdefault("marco", "italy")
print res, d["marco"]




