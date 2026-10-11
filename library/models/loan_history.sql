select
    loan_id,
    member_id,
    loan_state,
    days_out,
    borrowed_at
from LAB.SHELF.LOANS_ENRICHED
where borrowed_at > (select max(borrowed_at) from LAB.SHELF.LOAN_HISTORY)
