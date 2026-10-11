with fiction as (
    with picked as (
        select book_id, title from LAB.SHELF.BOOKS where genre_code = 'FIC'
    )
    select * from picked
),

reviewed as (
    with picked as (
        select book_id, stars from LAB.RAW.REVIEWS where stars >= 4
    )
    select * from picked
)

select
    f.book_id,
    f.title,
    max(r.stars) as best_stars
from fiction as f
inner join reviewed as r
    on f.book_id = r.book_id
group by f.book_id, f.title
