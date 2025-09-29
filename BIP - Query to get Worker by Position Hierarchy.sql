WITH    positionworker AS
        (
        SELECT  allpeople.person_number
              , allassignments.assignment_number
              , personnames.full_name
              , allpositionparent.position_id
              , allpositions.position_code
              , allpositions.name position_name
              , positionhierarchy.parent_position_id
              , allpositionparent.position_code position_parent_code
              , allpositionparent.name position_parent_name
        FROM    per_all_assignments_m allassignments
                LEFT OUTER JOIN per_person_names_f personnames
                ON      personnames.person_id = allassignments.person_id
                AND     personnames.name_type = 'GLOBAL'
                AND     allassignments.effective_end_date
                        BETWEEN personnames.effective_start_date
                        AND     personnames.effective_end_date
                LEFT OUTER JOIN per_all_people_f allpeople
                ON      allpeople.person_id = allassignments.person_id
                AND     sysdate
                        BETWEEN allpeople.effective_start_date
                        AND     allpeople.effective_end_date
                LEFT OUTER JOIN hr_all_positions allpositions
                ON      allpositions.position_id = allassignments.position_id
                AND     sysdate
                        BETWEEN allpositions.effective_start_date
                        AND     allpositions.effective_end_date
                LEFT OUTER JOIN per_position_hierarchy_f positionhierarchy
                ON      positionhierarchy.position_id = allpositions.position_id
                AND     sysdate
                        BETWEEN positionhierarchy.effective_start_date
                        AND     positionhierarchy.effective_end_date
                LEFT OUTER JOIN hr_all_positions allpositionparent
                ON      allpositionparent.position_id = positionhierarchy.parent_position_id
                AND     sysdate
                        BETWEEN allpositionparent.effective_start_date
                        AND     allpositionparent.effective_end_date
        WHERE   allassignments.assignment_type = 'E'
        AND     sysdate
                BETWEEN allassignments.effective_start_date
                AND     allassignments.effective_end_date
        AND     allpeople.person_number = 911
        )
SELECT  positionworker.person_number
      , positionworker.assignment_number
      , positionworker.full_name
      , positionworker.position_code
      , positionworker.position_name
      , positionworker.position_parent_code
      , positionworker.position_parent_name
      , allassignments.assignment_number assignment_number_parent
      , personnames.full_name full_name_parent
FROM    positionworker
        INNER JOIN per_all_assignments_m allassignments
        ON      allassignments.position_id = positionworker.parent_position_id
        AND     allassignments.assignment_type = 'E'
        AND     sysdate
                BETWEEN allassignments.effective_start_date
                AND     allassignments.effective_end_date
        LEFT OUTER JOIN per_person_names_f personnames
        ON      personnames.person_id = allassignments.person_id
        AND     personnames.name_type = 'GLOBAL'
        AND     allassignments.effective_end_date
                BETWEEN personnames.effective_start_date
                AND     personnames.effective_end_date;