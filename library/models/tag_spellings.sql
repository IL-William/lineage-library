select
    b.book_id,
    transform(b.tags, title -> initcap(title::string)) as tag_titles,
    filter(b.tags, tag -> lower(tag::string) <> lower(b.genre_code)) as tags_beyond_genre
from LAB.SHELF.BOOKS as b
