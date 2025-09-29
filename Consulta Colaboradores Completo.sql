SELECT  dadospessoaisessenciais.person_number
      , componentesnomeprincipaiscomunsespecificos.first_name
      , componentesnomeprincipaiscomunsespecificos.last_name
      , atributostraduzidosdocargo.name job_name
      , dadostraduziveisdoidsdaorganizacao.name department_name
      , idsdaorganizacao.attribute1
      , idsdaorganizacao.attribute2
      , idsdaorganizacao.attribute3
      , idsdaorganizacao.attribute4
      , to_char (relacoesdetrabalhodapessoa.date_start, 'DD-MM-RRRR'
               , 'nls_date_language=American') date_of_joining
      , to_char (pessoas.date_of_birth, 'DD-MM-RRRR'
               , 'nls_date_language=American') date_of_birth
FROM    per_all_people_f dadospessoaisessenciais
      , per_person_names_f componentesnomeprincipaiscomunsespecificos
      , per_all_assignments_m termosdeempregocolocacaoatribuicoes
      , per_jobs_f_tl atributostraduzidosdocargo
      , per_periods_of_service relacoesdetrabalhodapessoa
      , per_persons pessoas
      , hr_all_organization_units_f idsdaorganizacao
      , hr_organization_units_f_tl dadostraduziveisdoidsdaorganizacao
WHERE   termosdeempregocolocacaoatribuicoes.person_id = componentesnomeprincipaiscomunsespecificos.person_id
AND     dadospessoaisessenciais.person_id = componentesnomeprincipaiscomunsespecificos.person_id
AND     dadospessoaisessenciais.person_id = termosdeempregocolocacaoatribuicoes.person_id
AND     termosdeempregocolocacaoatribuicoes.job_id = atributostraduzidosdocargo.job_id (+)
AND     atributostraduzidosdocargo.language = 'US'
AND     dadostraduziveisdoidsdaorganizacao.language = 'US'
AND     termosdeempregocolocacaoatribuicoes.period_of_service_id = relacoesdetrabalhodapessoa.period_of_service_id
AND     termosdeempregocolocacaoatribuicoes.person_id = pessoas.person_id
AND     idsdaorganizacao.organization_id = termosdeempregocolocacaoatribuicoes.organization_id
AND     idsdaorganizacao.organization_id = dadostraduziveisdoidsdaorganizacao.organization_id
AND     trunc (sysdate)
        BETWEEN dadospessoaisessenciais.effective_start_date
        AND     dadospessoaisessenciais.effective_end_date
AND     trunc (sysdate)
        BETWEEN termosdeempregocolocacaoatribuicoes.effective_start_date
        AND     termosdeempregocolocacaoatribuicoes.effective_end_date
AND     trunc (sysdate)
        BETWEEN componentesnomeprincipaiscomunsespecificos.effective_start_date
        AND     componentesnomeprincipaiscomunsespecificos.effective_end_date
AND     trunc (sysdate)
        BETWEEN idsdaorganizacao.effective_start_date
        AND     idsdaorganizacao.effective_end_date
AND     trunc (sysdate)
        BETWEEN dadostraduziveisdoidsdaorganizacao.effective_start_date
        AND     dadostraduziveisdoidsdaorganizacao.effective_end_date
AND     trunc (sysdate)
        BETWEEN atributostraduzidosdocargo.effective_start_date
        AND     atributostraduzidosdocargo.effective_end_date
AND     termosdeempregocolocacaoatribuicoes.effective_latest_change = 'Y'
AND     termosdeempregocolocacaoatribuicoes.primary_flag = 'Y'
AND     termosdeempregocolocacaoatribuicoes.assignment_type = 'E'
AND     termosdeempregocolocacaoatribuicoes.assignment_status_type = 'ACTIVE'
AND     componentesnomeprincipaiscomunsespecificos.name_type = 'GLOBAL'
ORDER BY 1, 2;