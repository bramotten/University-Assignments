SELECT a.aname, SUM(m.profit) FROM Actor a
	JOIN Starring s ON s.a_id = a.a_id
	JOIN Movie m ON m.m_id = s.m_id
	GROUP BY a.a_id;