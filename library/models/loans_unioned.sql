

        (
            select
                cast('LAB.RAW.LOANS' as TEXT) as _dbt_source_relation,

                
                    cast("LOAN_ID" as NUMBER(38,0)) as "LOAN_ID" ,
                    cast("BOOK_ID" as NUMBER(38,0)) as "BOOK_ID" ,
                    cast("MEMBER_ID" as NUMBER(38,0)) as "MEMBER_ID" ,
                    cast("BRANCH_CODE" as character varying(1)) as "BRANCH_CODE" ,
                    cast("BORROWED_AT" as TIMESTAMP_NTZ) as "BORROWED_AT" ,
                    cast("DUE_ON" as DATE) as "DUE_ON" ,
                    cast("RETURNED_AT" as TIMESTAMP_NTZ) as "RETURNED_AT" ,
                    cast("STATUS" as character varying(16777216)) as "STATUS" ,
                    cast(null as TIMESTAMP_NTZ) as "ARCHIVED_AT" 

            from LAB.RAW.LOANS

            
        )

        union all
        

        (
            select
                cast('LAB.RAW.LOANS_ARCHIVE' as TEXT) as _dbt_source_relation,

                
                    cast("LOAN_ID" as NUMBER(38,0)) as "LOAN_ID" ,
                    cast("BOOK_ID" as NUMBER(38,0)) as "BOOK_ID" ,
                    cast("MEMBER_ID" as NUMBER(38,0)) as "MEMBER_ID" ,
                    cast("BRANCH_CODE" as character varying(1)) as "BRANCH_CODE" ,
                    cast("BORROWED_AT" as TIMESTAMP_NTZ) as "BORROWED_AT" ,
                    cast("DUE_ON" as DATE) as "DUE_ON" ,
                    cast("RETURNED_AT" as TIMESTAMP_NTZ) as "RETURNED_AT" ,
                    cast("STATUS" as character varying(16777216)) as "STATUS" ,
                    cast("ARCHIVED_AT" as TIMESTAMP_NTZ) as "ARCHIVED_AT" 

            from LAB.RAW.LOANS_ARCHIVE

            
        )
