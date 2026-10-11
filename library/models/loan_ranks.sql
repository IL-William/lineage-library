with ranked as (
    select
        l.loan_id,
        l.member_id,
        b.genre_code,
        row_number() over (
            partition by b.genre_code
            order by l.borrowed_at desc
        ) as recency_in_genre,
        dense_rank() over (
            partition by l.member_id
            order by b.published_on
        ) as age_rank_for_member
    from LAB.SHELF.LOANS_ENRICHED as l
    inner join LAB.SHELF.BOOKS as b
        on l.book_id = b.book_id
)

select * from ranked
