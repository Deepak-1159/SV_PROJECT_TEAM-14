import math

file = open("trace.txt","w")
for i in range(1,pow(2,19),1):
	file.write(str(hex(i%256))+"\n")

file.close()
