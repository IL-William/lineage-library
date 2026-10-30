select
    r.review_id,
    object_construct(*) as review_doc,
    hash(*) as review_hash
from LAB.RAW.REVIEWS as r
