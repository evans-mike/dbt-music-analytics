select title, last_occurred, familiarity_score, is_active
from {{ ref("dim_songs") }}
except distinct
select title, last_occurred, familiarity_score, is_active
from {{ ref("agg_0_12_months") }}
order by last_occurred desc
