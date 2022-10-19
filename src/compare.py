import csv
file1 = "../data/grand-slam-point-data/2011-ausopen-matches.csv"
file2 = "../data/grand-slam-point-data/2011-frenchopen=-matches.csv"

def sort_lowercase_headers(csvfile):
	csvreader = csv.reader(csvfile, delimiter=',',quotechar='|')
	header=csvreader.next()
	header.sort()
	header = [x.lower() for x in header]
	return header

# coding: utf-8
import csv
with open(file1, 'rb') as csvfile:
	file1_headers = sort_lowercase_headers(csvfile)

with open(file2, 'rb') as csvfile:
	file2_headers = sort_lowercase_headers(csvfile)
       
print ("headers in both files:")
print ("---------------------")
print (list(set(file1_headers) & set(file2_headers)))
print ("")

print ("headers in {} but not in {}".format(file1,file2))
print ("---------------------")
print ('[%s]' % '\n '.join(map(str, list(set(file1_headers) - set(file2_headers)))))
print ("")

print ("headers in {} but not in {}".format(file2,file1))
print ("---------------------")
print ('[%s]' % '\n '.join(map(str, list(set(file2_headers) - set(file1_headers)))))