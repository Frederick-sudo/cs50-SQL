4.Write a SQL query to determine the number of movies with an IMDb rating of 10.0.
Your query should output a table with a single column and a single row (not counting the header) containing the number of movies with a 10.0 rating.

    SELECT COUNT(title) FROM movies WHERE id IN (SELECT movie_id FROM ratings WHERE rating = 10.0);
