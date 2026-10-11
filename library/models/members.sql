select
    * exclude (deleted, given_name, family_name),
    given_name || ' ' || family_name as display_name,
    lower(email) as email_key
from LAB.RAW.MEMBERS
where not deleted
