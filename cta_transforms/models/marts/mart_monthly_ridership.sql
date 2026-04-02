with staging as (

    select * from {{ ref('stg_cta_daily_ridership') }}

),

monthly as (

    select
        date_trunc('month', service_date)   as month,
        year(service_date)                  as year,
        month(service_date)                 as month_num,
        strftime(service_date, '%B')        as month_name,
        sum(bus_boardings)                  as total_bus_boardings,
        sum(rail_boardings)                 as total_rail_boardings,
        sum(total_rides)                    as total_rides,
        round(sum(rail_boardings) * 100.0 / sum(total_rides), 2) as rail_pct_of_total,
        avg(total_rides)                    as avg_daily_rides

    from staging
    group by 1, 2, 3, 4

)

select * from monthly
order by month