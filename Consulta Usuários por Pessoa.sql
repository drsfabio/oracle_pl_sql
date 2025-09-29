SELECT  users.user_id
      , users.user_guid
      , users.username
      , names.full_name
      , email.email_address
FROM    per_users users
        INNER JOIN per_person_names_f_v names
        ON      names.person_id = users.person_id
        AND     sysdate
                BETWEEN names.effective_start_date
                AND     names.effective_end_date
        INNER JOIN per_all_people_f people
        ON      people.person_id = users.person_id
        AND     sysdate
                BETWEEN people.effective_start_date
                AND     people.effective_end_date
        LEFT OUTER JOIN per_email_addresses_v email
        ON      email.person_id = users.person_id
WHERE names.full_name LIKE '%Georgia Luana da Silva Na%'