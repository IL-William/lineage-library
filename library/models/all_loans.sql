select *
from LAB.RAW.LOANS
union all
select * exclude (archived_at)
from LAB.RAW.LOANS_ARCHIVE
union all
select
    request_id,
    title_id,
    patron_id,
    'ILL',
    requested_at,
    due_back_on,
    received_back_at,
    request_status
from LAB.RAW.INTERLIBRARY_LOANS
