


WITH
    src_task_details AS (
        SELECT 
          /* no columns returned from star() macro */
        FROM billiam.intermediate.task_details
    ),

final as (
    select
        group_id::int as group_id,
        group_description,
        "task",
        detail,
        total_records::int as total_records,
        total_time::int as total_time,
        start_time,
        end_time,
    from src_task_details
)

select * from final