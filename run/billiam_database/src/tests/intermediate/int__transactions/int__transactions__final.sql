select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      

 -- depends_on: "stg__finances"



  
  


  
    
    

    
  

    
    
    

    
    
    select 1 as a from (select 1) as t where False
  

      
    ) dbt_internal_test