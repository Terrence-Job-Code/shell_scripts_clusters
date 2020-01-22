import os
import re

# This program is to fix my path names for PDSF but keeping them in the same file

# WARNING, this code should only be run once, or it will destroy the paths

direc = '/global/homes/t/tedmonds/Analysis/femtoDst/datalist/'

energy = '39.0'
#energy = '62.4'
#energy = '200.0'

Run = 'Run10'
#Run = 'Run11'

pathDir = direc + energy + 'GeV_' + Run + '/'

fileList = os.listdir(pathDir)

for i in range (0,fileList.__len__()):

	f_name = pathDir + fileList[i]
	root_file_path_old = []
	with open(f_name,'r') as f_read:
		for line in f_read:
			root_file_path_old.append(line)

	root_file_path = []
	#print(root_file_path_old[0][0:19] + root_file_path_old[0][38:])
	with open(f_name,'w+') as f_write:
		for j in range (0,root_file_path_old.__len__()):

			root_file_path.append( root_file_path_old[j][0:19] + root_file_path_old[j][38:] )
			
			f_write.write(root_file_path[j])


#print(fileList[0])
#print(fileList.__len__())

