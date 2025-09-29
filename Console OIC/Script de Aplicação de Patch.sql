-- Script de aplica��o de Patch
SELECT * FROM lacls_br_hcm_load_execution WHERE start_date > to_date(sysdate);

/*
Desabilitar a execu��o paralela de instru��es DML (Data Manipulation Language) para a sess�o atual.
*/
ALTER SESSION DISABLE PARALLEL DML;

/*
Habilitar a execu��o paralela de instru��es DML (Data Manipulation Language) para a sess�o atual.
*/
ALTER SESSION ENABLE PARALLEL DML;

/*
Verifica objets inv�lidos p�s scrpt de personalza��o de patch
*/
SELECT * FROM user_objects WHERE status = 'INVALID';
