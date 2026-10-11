select
    book_id,
    title,
    author_first || ' ' || author_last as author,
    cast(published_on as date) as published_on,
    upper(genre_code) as genre_code,
    isbn as isbn13,
    tags,
    'v2' as shelf_version,
    current_timestamp() as shelved_at
from LAB.RAW.BOOKS
