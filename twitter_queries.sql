------------------------------------------------------------------------------

/* QUERYING DATABASE TO OBTAIN TOTAL NUMBER OF TWEET LIKES PER TIME MEASUREMENT */
SELECT tweet.date, tweet.id, tweet.quarter, tweet.likes, tweet.retweets
FROM (SELECT EXTRACT(year FROM dates.date) AS "year",
CASE WHEN EXTRACT(month FROM dates.date) IN (1,2,3) THEN 'Q1'
	 WHEN EXTRACT(month FROM dates.date) IN (4,5,6) THEN 'Q2'
	 WHEN EXTRACT(month FROM dates.date) IN (7,8,9) THEN 'Q3'
	 ELSE 'Q4' END AS "quarter",
	 retweets.likes,
	 retweets.retweets,
	 retweets.id,
	 dates.date
FROM dates
JOIN retweets ON retweets.id = dates.id
JOIN texts ON texts.id = retweets.id) AS tweet
ORDER BY tweet.quarter;

--------------------------------------------------------------------------------

/* OBTAINING LENGTH OF TWEET ACCOMPANIED BY NUMBER OF LIKES AND RETWEETS */
SELECT texts.id, LENGTH(texts.text), retweets.likes, retweets.retweets
FROM texts
JOIN retweets ON retweets.id = texts.id;

--------------------------------------------------------------------------------

/* INVESTIGATING WHY SOME TWEETS HAVE 0 LIKES. ANSWER: THEY ARE RETWEETS MADE BY 
OPENAI WHICH CAN BE SEEN BY RT BEFORE THE TWEET*/
SELECT texts.text, retweets.likes
FROM texts
JOIN retweets ON retweets.id = texts.id
WHERE retweets.likes = 0;

--------------------------------------------------------------------------------

/* MAKING SUMMARY STATISTICS FOR THE DATA */
SELECT AVG(likes)::int8 AS avg_likes,
MAX(likes) AS max_likes, MIN(likes) AS min_likes,
(MAX(likes) - MIN(likes)) AS "range_likes",
percentile_disc(0.25) WITHIN GROUP (ORDER BY likes) AS "25th_percentile_likes",
percentile_disc(0.5) WITHIN GROUP (ORDER BY likes) AS "50th_percentile_likes",
percentile_disc(0.75) WITHIN GROUP (ORDER BY likes) AS "75th_percentile_likes",
AVG(retweets)::int8 AS avg_retweets,
MAX(retweets) AS max_retweets, MIN(retweets) AS min_retweets,
(MAX(retweets) - MIN(retweets)) AS "range_retweets",
percentile_disc(0.25) WITHIN GROUP (ORDER BY retweets) AS "25th_percentile_retweets",
percentile_disc(0.5) WITHIN GROUP (ORDER BY retweets) AS "50th_percentile_retweets",
percentile_disc(0.75) WITHIN GROUP (ORDER BY retweets) AS "75th_percentile_retweets"
FROM retweets;


