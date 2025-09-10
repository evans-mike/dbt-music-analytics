select title, authors, author_group, introduced
from {{ ref("dim_songs") }}
order by introduced, title
