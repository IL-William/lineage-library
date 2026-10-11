with __dbt__cte__member_fines as (
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
), members as (
    select * from LAB.SHELF.MEMBERS
),

fines as (
    select * from __dbt__cte__member_fines
)

select
    members.*,
    coalesce(fines.fine_count, 0) as fine_count,
    coalesce(fines.total_due, 0) as total_due,
    fines.last_assessed_on,
    md5(members.member_id || members.email) as member_checksum
from members
left join fines
    on members.member_id = fines.member_id
