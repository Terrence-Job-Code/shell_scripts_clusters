import os
import re
# this program splits up my files in datalist
direc = "/global/homes/t/tedmonds/Analysis/femtoDst/datalist/"

energy = "39.0"
energy = "62.4"
energy = "200.0"

outdir = "/global/homes/t/tedmonds/Analysis/femtoDst/datalist/" + energy + "GeV_Run10/"
fname = "longish.list"
#sname = "200.0_14low.List"

theFile = direc+fname
print(theFile)

fread = open(theFile,'r')

fread.seek(-1,2)
eof = fread.tell()
fread.seek(0,0)
i = 0
while fread.tell() <= eof:
	i+=1
	fread.readline()

print(i)

numLines=i/2

fread.seek(0,0)

ogFiles = os.listdir(direc)
numFiles = len(ogFiles)
print(numFiles)

#scDir = "/star/scratch/tedmonds/f0Analysis/Run14/datalist/200.0GeV_Run14/"
scDir = "/star/u/tedmonds/Analysis/femtoDst/datalist/"

fread.seek(0,0)
i=0
j=0
while fread.tell()<eof:
	enName = "39.0."
	enName = "62.4."
	if j==50: 
		i+=1
		j=0
	if i<10: newFile = "list.000%d" % (i)
	if i>=10 and i<100 : newFile = "list.00%d" % (i)
	if i>=100 and i<1000 : newFile = "list.0%d" % (i)
	if i>=1000 : newFile = "list.%d" % (i)

	writeName = outdir+enName+newFile
	
	if j==0 or j%50==0: 
		writeFile = open(writeName,'w')
	#for count in range(0,1000):
	enerStr = "39GeV"
	enerStr = "62GeV"
	#print(j)
	nextLine = fread.readline()
	if re.search(enerStr,nextLine):
		writeFile.write(nextLine)
		j+=1
		#print(j)
	#if fread.tell()==eof:
	#	break

	#i += 1

