"""
Reads in the names-data.txt or dutch-names.txt file and determines
the top 10 names for each of the 11 decades. Print the results in the
terminal, in order of the ranking for each decade.

Sommige ranks ontbreken in "dutch-names.txt", dus er is geen #5 in 1990.
In names-data.txt krijgt ieder geslacht een rank, dus zijn er 2 #1's
Voorbeeld klopt ook niet, John hoort #1 te zijn in 1900.
"""

#namesFile = open('names-data.txt', 'r') # results in top 20
namesFile = open('dutch-names.txt', 'r', encoding="cp1252")
lines = namesFile.readlines()
namesFile.close()

topNames = ["" for decade in range(11)]

# check for all first places first, then seconds etc.
for rank in range(1, 11):
	for line in lines:
		splitLine = line.split(" ")
		name = splitLine[0]
		for decade in range(11):
			if (int(splitLine[decade + 1]) == rank):
				topNames[decade] += (", %s" % (name))
				# no break or anything because of the US data

# print out the top names for the decades
for decade in range(11):
	actualDecade = 1900 + 10 * decade
	print("\nThe top 10 names in the %d's were: " % actualDecade)
	print(topNames[decade][2::]) # not the ", " it begins with

print()
