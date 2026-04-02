with source as (

    select * from {{ ref('cta_daily_ridership') }}

),

renamed as (

    select
        cast(service_date as date)  as service_date,
        day_type                    as day_type_code,
        case day_type
            when 'W' then 'Weekday'
            when 'A' then 'Saturday'
            when 'U' then 'Sunday / Holiday'
        end                         as day_type_label,
        bus                         as bus_boardings,
        rail_boardings,
        total_rides
    from source

)

select * from renamed