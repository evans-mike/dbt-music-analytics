{{ config(materialized="view") }}

with song_occurrences as (select * from {{ ref("stg__song_occurrences") }})

select *
from song_occurrences
