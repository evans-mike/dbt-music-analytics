select date, title, closer_flag, service from {{ source("raw_data", "song_occurrences") }}
