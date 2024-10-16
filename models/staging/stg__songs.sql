select title, attributes from {{ source("raw_data", "songs") }}
