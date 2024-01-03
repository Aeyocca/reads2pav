#!/bin/python
#Alan E. Yocca
#01-03-24
#comb_samples.py

import argparse

parser = argparse.ArgumentParser(prog='PROG')
parser.add_argument('--file_list', required=True, help='list of pav files')
parser.add_argument('--output', required=True, help='output file')
args = parser.parse_args()

#key will be feature, value will be a list of presence/absence
out_dict = dict()

#reading in from nextflow channel so its a tuple read in as a string
fl_clean = str(args.file_list).replace("[","").replace("]","")
fl_list = fl_clean.strip().split(", ")
out_header = ["Feature"]

for file in fl_list:
	out_header.append(file)
	with open(file) as fh:
		for line in fh:
			la = line.strip().split("\t")
			try:
				out_dict[la[0]].append(la[1])
			except KeyError:
				#initialize
				out_dict[la[0]] = [la[1]]

with open(args.output, 'w') as out:
	for colname in out_header[:-1]:
		tmp = out.write(colname + "\t")
	tmp = out.write(out_header[-1] + "\n")
	for feature in out_dict.keys():
		tmp = out.write(feature + "\t")
		#if a single sample was provided, outputting is different
		if len(out_dict[feature]) == 1:
			tmp = out.write(out_dict[feature] + "\n")
		else:
			for column in out_dict[feature][:-1]:
				tmp = out.write(column + "\t")
			tmp = out.write(out_dict[feature][-1] + "\n")








