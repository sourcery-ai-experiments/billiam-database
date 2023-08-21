

WITH
    src_tracker AS (
        SELECT 
          /* no columns returned from star() macro */
        FROM 'billiam_database/models/source/daily_tracker.csv'
    ),

final AS (
    SELECT
        date_time::TIMESTAMP AS date_time,
        TRIM(task) AS task,
        COALESCE(TRIM(detail), '') AS detail,
        "interval"::INTEGER AS interval,
        TRIM(company) AS company
    FROM src_tracker
)

SELECT * FROM final