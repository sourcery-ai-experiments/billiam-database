

/*
    Will break this down into smaller models later
*/


-- noqa: disable=PRS
-- The `interval` column in `stg__daily_tracker` can't be parsed
WITH RECURSIVE
    src_transactions AS (
        SELECT 
          /* no columns returned from star() macro */
        FROM billiam.intermediate.transaction_items
    ),
    src_tracker AS (
        SELECT 
          /* no columns returned from star() macro */
        FROM billiam.staging.daily_tracker
    ),
-- noqa: enable=PRS

date_dim AS (
    -- noqa: disable=LT02
        SELECT '2018-01-01'::DATE AS metric_date
    UNION ALL
        SELECT metric_date + INTERVAL 1 DAY
        FROM date_dim
        WHERE metric_date < CURRENT_DATE()
    -- noqa: enable=LT02
),

daily_transactions AS (
    SELECT
        transaction_date AS metric_date,
        SUM("cost") AS total_cost,
        SUM("cost") FILTER (WHERE category NOT IN ('Bills', 'Council Tax', 'Rent', 'Wage')) AS non_essential_cost,
        WITHIN(ROUND(100.0 * non_essential_cost / total_cost, 4), 0, 100) AS non_essential_cost_proportion
    FROM src_transactions
    WHERE NOT exclusion_flag
    GROUP BY transaction_date
),  -- noqa: LT08
daily_work AS (
    SELECT
        date_time::DATE AS metric_date,
        SUM("interval") AS total_working_time,
        SUM("interval") FILTER (WHERE "task" IN ('Meetings', 'Catch Up')) AS meeting_time,
        ROUND(100.0 * meeting_time / total_working_time, 4) AS meeting_proportion,
        ROUND(100.0 * meeting_time / LEAST(total_working_time, 7.5 * 60), 4) AS working_day_meeting_proportion
    FROM src_tracker
    GROUP BY date_time::DATE
),

final AS (
    SELECT
        date_dim.metric_date,

        COALESCE(daily_transactions.total_cost, 0)::DECIMAL(18, 3) AS total_cost,
        COALESCE(daily_transactions.non_essential_cost, 0)::DECIMAL(18, 3) AS non_essential_cost,
        COALESCE(daily_transactions.non_essential_cost_proportion, 0)::DECIMAL(8, 4) AS non_essential_cost_proportion,
        COALESCE(daily_work.total_working_time, 0)::INT AS total_working_time,
        COALESCE(daily_work.meeting_time, 0)::INT AS meeting_time,
        COALESCE(daily_work.meeting_proportion, 0)::DECIMAL(8, 4) AS meeting_proportion,
        COALESCE(daily_work.working_day_meeting_proportion, 0)::DECIMAL(8, 4) AS working_day_meeting_proportion
    FROM date_dim
        LEFT JOIN daily_transactions USING (metric_date)
        LEFT JOIN daily_work USING (metric_date)
    ORDER BY date_dim.metric_date
)

SELECT * FROM final