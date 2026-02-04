-- UN voting data was significantly trimmed down before uploading into SQL 
-- Removed columns that described session agenda, concerned parties etc...

-- Create table and import data --------------------------------------
DROP TABLE IF EXISTS un_ga_vote;
CREATE TABLE un_ga_vote(
                         undl_id INT,
						 ms_code VARCHAR(10),
						 ms_name VARCHAR(150),
						 ms_vote VARCHAR(5),
						 date DATE)
-- Check data --------------------------------------
SELECT * FROM un_ga_vote
LIMIT 20;

-- Exploratory Data Analysis, finding time-span for DataFrame --------------------------------------
SELECT MIN(date), --1946
       MAX(date)  --2025
FROM un_ga_vote

-- Distinct names and codes for whole time-span --------------------------------------
SELECT DISTINCT ms_name,
                ms_code
FROM un_ga_vote
ORDER BY 2

-- Distinct names and codes for post cold war --------------------------------------
SELECT DISTINCT ms_name,
                ms_code
FROM un_ga_vote
WHERE date >= '1991-12-26'
ORDER BY 2

-- CREATING A table of percentage agreement with the USA, China and Russia --------------------------------
-- time-span = 1946 to 2025
WITH t1 AS (SELECT -- Percentage Agreement with the USA
		    v.ms_code,
		    COUNT(*) AS total_votes,
		    SUM(CASE WHEN v.ms_vote = usa.ms_vote THEN 1 ELSE 0 END) AS agreements_w_usa,
		    ROUND(
		        100.0 * SUM(CASE WHEN v.ms_vote = usa.ms_vote THEN 1 ELSE 0 END) / COUNT(*),
		        2
		    ) AS pct_agreement_w_usa
		FROM un_ga_vote v
		INNER JOIN un_ga_vote usa 
		ON v.undl_id = usa.undl_id 
		    AND usa.ms_code = 'USA'
		WHERE v.ms_vote IN ('Y', 'X', 'A')  
		    AND usa.ms_vote IN ('Y', 'X', 'A')
		GROUP BY v.ms_code
), t2 AS( 
		SELECT -- Percentage Agreement with China
		    v.ms_code,
		    COUNT(*) AS total_votes,
		    SUM(CASE WHEN v.ms_vote = chn.ms_vote THEN 1 ELSE 0 END) AS agreements_w_china,
		    ROUND(
		        100.0 * SUM(CASE WHEN v.ms_vote = chn.ms_vote THEN 1 ELSE 0 END) / COUNT(*),
		        2
		    ) AS pct_agreement_w_china
		FROM un_ga_vote v
		INNER JOIN un_ga_vote chn 
		ON v.undl_id = chn.undl_id 
		    AND chn.ms_code = 'CHN'
		WHERE v.ms_vote IN ('Y', 'X', 'A')  
		    AND chn.ms_vote IN ('Y', 'X', 'A')
		GROUP BY v.ms_code
), t3 AS( 
		SELECT -- Percentage Agreement with Russia and CCCP 
		    v.ms_code,
		    COUNT(*) AS total_votes,
		    SUM(CASE WHEN v.ms_vote = rus.ms_vote THEN 1 ELSE 0 END) AS agreements_w_russia,
		    ROUND(
		        100.0 * SUM(CASE WHEN v.ms_vote = rus.ms_vote THEN 1 ELSE 0 END) / COUNT(*),
		        2
		    ) AS pct_agreement_w_russia
		FROM un_ga_vote v
		INNER JOIN un_ga_vote rus 
		ON v.undl_id = rus.undl_id 
		    AND (rus.ms_code = 'RUS'
			OR rus.ms_code = 'SUN') 
		WHERE v.ms_vote IN ('Y', 'X', 'A')  
		    AND rus.ms_vote IN ('Y', 'X', 'A')
		GROUP BY v.ms_code
),
t4 AS ( -- Country Code and Name 
    SELECT DISTINCT v.ms_name,
                    v.ms_code
    FROM un_ga_vote v
)
SELECT t1.ms_code AS country_code,
       t4.ms_name AS name,
       t1.agreements_w_usa, 
       t1.pct_agreement_w_usa,
       t2.agreements_w_china,
       t2.pct_agreement_w_china,
       t3.agreements_w_russia,
       t3.pct_agreement_w_russia
