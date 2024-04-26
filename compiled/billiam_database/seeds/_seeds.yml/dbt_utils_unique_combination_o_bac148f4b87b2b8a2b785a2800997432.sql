





with validation_errors as (

    select
        company, from_date
    from billiam.seeds.work_hours
    group by company, from_date
    having count(*) > 1

)

select *
from validation_errors


