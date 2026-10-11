select
    b.book_id,
    t.value::string as tag,
    t.index as tag_position
from LAB.SHELF.BOOKS as b,
    lateral flatten(input => b.tags) as t
