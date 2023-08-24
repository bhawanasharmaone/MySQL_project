CREATE SCHEMA cars;

USE cars;

-- Read data-- 
SELECT *
FROM car_dekho;

-- Total cars--
SELECT COUNT(*)
FROM car_dekho;


-- Average Selling Price by Fuel Type:
-- What's the average selling price for cars based on their fuel type (Petrol, Diesel, Electric)?
-- Which fuel type tends to have the highest average selling price? And the lowest?
SELECT fuel, ROUND(AVG(selling_price),2) AS avg_SP
FROM car_dekho
GROUP BY fuel
ORDER BY avg_SP desc;


-- Distribution of Seller Types:
-- How are the cars distributed among different seller types (Individual, Dealer)?
SELECT seller_type, count(*)
FROM car_dekho
GROUP BY seller_type;

-- Do certain seller types tend to sell cars with higher or lower prices?
SELECT seller_type, AVG(selling_price) AS avg_SP
FROM car_dekho
GROUP BY seller_type
ORDER BY avg_SP DESC;

-- Transmission Preference and Mileage:
-- What's the average mileage for cars with manual transmission compared to automatic transmission?
-- Is there a noticeable difference in mileage between different transmission types?
SELECT TRIM(transmission), AVG(mileage)
FROM car_dekho
GROUP BY TRIM(transmission);

-- Impact of Owner Count on Selling Price:
-- Does the number of previous owners impact the selling price of a car?
-- Are cars with fewer owners generally sold at higher prices? YES
SELECT owner, AVG(selling_price) AS avg_sp
FROM car_dekho
GROUP BY owner
ORDER BY avg_sp DESC;

-- Top Car Models by Average Selling Price:
-- Which car models have the highest average selling prices?
-- Are these models from a particular manufacturer or category?
SELECT Name AS Model_Name, 
AVG(selling_price) AS avg_sp,
SUBSTRING_INDEX(Name, " ", 1) AS Manufacturer
FROM car_dekho
GROUP BY Name
ORDER BY avg_sp DESC
LIMIT 5;

-- Correlation between Engine Power and Selling Price:
-- Is there a correlation between the engine's maximum power and the selling price?
-- Calculate correlation coefficient between max_power and selling_price
SELECT (COUNT(*) * SUM(max_power * selling_price) - SUM(max_power) * SUM(selling_price)) /
    SQRT((COUNT(*) * SUM(max_power * max_power) - SUM(max_power) * SUM(max_power)) * (COUNT(*) * SUM(selling_price * selling_price) - SUM(selling_price) * SUM(selling_price)))
    AS correlation_coefficient
FROM car_dekho;

-- Average selling price by range of engine power

SELECT
    MIN(max_power) AS min_value,
    (SELECT MAX(max_power) FROM car_dekho WHERE max_power <= (SELECT MAX(max_power) * 0.25 FROM car_dekho)) AS first_quartile,
    (SELECT MAX(max_power) FROM car_dekho WHERE max_power <= (SELECT MAX(max_power) * 0.50 FROM car_dekho)) AS second_quartile,
    (SELECT MAX(max_power) FROM car_dekho WHERE max_power <= (SELECT MAX(max_power) * 0.75 FROM car_dekho)) AS third_quartile,
    MAX(max_power) AS max_value
FROM
    car_dekho;
    
    
SELECT 
    CASE
        WHEN max_power >= 72.02 THEN 'High Power'
        WHEN max_power >= 48.21 AND max_power < 72.02 THEN 'Medium Power'
        ELSE 'Low Power'
    END AS engine_power_range,
    AVG(selling_price) AS avg_selling_price
FROM car_dekho
GROUP BY engine_power_range
ORDER BY avg_selling_price DESC;

-- Average Selling Price by Year:
SELECT year, AVG(selling_price) AS avg_sp
FROM car_dekho
GROUP BY year
ORDER BY year DESC;

-- How has the average selling price of cars evolved over the years?
-- Calculate average selling price difference per year
-- Are there any noticeable trends or patterns?
SELECT
    a.year,
    a.avg_selling_price AS avg_selling_price,
    a.avg_selling_price - COALESCE(b.avg_selling_price, a.avg_selling_price) AS price_difference
FROM (SELECT year, AVG(selling_price) AS avg_selling_price
	FROM car_dekho
	GROUP BY year) a
LEFT JOIN (SELECT year,AVG(selling_price) AS avg_selling_price
FROM car_dekho
GROUP BY year) b ON a.year = b.year + 1
ORDER BY a.year DESC;


-- Comparison of Electric Car Mileage: -- How does the mileage of electric cars compare to petrol and diesel cars on average?
-- Are there electric cars with significantly higher or lower mileage?
SELECT fuel, AVG(mileage) AS avg_mil
FROM car_dekho
GROUP BY fuel
ORDER BY avg_mil DESC;



-- Distribution of Car Seats:
-- What's the distribution of the number of seats in the cars listed?
SELECT seats, COUNT(*)
FROM car_dekho
GROUP BY seats
ORDER BY COUNT(*) DESC;


-- Are cars with a specific number of seats more common? Yes, 5

-- Price per Kilometer Driven:
-- Is there a relationship between the selling price and the number of kilometers driven?
SELECT (COUNT(*) * SUM(km_driven * selling_price) - SUM(km_driven) * SUM(selling_price)) /
    SQRT((COUNT(*) * SUM(km_driven * km_driven) - SUM(km_driven) * SUM(km_driven)) * (COUNT(*) * SUM(selling_price * selling_price) - SUM(selling_price) * SUM(selling_price)))
    AS correlation_coefficient
FROM car_dekho;





