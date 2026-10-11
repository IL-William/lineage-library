select
    fine_id,
    loan_id,
    amount_cents / 100 as amount,
    iff(waived, 0, amount) as amount_due,
    sha2(fine_id || '|' || loan_id) as fine_fingerprint,
    assessed_at::date as assessed_on
from LAB.RAW.FINES
