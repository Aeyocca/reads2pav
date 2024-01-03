#!/bin/python
#Alan E. Yocca
#01-02-24
#comb_chr.py

#Take orthofinder output and count number of elements in each orthogroup
#also format output for CAFE5 count data format

import argparse
import sys

parser = argparse.ArgumentParser(prog='PROG')
parser.add_argument('--file_list', required=True, help='list of pav files')
parser.add_argument('--output', required=True, help='output file')
args = parser.parse_args()

#combine pav files, if the feature is present in at least a single file 
#(well... should only be a single file), then call present

#read into a dictionary?
#pandas is probably faster but then creates a dependency for the environment

out_dict = dict()

fl_clean = str(args.file_list).replace("[","").replace("]","")

fl_list = fl_clean.strip().split()

sys.exit(fl_list)

for file in file_list.split(","):
	with open(file) as fh:
		next(fh)
		for line in fh:
			la = line.strip().split("\t")
			#because I'm using readstopav nextflow pipeline, this
			#should be a two column file
			#set to present if present in any file, should all be the same sample,
			#just different chromosomes
			try:
				if out_dict[la[0]] == 1 or la[1] == "1":
					out_dict[la[0]] = 1
				else:
					out_dict[la[0]] = 0
			except KeyError:
				#initialize
				out_dict[la[0]] = la[1]

with open(args.output, 'w') as out:
	for feature in out_dict.keys():
		tmp = out.write(feature + "\t" + str(out_dict[feature]) + "\n")









