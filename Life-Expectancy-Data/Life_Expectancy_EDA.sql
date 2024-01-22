-- World_life_expectancy_Project - Exploratory Data Analysis
 
SELECT 
    Country,
    MIN(`Life expectancy`),
    MAX(`Life expectancy`),
    ROUND(MAX(`Life expectancy`) - MIN(`Life expectancy`),
            2) AS Life_Increase_15_years
FROM
    world_life_expectancy
GROUP BY Country
HAVING MIN(`Life expectancy`) <> 0
    AND MAX(`Life expectancy`) <> 0
ORDER BY Life_Increase_15_years DESC;

-- Average Life Expectancy over the years
SELECT 
    Year, ROUND(AVG(`Life expectancy`), 2)
FROM
    world_life_expectancy
WHERE
    `Life expectancy` <> 0
GROUP BY year
ORDER BY year;

-- Relation between GDP and life expectancy 
SELECT 
    country,
    ROUND(AVG(`life expectancy`), 1) AS life_exp,
    ROUND(AVG(gdp), 1) AS gdp
FROM
    world_life_expectancy
GROUP BY country
HAVING life_exp > 0 AND gdp > 0
ORDER BY gdp ASC;

SELECT 
    SUM(CASE
        WHEN gdp >= 1500 THEN 1
        ELSE 0
    END) AS high_gdp_count,
    AVG(CASE
        WHEN gdp >= 1500 THEN `life expectancy`
        ELSE NULL
    END) AS high_gdp_life_expectancy,
    SUM(CASE
        WHEN gdp <= 1500 THEN 1
        ELSE 0
    END) AS low_gdp_count,
    AVG(CASE
        WHEN gdp <= 1500 THEN `life expectancy`
        ELSE NULL
    END) AS low_gdp_life_expectancy
FROM
    world_life_expectancy;
    
-- Analysis of Status
SELECT 
    status, ROUND(AVG(`life expectancy`), 1)
FROM
    world_life_expectancy
GROUP BY status;

SELECT 
    status,
    COUNT(DISTINCT country),
    ROUND(AVG(`life expectancy`), 1)
FROM
    world_life_expectancy
GROUP BY status;


-- BMI Analysis
SELECT 
    country,
    ROUND(AVG(`life expectancy`), 1) AS life_exp,
    ROUND(AVG(bmi), 1) AS BMI
FROM
    world_life_expectancy
GROUP BY country
HAVING life_exp > 0 AND bmi > 0
ORDER BY bmi DESC;

-- Rolling total of Adult Mortality w.r.t countries using window function
SELECT Country, year, `life expectancy`, `Adult Mortality`,
SUM(`Adult Mortality`) OVER (PARTITION BY country ORDER BY year) AS Rolling_total
FROM world_life_expectancy
WHERE country LIKE '%united%';



