SELECT s.sname, COUNT(m.m_id) movie_count FROM Studio s
	JOIN Movie m ON s.s_id = m.s_id
	GROUP BY s.s_id
	HAVING movie_count >= 2
	ORDER BY movie_count DESC;