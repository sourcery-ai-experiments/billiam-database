



    with recursive
    stg_finances as (
        select 
          /* no columns returned from star() macro */
        from billiam.staging.finances
    ),

final as (
    select
        transaction_id,
        transaction_date,
        round(sum("cost"), 2) as "cost",
        count(*) as item_count,
        group_concat(distinct counterparty, '||') as counterparty,
    from stg_finances
    group by transaction_id, transaction_date
    having not (count(*) = 2 and round(sum("cost"), 2) = 0)  /* Exclude credit repayment transactions */
    order by transaction_id
)

select * from final