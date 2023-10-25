


WITH
    src_tracker AS (
        SELECT *
        FROM 'billiam_database/models/source/daily_tracker.csv'
    ),

final as (
    -- noqa: disable=ST06
    select
        date_time::timestamp as date_time,
        trim("task") as "task",
        coalesce(trim(detail), '') as detail,
        "interval"::integer as "interval",
        trim(company) as company
    from src_tracker
    -- noqa: enable=ST06
)

select * from final