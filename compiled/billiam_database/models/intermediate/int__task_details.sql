


-- noqa: disable=PRS
-- The `interval` column in `stg__daily_tracker` can't be parsed
WITH
    src_tracker AS (
        SELECT 
          /* no columns returned from star() macro */
        FROM billiam.staging.daily_tracker
    ),
-- noqa: enable=PRS

final AS (
    -- noqa: disable=ST06
    SELECT
        GROUPING_ID("task", detail) AS group_id,
        CASE GROUPING_ID("task", detail)
            WHEN 0 THEN 'Task and detail'
            WHEN 1 THEN 'Task only'
        END AS group_description,
        "task",
        detail,

        COUNT(*) AS total_records,
        SUM("interval") AS total_time,
        MIN(date_time) AS start_time,
        MAX(date_time) AS end_time
    FROM src_tracker
    -- noqa: disable=CP02, RF06, PRS
    -- SQLFluff thinks that `GROUPING SETS` is a column name?!
    GROUP BY GROUPING SETS (
        ("task", detail),
        ("task")
    )
    -- noqa: enable=CP02, RF06, PRS
)

SELECT * FROM final