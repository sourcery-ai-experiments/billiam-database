


WITH
    stg_finances AS (
        SELECT 
          /* no columns returned from star() macro */
        FROM billiam.staging.finances
    ),
    int_transactions AS (
        SELECT 
          /* no columns returned from star() macro */
        FROM billiam.intermediate.transactions
    ),

final as (
    select
        row_id,
        transaction_date,
        transaction_id,
        item,
        "cost",
        category,
        counterparty,
        exclusion_flag,
    from stg_finances
    -- noqa: disable=LT02
    where transaction_id in (
        /*
            Only keep the items for transactions that haven't been filtered out.
        */
        select transaction_id
        from int_transactions
    )
    -- noqa: enable=LT02
    order by row_id
)

select * from final