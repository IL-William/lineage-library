with branches as (
    select *
    from (values ('N', 'North'), ('S', 'South'), ('E', 'East')) as v (code, branch_name)
),

activity as (
    select branch_code, 'loan' as activity, borrowed_at as happened_at
    from LAB.SHELF.LOANS_ENRICHED
    union all
    select m.branch_code, 'join', m.joined_at
    from LAB.SHELF.MEMBERS as m
)

select
    a.branch_code,
    coalesce(br.branch_name, 'unknown') as branch_name,
    a.activity,
    a.happened_at
from activity as a
left join branches as br
    on a.branch_code = br.code
