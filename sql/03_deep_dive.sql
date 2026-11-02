-- A. Who is behind the late "Money was not available when promised" responses?
SELECT company, COUNT(*) AS complaints, SUM(1 - is_timely) AS late
FROM complaints_clean
WHERE issue = 'Money was not available when promised'
GROUP BY company ORDER BY late DESC LIMIT 10;

-- B. Share of all late responses by company
SELECT company, SUM(1 - is_timely) AS late,
       ROUND(100.0 * SUM(1 - is_timely) / (SELECT SUM(1 - is_timely) FROM complaints_clean), 1) AS pct_of_all_late
FROM complaints_clean
GROUP BY company ORDER BY late DESC LIMIT 10;

-- C. Relief rate by company within the same issue: purchase problems
SELECT company, COUNT(*) AS complaints,
       ROUND(100.0 * SUM(got_relief) / COUNT(*), 1) AS relief_pct
FROM complaints_clean
WHERE issue = 'Problem with a purchase shown on your statement'
GROUP BY company HAVING COUNT(*) >= 300 ORDER BY relief_pct DESC;

-- D. Relief rate by company within the same issue: fraud or scam
SELECT company, COUNT(*) AS complaints,
       ROUND(100.0 * SUM(got_relief) / COUNT(*), 1) AS relief_pct
FROM complaints_clean
WHERE issue = 'Fraud or scam'
GROUP BY company HAVING COUNT(*) >= 200 ORDER BY relief_pct DESC;
