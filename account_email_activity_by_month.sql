WITH
  date1 AS (
    SELECT
      e.id_account AS id_account,
      DATE_ADD(ss.date, INTERVAL e.sent_date DAY) AS actual_sent_date,
      EXTRACT(YEAR FROM DATE_ADD(ss.date, INTERVAL e.sent_date DAY)) AS sent_year,
      EXTRACT(MONTH FROM DATE_ADD(ss.date, INTERVAL e.sent_date DAY)) AS sent_month
    FROM
      `DA.email_sent` e
    JOIN
      `DA.account_session` acc
    ON
      e.id_account = acc.account_id
    JOIN
      `DA.session` ss
    ON
      acc.ga_session_id = ss.ga_session_id
  ),


  account_monthly_msg AS (
    SELECT
      id_account,
      sent_year,
      sent_month,
      COUNT(*) AS sent_msg_count,
      MIN(actual_sent_date) AS first_sent_date_in_month,
      MAX(actual_sent_date) AS last_sent_date_in_month
    FROM date1
    GROUP BY id_account, sent_year, sent_month
  ),


  total_msg_per_month AS (
    SELECT
      sent_year,
      sent_month,
      COUNT(*) AS total_msg_in_month
    FROM date1
    GROUP BY sent_year, sent_month
  )


SELECT
  a.sent_month,
  a.id_account,
  ROUND( a.sent_msg_count / t.total_msg_in_month * 100, 2) AS sent_msg_percent_from_this_mon,
  a.first_sent_date_in_month,
  a.last_sent_date_in_month
FROM account_monthly_msg a
JOIN total_msg_per_month t
  ON a.sent_year = t.sent_year AND a.sent_month = t.sent_month
ORDER BY a.sent_year, a.sent_month, a.id_account;
