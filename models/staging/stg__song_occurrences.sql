select
    date,
    title,
    {{ boolean_to_emoji("closer_flag") }} as closer_flag,
    service,
    extract(year from date) as year
from {{ source("raw_data", "song_occurrences") }}
where
    date is not null
    and title is not null
    and service is not null
    and closer_flag is not null
