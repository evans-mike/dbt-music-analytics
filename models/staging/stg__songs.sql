select title, attributes, author_group, authors from {{ source("raw_data", "songs") }}
