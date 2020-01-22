import os

direc = "/star/scratch/tedmonds/f0Analysis/Run14/Analysis/err/200.0GeV_Run14/"

filDirec = "/star/u/tedmonds/Analysis/f0Analysis_03/Run14/datalist/200.0GeV_Run14/"

ogFiles = os.listdir(filDirec)
numfiles = len(ogFiles)

totEvents = 0

print(numfiles)

for i in range(0,numfiles-2):
	fspec = "%i.out" % (i)
	fname = direc+fspec
	fread = open(fname,'r')

	fread.seek(-1,2)
	eof = fread.tell()
	fread.seek(0,0)

	numlines = 0
	while fread.tell() <= eof:
		numlines += 1
		fread.readline()

	fread.seek(0,0)
	
	for j in range(0,numlines-4):
		line = fread.readline()

	#print(line)
	#print(line[24:line.__len__()-1])

	totEvents += int(line[24:line.__len__()-1])

	#print("total Events = ",totEvents)


print("total Events = ", totEvents)

