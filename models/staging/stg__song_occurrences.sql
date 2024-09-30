select date, title, closer_flag from {{ source("raw_data", "song_occurrences") }}
