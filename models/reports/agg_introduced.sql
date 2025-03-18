select title, introduced from {{ ref("dim_songs") }} order by introduced, title
