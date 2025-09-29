-- PoS Prod = 103.261 / 103.274

WITH    contracts AS
        (
        SELECT  pos.period_of_service_id
              , paa.person_id
              , pos.date_start
              , nvl (pos.accepted_termination_date, '4712-12-31') accepted_termination_date
              , paa.assignment_id
              , paa.assignment_name
              , paa.assignment_number
              , paa.assignment_sequence
              , paa.effective_sequence
              , paa.assignment_status_type
              , paa.effective_start_date
              , paa.effective_end_date
              , paa.primary_flag
        FROM    per_periods_of_service pos
                INNER JOIN per_all_assignments_m paa
                ON      paa.period_of_service_id = pos.period_of_service_id
                AND     paa.person_id = pos.person_id
                AND     nvl (pos.actual_termination_date, '4712-12-31')
                        BETWEEN paa.effective_start_date
                        AND     paa.effective_end_date
                AND     paa.assignment_type = 'E'
                AND     paa.legislation_code = 'BR'
                AND     paa.system_person_type = 'EMP'
                AND     paa.assignment_status_type = 'ACTIVE'
                AND     paa.effective_sequence = 
                                                 (
                                                 SELECT  max (aux.effective_sequence)
                                                 FROM    per_all_assignments_m aux
                                                 WHERE   aux.assignment_id = paa.assignment_id
                                                 AND     aux.person_id = paa.person_id
                                                 AND     aux.effective_start_date = paa.effective_start_date
                                                 AND     aux.assignment_type = paa.assignment_type
                                                 AND     aux.legislation_code = paa.legislation_code
                                                 )
        )
      , duplicados AS
        (
        SELECT  period_of_service_id
              , person_id
              , assignment_number
              , effective_start_date
              , count (1) records
        FROM    contracts
        GROUP BY period_of_service_id
               , person_id
               , assignment_number
               , effective_start_date
        )
SELECT  *
FROM    duplicados;