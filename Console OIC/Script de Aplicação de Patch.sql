-- Script de aplicação de Patch
SELECT * FROM lacls_br_hcm_load_execution WHERE start_date > to_date(sysdate);

/*
Desabilitar a execução paralela de instruções DML (Data Manipulation Language) para a sessão atual.
*/
ALTER SESSION DISABLE PARALLEL DML;

/*
Habilitar a execução paralela de instruções DML (Data Manipulation Language) para a sessão atual.
*/
ALTER SESSION ENABLE PARALLEL DML;

/*
Verifica objets inválidos pós scrpt de personalzação de patch
*/
SELECT * FROM user_objects WHERE status = 'INVALID';