FROM t1
LEFT JOIN t2 
ON t1.ms_code = t2.ms_code
LEFT JOIN t3
ON t1.ms_code = t3.ms_code
JOIN t4
ON t1.ms_code = t4.ms_code
ORDER BY t1.ms_code;

-- CREATING A table of percentage agreement with the USA, China and Russia --------------------------------
-- time-span = post-cold war era
WITH t1 AS (SELECT -- Percentage Agreement with USA
		    v.ms_code,
		    COUNT(*) AS total_votes,
		    SUM(CASE WHEN v.ms_vote = usa.ms_vote THEN 1 ELSE 0 END) AS agreements_w_usa,
		    ROUND(
		        100.0 * SUM(CASE WHEN v.ms_vote = usa.ms_vote THEN 1 ELSE 0 END) / COUNT(*),
		        2
		    ) AS pct_agreement_w_usa
		FROM un_ga_vote v
		INNER JOIN un_ga_vote usa 
		ON v.undl_id = usa.undl_id 
		    AND usa.ms_code = 'USA'
		WHERE v.date >= '1991-12-26' 
		    AND v.ms_vote IN ('Y', 'X', 'A')  
		    AND usa.ms_vote IN ('Y', 'X', 'A')
		GROUP BY v.ms_code
), t2 AS( 
		SELECT -- Percentage Agreement with China
		    v.ms_code,
		    COUNT(*) AS total_votes,
		    SUM(CASE WHEN v.ms_vote = chn.ms_vote THEN 1 ELSE 0 END) AS agreements_w_china,
		    ROUND(
		        100.0 * SUM(CASE WHEN v.ms_vote = chn.ms_vote THEN 1 ELSE 0 END) / COUNT(*),
		        2
		    ) AS pct_agreement_w_china
		FROM un_ga_vote v
		INNER JOIN un_ga_vote chn 
		ON v.undl_id = chn.undl_id 
		    AND chn.ms_code = 'CHN'
		WHERE v.date >= '1991-12-26' 
		    AND v.ms_vote IN ('Y', 'X', 'A')  
		    AND chn.ms_vote IN ('Y', 'X', 'A')
		GROUP BY v.ms_code
), t3 AS(
		SELECT -- Percentage Agreement with Russia
		    v.ms_code,
		    COUNT(*) AS total_votes,
		    SUM(CASE WHEN v.ms_vote = rus.ms_vote THEN 1 ELSE 0 END) AS agreements_w_russia,
		    ROUND(
		        100.0 * SUM(CASE WHEN v.ms_vote = rus.ms_vote THEN 1 ELSE 0 END) / COUNT(*),
		        2
		    ) AS pct_agreement_w_russia
		FROM un_ga_vote v
		INNER JOIN un_ga_vote rus 
		ON v.undl_id = rus.undl_id 
		    AND rus.ms_code = 'RUS'
		WHERE v.date >= '1991-12-26' 
		    AND v.ms_vote IN ('Y', 'X', 'A')  
		    AND rus.ms_vote IN ('Y', 'X', 'A')
		GROUP BY v.ms_code
),
t4 AS (
    SELECT DISTINCT v.ms_name, -- Country Code and Name port 1991
                    v.ms_code
    FROM un_ga_vote v
	WHERE v.date >= '1991-12-26' 
)
SELECT t1.ms_code AS country_code,
       t4.ms_name AS name,
       t1.agreements_w_usa, 
       t1.pct_agreement_w_usa,
       t2.agreements_w_china,
       t2.pct_agreement_w_china,
       t3.agreements_w_russia,
       t3.pct_agreement_w_russia
