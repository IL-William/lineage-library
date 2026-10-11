with loans as (
    select * from LAB.RAW.LOANS
),

members as (
    select * from LAB.SHELF.MEMBERS
),

joined as (
    select
        l.loan_id,
        l.book_id,
        l.member_id,
        m.display_name as borrower,
        coalesce(l.branch_code, m.branch_code) as branch_code,
        l.borrowed_at,
        case
            when l.returned_at is null and l.due_on < current_date() then 'overdue'
            when l.returned_at is null then 'out'
            else 'back'
        end as loan_state,
        datediff('day', l.borrowed_at, coalesce(l.returned_at, current_date())) as days_out
    from loans as l
    inner join members as m
        on l.member_id = m.member_id
    where l.status != 'void'
)

select * from joined
