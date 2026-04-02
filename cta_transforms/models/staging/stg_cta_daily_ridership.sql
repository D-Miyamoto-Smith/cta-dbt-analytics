with source as (

    select * from {{ ref('cta_daily_ridership') }}

),

renamed as (

    select
        strptime(service_date, '%m/%d/%Y')::date                        as service_date,
        day_type                                                         as day_type_code,
        case day_type
            when 'W' then 'Weekday'
            when 'A' then 'Saturday'
            when 'U' then 'Sunday / Holiday'
        end                                                              as day_type_label,
        cast(replace(cast(bus as varchar), ',', '') as integer)          as bus_boardings,
        cast(replace(cast(rail_boardings as varchar), ',', '') as integer) as rail_boardings,
        cast(replace(cast(total_rides as varchar), ',', '') as integer)  as total_rides
    from source

)

select * from renamed