-- 1. Top 15 product/issue combinations by volume
SELECT product, issue, COUNT(*) AS complaints,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM complaints_clean), 1) AS pct_of_total
FROM complaints_clean
GROUP BY product, issue
ORDER BY complaints DESC
LIMIT 15;

-- 2. Monthly trend with month-over-month change
WITH m AS (
  SELECT year_month, COUNT(*) AS complaints
  FROM complaints_clean
  GROUP BY year_month
)
SELECT year_month, complaints,
       LAG(complaints) OVER (ORDER BY year_month) AS prev_month,
       ROUND(100.0 * (complaints - LAG(complaints) OVER (ORDER BY year_month))
             / LAG(complaints) OVER (ORDER BY year_month), 1) AS mom_pct
FROM m
ORDER BY year_month;

-- 3. Late-response rate and relief rate by issue (issues with 100+ complaints)
SELECT issue, COUNT(*) AS complaints,
       SUM(1 - is_timely) AS late,
       ROUND(100.0 * SUM(1 - is_timely) / COUNT(*), 2) AS late_pct,
       ROUND(100.0 * SUM(got_relief) / COUNT(*), 1) AS relief_pct
FROM complaints_clean
GROUP BY issue
HAVING COUNT(*) >= 100
ORDER BY relief_pct DESC;

-- 4. Top 15 companies by volume, with late and relief rates
SELECT company, COUNT(*) AS complaints,
       ROUND(100.0 * SUM(1 - is_timely) / COUNT(*), 2) AS late_pct,
       ROUND(100.0 * SUM(got_relief) / COUNT(*), 1) AS relief_pct
FROM complaints_clean
GROUP BY company
HAVING COUNT(*) >= 300
ORDER BY complaints DESC
LIMIT 15;

-- 5. Submission channel
SELECT submitted_via, COUNT(*) AS complaints,
       ROUND(100.0 * SUM(got_relief) / COUNT(*), 1) AS relief_pct
FROM complaints_clean
GROUP BY submitted_via
ORDER BY complaints DESC;
