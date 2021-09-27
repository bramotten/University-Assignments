SELECT m.mname FROM Movie m
	JOIN Starring s ON m.m_id = s.m_id
	JOIN Actor a ON s.a_id = a.a_id
	WHERE m.age_req <= 12 AND a.aname = 'John Fist';