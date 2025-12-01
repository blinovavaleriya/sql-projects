WITH
-- Account metrics by session date
account_metrics AS (
    SELECT
        s.date AS date,
        sp.country,
        a.send_interval,
        a.is_verified,
        a.is_unsubscribed,
        COUNT(DISTINCT a.id) AS account_cnt,
        0 AS sent_msg,
        0 AS open_msg,
        0 AS visit_msg
    FROM DA.account a
    JOIN DA.account_session acs ON a.id = acs.account_id
    JOIN DA.session s ON acs.ga_session_id = s.ga_session_id
    JOIN DA.session_params sp ON s.ga_session_id = sp.ga_session_id
    GROUP BY s.date, sp.country, a.send_interval, a.is_verified, a.is_unsubscribed
),


-- Email metrics with session date and sent_date interval
email_metrics AS (
    SELECT
        DATE_ADD(s.date, INTERVAL es.sent_date DAY) AS date,
        sp.country,
        a.send_interval,
        a.is_verified,
        a.is_unsubscribed,
        0 AS account_cnt,
        COUNT(DISTINCT es.id_message) AS sent_msg,
        COUNT(DISTINCT eo.id_message) AS open_msg,
        COUNT(DISTINCT ev.id_message) AS visit_msg
    FROM DA.account a
    JOIN DA.email_sent es ON a.id = es.id_account
    JOIN DA.account_session acs ON a.id = acs.account_id
    JOIN DA.session s ON acs.ga_session_id = s.ga_session_id
    JOIN DA.session_params sp ON s.ga_session_id = sp.ga_session_id
    LEFT JOIN DA.email_open eo ON es.id_message = eo.id_message
    LEFT JOIN DA.email_visit ev ON es.id_message = ev.id_message
    GROUP BY DATE_ADD(s.date, INTERVAL es.sent_date DAY), sp.country, a.send_interval, a.is_verified, a.is_unsubscribed
),


-- Merging account and email metrics
combined AS (
    SELECT * FROM account_metrics
    UNION ALL
    SELECT * FROM email_metrics
),


-- Aggregation by specified dimensions
aggregated AS (
    SELECT
        date,
        country,
        send_interval,
        is_verified,
        is_unsubscribed,
        SUM(account_cnt) AS account_cnt,
        SUM(sent_msg) AS sent_msg,
        SUM(open_msg) AS open_msg,
        SUM(visit_msg) AS visit_msg
    FROM combined
    GROUP BY date, country, send_interval, is_verified, is_unsubscribed
),


-- Calculation of totals by countries
totals AS (
    SELECT
        *,
        SUM(account_cnt) OVER (PARTITION BY country) AS total_country_account_cnt,
        SUM(sent_msg) OVER (PARTITION BY country) AS total_country_sent_cnt
    FROM aggregated
),


-- Calculation of ranks by totals
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (ORDER BY total_country_account_cnt DESC) AS rank_total_country_account_cnt,
        DENSE_RANK() OVER (ORDER BY total_country_sent_cnt DESC) AS rank_total_country_sent_cnt
    FROM totals
)


-- Output of the top 10 countries by accounts or emails
SELECT *
FROM ranked
WHERE rank_total_country_account_cnt <= 10
   OR rank_total_country_sent_cnt <= 10
ORDER BY date, country;