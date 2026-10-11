select
    book_id,
    author || ': ' || title as title,
    title as bare_title,
    upper(title) as title_key
from LAB.SHELF.BOOKS
