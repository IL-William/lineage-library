select *
from (
    select member_id, branch_code, loan_id
    from LAB.SHELF.LOANS_ENRICHED
)
pivot (count(loan_id) for branch_code in ('N', 'S', 'E'))
    as p (member_id, north_loans, south_loans, east_loans)
