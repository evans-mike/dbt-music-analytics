select date, title, closer as closer_flag
from {{ source("raw_data", "song_occurrences") }}
