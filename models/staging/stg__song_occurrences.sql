select
    date,
    title,
    {{ boolean_to_emoji("closer_flag") }} as closer_flag,
    service,
    extract(year from date) as year
from {{ source("raw_data", "song_occurrences") }}
