with latest_reviews as (
    select *
    from LAB.RAW.REVIEWS
    qualify row_number() over (
        partition by member_id, book_id
        order by written_at desc
    ) = 1
)

select
    r.member_id,
    listagg(b.title, ' / ') within group (order by r.written_at) as titles_in_order,
    avg(r.stars) as mean_stars
from latest_reviews as r
inner join LAB.SHELF.BOOKS as b
    on r.book_id = b.book_id
group by r.member_id
