


/*
    Not helpful for me, but illustrates the usage
*/

WITH
    int_transaction_items AS (
        SELECT 
          /* no columns returned from star() macro */
        FROM billiam.intermediate.transaction_items
    ),

final as (
    -- noqa: disable=ST06
    select
        grouping_id(
            transaction_date,
            category,
            counterparty,
            exclusion_flag
        ) as group_id,
        transaction_date,
        category,
        counterparty,
        exclusion_flag,

        count(distinct transaction_id) as total_transaction_count,
        count(*) as total_item_count,
        count(distinct item) as distinct_item_count,
        sum("cost") as total_cost,
        avg("cost") as average_cost,
        min("cost") as min_cost,
        max("cost") as max_cost,
        stddev_pop("cost") as standard_dev_cost,
    from int_transaction_items
    -- noqa: enable=ST06
    
    group by cube(
        transaction_date,
        category,
        counterparty,
        exclusion_flag
    )
)

select * from final