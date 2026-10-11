select
    l.member_id,
    count(*) as fine_count,
    sum(f.amount_due) as total_due,
    max(f.assessed_on) as last_assessed_on
from LAB.SHELF.FINES_CLEAN as f
inner join LAB.SHELF.LOANS_ENRICHED as l
    on f.loan_id = l.loan_id
group by l.member_id
having sum(f.amount_due) > 0
