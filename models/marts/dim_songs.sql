

with songs as (select * from {{ ref("stg__songs") }})

select *
from songs
