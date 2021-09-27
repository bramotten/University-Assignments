SELECT DISTINCT a.aname FROM Actor as a
	JOIN Oscar AS o ON a.a_id = o.a_id
	WHERE a.genre == o.genre;