FROM t1
LEFT JOIN t2 
ON t1.ms_code = t2.ms_code
LEFT JOIN t3
ON t1.ms_code = t3.ms_code
JOIN t4
ON t1.ms_code = t4.ms_code
ORDER BY t1.ms_code;

-- CREATING A table of percentage agreement with the USA, China and Russia --------------------------------
-- time-span = cold war era
WITH t1 AS (SELECT -- Percentage Agreement with USA
		    v.ms_code,
		    COUNT(*) AS total_votes,
		    SUM(CASE WHEN v.ms_vote = usa.ms_vote THEN 1 ELSE 0 END) AS agreements_w_usa,
		    ROUND(
		        100.0 * SUM(CASE WHEN v.ms_vote = usa.ms_vote THEN 1 ELSE 0 END) / COUNT(*),
		        2
		    ) AS pct_agreement_w_usa
		FROM un_ga_vote v
		INNER JOIN un_ga_vote usa 
		ON v.undl_id = usa.undl_id 
		    AND usa.ms_code = 'USA'
		WHERE v.date <= '1991-12-26' 
		    AND v.ms_vote IN ('Y', 'X', 'A')  
		    AND usa.ms_vote IN ('Y', 'X', 'A')
		GROUP BY v.ms_code
), t2 AS( -- Percentage Agreement with China
		SELECT 
		    v.ms_code,
		    COUNT(*) AS total_votes,
		    SUM(CASE WHEN v.ms_vote = chn.ms_vote THEN 1 ELSE 0 END) AS agreements_w_china,
		    ROUND(
		        100.0 * SUM(CASE WHEN v.ms_vote = chn.ms_vote THEN 1 ELSE 0 END) / COUNT(*),
		        2
		    ) AS pct_agreement_w_china
		FROM un_ga_vote v
		INNER JOIN un_ga_vote chn 
		ON v.undl_id = chn.undl_id 
		    AND chn.ms_code = 'CHN'
		WHERE v.date <= '1991-12-26' 
		    AND v.ms_vote IN ('Y', 'X', 'A')  
		    AND chn.ms_vote IN ('Y', 'X', 'A')
		GROUP BY v.ms_code
), t3 AS( -- Percentage Agreement with CCCP
		SELECT 
		    v.ms_code,
		    COUNT(*) AS total_votes,
		    SUM(CASE WHEN v.ms_vote = rus.ms_vote THEN 1 ELSE 0 END) AS agreements_w_cccp,
		    ROUND(
		        100.0 * SUM(CASE WHEN v.ms_vote = rus.ms_vote THEN 1 ELSE 0 END) / COUNT(*),
		        2
		    ) AS pct_agreement_w_cccp
		FROM un_ga_vote v
		INNER JOIN un_ga_vote rus 
		ON v.undl_id = rus.undl_id 
		    AND rus.ms_code = 'SUN'
		WHERE v.date <= '1991-12-26' 
		    AND v.ms_vote IN ('Y', 'X', 'A')  
		    AND rus.ms_vote IN ('Y', 'X', 'A')
		GROUP BY v.ms_code
),
t4 AS (
    SELECT DISTINCT v.ms_name, -- Country Code and Name 1946-1991
                    v.ms_code
    FROM un_ga_vote v
	WHERE v.date <= '1991-12-26' 
)
SELECT t1.ms_code AS country_code,
       t4.ms_name AS name,
       t1.agreements_w_usa, 
       t1.pct_agreement_w_usa,
       t2.agreements_w_china,
       t2.pct_agreement_w_china,
       t3.agreements_w_cccp,
       t3.pct_agreement_w_cccp
FROM t1
LEFT JOIN t2 
ON t1.ms_code = t2.ms_code
LEFT JOIN t3
ON t1.ms_code = t3.ms_code
JOIN t4
ON t1.ms_code = t4.ms_code
ORDER BY t1.ms_code;