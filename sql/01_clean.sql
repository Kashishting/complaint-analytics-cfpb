DROP TABLE IF EXISTS complaints_clean;

CREATE TABLE complaints_clean AS
SELECT
  complaint_id,
  date(date_received) AS date_received,
  date(date_sent_to_company) AS date_sent_to_company,
  strftime('%Y-%m', date_received) AS year_month,
  product,
  sub_product,
  issue,
  sub_issue,
  company,
  state,
  submitted_via,
  tags,
  company_public_response,
  company_response_to_consumer,
  timely_response,
  CAST(julianday(date_sent_to_company) - julianday(date_received) AS INTEGER) AS days_to_company,
  CASE WHEN timely_response = 'Yes' THEN 1 ELSE 0 END AS is_timely,
  CASE WHEN company_response_to_consumer IN
    ('Closed with monetary relief', 'Closed with non-monetary relief')
    THEN 1 ELSE 0 END AS got_relief
FROM complaints;
