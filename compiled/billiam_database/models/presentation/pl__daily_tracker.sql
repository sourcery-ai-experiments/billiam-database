


WITH
    stg_tracker AS (
        SELECT 
          /* no columns returned from star() macro */
        FROM billiam.staging.daily_tracker
    ),

final as (
    select
        date_time,
        project,
        detail,
        minutes,
        company
    from stg_tracker
)

select * from final