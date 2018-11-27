--A10P4


SELECT	EMP_FNAME AS 'FIRST NAME', EMP_LNAME AS 'LAST NAME', SUM(DISTANCE) AS 'MILES FLOWN'
FROM	PILOT_DIM P INNER JOIN FACT F ON P.PILOT_ID = F.PILOT_ID
GROUP BY EMP_FNAME, EMP_LNAME
ORDER BY [MILES FLOWN] DESC



SELECT  MOD_CODE, SUM(REVENUE) AS 'REVENUE', DATENAME(MONTH, CHAR_DATE) AS 'MONTH'
FROM	AIRCRAFT_DIM A INNER JOIN FACT F ON A.AC_ID = F.AC_ID
		INNER JOIN DATE_DIM D ON F.DATE_ID = D.DATE_ID
GROUP BY MOD_CODE, DATENAME(MONTH, CHAR_DATE)
ORDER BY REVENUE

