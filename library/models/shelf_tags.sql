select
    books.book_id,
    t.value::string as tag
from LAB.SHELF.BOOKS,
    lateral flatten(input => books.tags) as t
