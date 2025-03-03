select
    date,
    title,
    closer_flag,
    service,
    extract(year from date) as year,
    {{ get_period("date", "week", 52, 8) }} as period
from {{ source("raw_data", "song_occurrences") }}
