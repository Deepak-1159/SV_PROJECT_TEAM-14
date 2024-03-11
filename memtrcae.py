import math

file = open("trace.txt","w")
for i in range(1,pow(2,20),1):
	file.write(str(hex(i))+"\n")

file.close()
