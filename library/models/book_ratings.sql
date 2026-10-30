select
    b.book_id,
    b.title,
    (
        select max(r.stars)
        from LAB.RAW.REVIEWS as r
        where r.book_id = b.book_id
    ) as best_stars,
    (select max(r.written_at) from LAB.RAW.REVIEWS as r) as last_review_at
from LAB.SHELF.BOOKS as b
