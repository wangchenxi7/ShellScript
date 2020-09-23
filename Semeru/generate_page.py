#! /usr/bin/python3
#
# Generate input data for flink pagerank
# Read the results of wordcount from link data and generate the corresponding page files
#	e.g. 
# 1 1
#	2 2	
# 3 1
#
# Generate file page.txt
# 1
# 2
# 3

import sys

if __name__ == '__main__':
	output = open("pages.txt", "x")
	lines = open(sys.argv[1]).readlines()
	for line in lines:
		splitted = line.split()
		
		if len(splitted) != 2:
			continue

		output.write(splitted[0]+"\n")
				

	output.close()
