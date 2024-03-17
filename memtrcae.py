import math

file = open("trace.txt","w")
for i in range(0,pow(2,19),1):
	file.write(str(hex(i%256))+"\n")

file.close()
