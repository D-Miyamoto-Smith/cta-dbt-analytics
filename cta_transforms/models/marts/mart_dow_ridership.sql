with staging as (

    select * from {{ ref('stg_cta_daily_ridership') }}

),

dow as (

    select
        dayofweek(service_date)             as day_of_week_num,
        dayname(service_date)               as day_of_week_name,
        day_type_label,
        count(*)                            as total_days_observed,
        sum(bus_boardings)                  as total_bus_boardings,
        sum(rail_boardings)                 as total_rail_boardings,
        sum(total_rides)                    as total_rides,
        round(avg(bus_boardings), 0)        as avg_bus_boardings,
        round(avg(rail_boardings), 0)       as avg_rail_boardings,
        round(avg(total_rides), 0)          as avg_total_rides

    from staging
    group by 1, 2, 3

)

select * from dow
order by day_of_week_num