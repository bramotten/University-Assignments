SELECT year, genre, MAX(c) 
FROM (
	SELECT year, genre, COUNT(o_id) c 
	FROM Oscar
	GROUP BY genre, year
)
GROUP BY year
ORDER BY year;