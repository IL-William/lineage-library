select
    loans_enriched.loan_id,
    loans_enriched.borrowed_at,
    books.title,
    upper(books.genre_code) as genre
from LAB.SHELF.LOANS_ENRICHED
inner join LAB.SHELF.BOOKS
    on loans_enriched.book_id = books.book_id
where books.published_on is not null
