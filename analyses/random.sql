select  * from {{ ref("dim_songs") }} 
ORDER BY RAND()

