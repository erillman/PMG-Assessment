-- Note: My answers to the questions are at the bottom of the page!
######################################################################
##################[SETTING UP DATABASE/TABLES]########################
######################################################################
CREATE DATABASE PMG_Assessment;
USE PMG_Assessment;
SET GLOBAL local_infile = 1; 
/*----------------------------------------------------------------*/
#Creating 1st table
DROP TABLE IF EXISTS marketing_data;
CREATE TABLE marketing_data
(
date VARCHAR(25) DEFAULT NULL,
geo VARCHAR(10) DEFAULT NULL,
impressions INT DEFAULT NULL,
clicks INT DEFAULT NULL
);
#Loading data into the table, I used cmd to do this
LOAD DATA LOCAL INFILE "C:/Users/Eric/Desktop/marketing_data.csv"
INTO TABLE store_revenue
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
#Converting varchar datatype into DATE datatype
UPDATE marketing_data
SET
date = STR_TO_DATE(date, '%Y-%m-%d');
/*----------------------------------------------------------------*/
#Creating 2nd table
DROP TABLE IF EXISTS store_revenue;
CREATE TABLE store_revenue
(
date VARCHAR(25) DEFAULT NULL,
brand_id INT DEFAULT NULL,
store_location VARCHAR(50) DEFAULT NULL,
revenue INT DEFAULT NULL
);
#Loading data into table, I used cmd to do this
LOAD DATA LOCAL INFILE "C:/Users/Eric/Desktop/store_revenue.csv"
INTO TABLE marketing_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
#Converting varchar datatype into DATE datatype
UPDATE store_revenue
SET
date = STR_TO_DATE(date, '%m/%d/%Y');
/*----------------------------------------------------------------*/
###########################[Answering all the assessment questions!]################################
####################################################################################################
-- Question #1 Generate a query to get the sum of the clicks of the marketing data​
SELECT SUM(clicks) AS Total_Clicks FROM marketing_data;
-- Question #2 Generate a query to gather the sum of revenue by store_location from the store_revenue table​
SELECT store_location, SUM(revenue) AS Total_Revenue FROM store_revenue GROUP BY store_location;
-- Question #3 Merge these two datasets so we can see impressions, clicks, and revenue together by date and geo. Please ensure all records from each table are accounted for.​
SELECT m.date, m.geo, impressions, clicks, SUM(revenue) AS Revenue_Sum FROM marketing_data m LEFT JOIN store_revenue s
ON s.date = m.date AND m.geo = (SUBSTR(store_location, 15, 2)) GROUP BY date, m.geo
UNION
SELECT date, SUBSTR(store_location, 15, 2) AS store_location, NULL, NULL, sum(revenue) AS Revenue_SUM FROM store_revenue s WHERE NOT EXISTS (SELECT * FROM marketing_data m
WHERE s.date = m.date AND m.geo = (SUBSTR(store_location, 15, 2)));
-- Question #4 In your opinion, what is the most efficient store and why?​
	/*Given that the revenue displayed for the campaign in CA is $234,334 in respect
     to it's low click-through-rate. I would assume that this campaign's conversion rate
     is probably 100% and it is running some sort of offer that pays out at least $8k.
     It would be safe to say that this campaign is probably the most efficient and effective, however,
     given that those are unrealistic revenue numbers, a better answer would be directed towards 
     the other marketing stats (impressions and clicks).
	 Assuming that these stats are derived from the 'advertising creative' used to run the campaign,
     I would have to say that the most efficient campaign would be the MN campaign that ran
     on January 1st, 2016. Since it's ctr is (58.42%). Whereas, ctr of your creative often decides
     the amount of volume/quality a traffic source is willing to send your campaign. Especially since
     higher CTR means your traffic is more likely to view the end of the funnel, thus, allowing for 
     more payments to the traffic source. */
-- Question #5 (Challenge) Generate a query to rank in order the top 10 revenue producing states​
	-- I'm a bit confused since there are only 3 states that have revenues listed, but here are my answers:
-- list of top revenue producing states from greatest to least:
SELECT SUBSTR(store_location, 15, 2) AS State, SUM(revenue) AS Total_Revenue FROM store_revenue GROUP BY store_location ORDER BY 2 DESC;
-- list of daily revenue from greatest to least with the respective state and date:
SELECT date, SUBSTR(store_location, 15, 2) AS State, revenue FROM store_revenue ORDER BY revenue DESC;




