SELECT year
FROM Oscar
GROUP BY year
ORDER BY COUNT(*) DESC
LIMIT 1;