private String longestIsogram(ArrayList<String> allWords) {

	HashMap<String, Integer> isograms = new HashMap<String, Integer>();
	int nWords = allWords.size();

	for (int i = 0; i < nWords; i++) {

		String curWord = allWords.get(i);
		boolean isogram = true;
		int curLength = curWord.length();
		ArrayList<Character> allChars = new ArrayList<Character>();

		for (int j = 0; j < curLength; j++) {
			char curChar = curWord.indexOf(j);

			if (allChars.contains(curChar)) {
				isogram = false;
			} else {
				allChars.put(curChar);
			}
		}

		if (isogram) {
			isograms.put(curWord, curLength);
		}
	}


}
