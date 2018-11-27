--103
SELECT	Movie_Title, Movie_Year, Movie_Genre
FROM	MOVIE

--104
SELECT	Movie_Year, Movie_Title, Movie_Cost
FROM	MOVIE
ORDER BY	Movie_Year DESC

--105
SELECT	Movie_Title, Movie_Year, Movie_Genre
FROM	MOVIE
ORDER BY	Movie_Genre, Movie_Year DESC

--106
SELECT	Movie_Num, Movie_Title, Price_Code
From	Movie
WHERE	Movie_Title LIKE 'R%'

--107
SELECT	Movie_Title, Movie_Year, Movie_Cost
From	Movie
WHERE	Movie_Title LIKE '%HOPE%'

--108
SELECT	Movie_Title, Movie_Year, Movie_Genre
FROM	MOVIE
WHERE	Movie_Genre = 'ACTION'

--109
SELECT	Movie_Num, Movie_Title, Movie_Cost
FROM	MOVIE
WHERE	Movie_Cost > 40

--110
SELECT	Movie_Num, Movie_Title, Movie_Cost, Movie_Genre
FROM	MOVIE
WHERE	Movie_Cost < 50 AND
		Movie_Genre in ('ACTION','COMEDY')
ORDER BY	Movie_Genre

--111
SELECT	Mem_Num, Mem_FName, Mem_LName, Mem_Street, Mem_State, Mem_Balance
FROM	MEMBERSHIP
WHERE	Mem_State = 'TN' AND
		Mem_Balance < 5 AND
		Mem_Street LIKE '%Avenue'

--112
Select	Movie_Genre, COUNT(Movie_Genre) AS 'Number of Movies'
FROM	MOVIE
GROUP BY	Movie_Genre

--113
Select	AVG(Movie_Cost) AS 'Average Movie Cost'
FROM	MOVIE

--114
SELECT	Movie_Genre, AVG(Movie_Cost) AS 'Average Cost'
FROM	MOVIE
GROUP BY	Movie_Genre

--115
SELECT	M.Movie_Title, M.Movie_Genre, P.Price_Description, P.Price_RentFee
FROM	MOVIE M INNER JOIN PRICE P ON M.Price_Code = P.Price_Code

--116
SELECT	M.Movie_Genre, AVG(P.Price_RentFee) AS 'Average Rental Fee'
FROM	MOVIE M INNER JOIN PRICE P ON M.Price_Code = P.Price_Code
GROUP BY	M.Movie_Genre

--117
SELECT	M.Movie_Title, (M.Movie_Cost/P.Price_RentFee) AS 'Breakeven Rentals'
FROM	MOVIE M INNER JOIN PRICE P ON M.Price_Code = P.Price_Code


--118
SELECT	Movie_Title, Movie_Year
FROM	MOVIE
WHERE	Price_Code IS NOT NULL

--119
SELECT	Movie_Title, Movie_Genre, Movie_Cost
FROM	MOVIE
WHERE	Movie_Cost < 49.99 AND
		Movie_Cost > 44.99

--120
SELECT	M.Movie_Title, P.Price_Description, P.Price_RentFee, M.Movie_Genre
FROM	MOVIE M INNER JOIN PRICE P ON M.Price_Code = P.Price_Code
WHERE	M.Movie_Genre IN ('FAMILY','COMEDY','DRAMA')

--121
SELECT	DISTINCT M.Mem_Num, M.Mem_FName, M.Mem_LName, M.Mem_Balance
FROM	MEMBERSHIP M INNER JOIN RENTAL R ON M.Mem_Num = R.Mem_Num

--122
SELECT	MIN(M.Mem_Balance) AS 'Minimum Balance', MAX(M.Mem_Balance) AS 'Maximum Balance',
		AVG(M.Mem_Balance) AS 'Average Balance'
FROM	MEMBERSHIP M INNER JOIN RENTAL R ON M.Mem_Num = R.Mem_Num

--123
SELECT	R.Rent_Num, R.Rent_Date, V.Vid_Num, M.Movie_Title, D.Detail_DueDate, D.Detail_ReturnDate
FROM	RENTAL R INNER JOIN DETAILRENTAL D ON R.Rent_Num = D.Rent_Num
		INNER JOIN VIDEO V ON D.Vid_Num = V.Vid_Num
		INNER JOIN MOVIE M ON V.Movie_Num = M.Movie_Num
WHERE	D.Detail_ReturnDate >= D.Detail_DueDate
ORDER BY	R.Rent_Num, M.Movie_Title


--124
SELECT	R.Rent_Num, R.Rent_Date, M.Movie_Title, D.Detail_Fee
FROM	RENTAL R INNER JOIN DETAILRENTAL D ON R.Rent_Num = D.Rent_Num
		INNER JOIN VIDEO V ON D.Vid_Num = V.Vid_Num
		INNER JOIN MOVIE M ON V.Movie_Num = M.Movie_Num
WHERE	D.Detail_ReturnDate <= D.Detail_DueDate

--125
GO
CREATE VIEW	ViewName AS
SELECT	Movie_Genre, AVG(Movie_Cost) AS 'Average cost'
FROM	MOVIE
GROUP BY	Movie_Genre

SELECT	M.Movie_Num, M.Movie_Genre, V.[Average cost],M.Movie_Cost,[M.Movie_Cost - V.Average cost] AS '% Difference'
FROM	MOVIE M INNER JOIN ViewName V ON M.Movie_Genre = V.Movie_Genre
