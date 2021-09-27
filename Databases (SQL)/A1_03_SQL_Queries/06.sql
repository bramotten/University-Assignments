SELECT a.aname FROM Actor a
	WHERE a.a_id NOT IN (SELECT o.a_id FROM Oscar o);