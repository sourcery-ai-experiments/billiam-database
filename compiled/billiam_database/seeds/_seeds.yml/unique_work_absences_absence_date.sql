
    
    

select
    absence_date as unique_field,
    count(*) as n_records

from billiam.seeds.work_absences
where absence_date is not null
group by absence_date
having count(*) > 1


