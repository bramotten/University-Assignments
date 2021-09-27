"""
I'm going to go with amount of names in top 1000 to measure popularity,
because I have no idea how much more often #1 occurs than # 999.

I also have no idea how to test if this is right. The amount of
occurences in the best decade is a reasonable number though.
"""

namesFile = open('dutch-names.txt', 'r', encoding="cp1252")
lines = namesFile.readlines()
namesFile.close()

print("\nNames with this first letter ::: were most popular in this decade")

for letter in range (26):
	bestDecade = [-1] * 11 # to spot errors
	nameCount = [0] * 11 # to allow counting

	# get all lines starting with the letter. 65 is the ASCII for 'A'
	for line in lines:
		if (line[0] == chr(65 + letter)): # names start with a capital
			splitLine = line.split(" ")

			# count occs in top 1000 per line
			for decade in range(11):
				if (int(splitLine[decade + 1]) != 0):
					nameCount[decade] += 1

	# get decade with highest amount of names
	for decade in range(len(nameCount)):
		if (nameCount[decade] == max(nameCount)):
			bestDecade = decade

	print("'%s' ::: %d's"
		% (chr(letter + 65), 1900 + 10 * bestDecade))
