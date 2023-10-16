

WITH
    src_tracker AS (
        SELECT *
        FROM 'billiam_database/models/source/daily_tracker.csv'
    ),

final AS (
    -- noqa: disable=ST06
    SELECT
        date_time::TIMESTAMP AS date_time,
        TRIM("task") AS "task",
        COALESCE(TRIM(detail), '') AS detail,
        "interval"::INTEGER AS "interval",
        TRIM(company) AS company
    FROM src_tracker
    -- noqa: enable=ST06
)

SELECT * FROM final