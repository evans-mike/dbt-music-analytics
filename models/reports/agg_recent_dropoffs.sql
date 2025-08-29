select title, is_active, last_occurred, familiarity_score
from {{ ref("agg_12_24_months") }}
except distinct
select title, is_active, last_occurred, familiarity_score
from {{ ref("agg_0_12_months") }}
order by last_occurred desc
