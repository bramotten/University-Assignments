SELECT aname, age
FROM Actor
WHERE 
	Actor.age < 18
	OR Actor.age > 65
ORDER BY Actor.age ASC;