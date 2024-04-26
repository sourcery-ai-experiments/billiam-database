



    with recursive
    stg_tracker as (
        select 
          /* no columns returned from star() macro */
        from billiam.staging.daily_tracker
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