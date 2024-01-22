 -- World_life_expectancy_Project - Data Cleaning
 SELECT * 
 FROM world_life_expectancy;
 
--  Check for Duplicates
 SELECT country, year, CONCAT(country, year), count(CONCAT(country, year))  
 FROM world_life_expectancy
 GROUP BY country, year, CONCAT(country, year)
 HAVING count(CONCAT(country, year)) > 1;
 
--  Using window function, check for duplicates to asign row_num on the duplicated rows
 SELECT * FROM
 (SELECT row_id, CONCAT(country, year),
 row_number() Over(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country,year)) As Row_num
 FROM world_life_expectancy) AS Row_table
 WHERE row_num > 1;
 
-- Delete Duplicates
 Delete FROM world_life_expectancy
 WHERE row_id IN (
 SELECT row_id FROM
 (SELECT row_id, CONCAT(country, year),
 row_number() Over(PARTITION BY CONCAT(country, year) ORDER BY CONCAT(country,year)) As Row_num
 FROM world_life_expectancy) AS Row_table
 WHERE row_num > 1);
 
  SELECT *  -- To check for blank rows
 FROM world_life_expectancy
 WHERE status = '';
 
   SELECT distinct(status) -- To check values of Status column
 FROM world_life_expectancy
 WHERE status <> '';
 
SELECT distinct(country) -- To check WHERE status is developing
 FROM world_life_expectancy
 WHERE status = "developing";

Update world_life_expectancy t1 -- Update the blank rows WHERE country is 'Developing'
JOIN world_life_expectancy t2
ON t1.country = t2.country
SET t1.status = 'developing'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'developing';

Update world_life_expectancy t1 -- Update the blank rows WHERE country is 'Developed'
JOIN world_life_expectancy t2
ON t1.country = t2.country
SET t1.status = 'developed'
WHERE t1.status = ''
AND t2.status <> ''
AND t2.status = 'developed';

 SELECT *  -- To check for blank rows in Life expectancy
 FROM world_life_expectancy
 WHERE `life expectancy` = '';

SELECT t1.country, t1.year, t1.`Life expectancy`, -- Update the records
t2.country, t2.year, t2.`Life expectancy`,
t3.country, t3.year, t3.`Life expectancy`,
round((t2. `Life expectancy` + t3. `Life expectancy`)/2,1) -- Take the average of both the rows as an assumptiON for the missing values
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
 ON t1.country = t2.country
 AND t1.year = t2.year - 1
 JOIN world_life_expectancy t3
 ON t1.country = t3.country
 AND t1.year = t3.year + 1
 WHERE t1.`Life expectancy` = '';
 
--  Update the missing values with the average of upper and lower values
 UPDATE world_life_expectancy t1
 JOIN world_life_expectancy t2
 ON t1.country = t2.country
 AND t1.year = t2.year - 1
 JOIN world_life_expectancy t3
 ON t1.country = t3.country
 AND t1.year = t3.year + 1
 SET t1.`life expectancy` = round((t2. `Life expectancy` + t3. `Life expectancy`)/2,1)
 WHERE t1.`life expectancy` = '';




 