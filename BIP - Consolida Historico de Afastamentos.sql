WITH AusenciasLG
AS (
    SELECT col.EMPRESA
        , col.MATRICULA
        , col.CPF
        , col.COLABORADOR
        , map.ORIGEM
        , map.AUSENCIA_ID
        , map.TIPOS_AUSENCIA TIPO_AFASTAMENTO
        , aus.DATA_INICIO
        , 'DATA_INICIO_LG' PVT_DATA_INICIO
        , aus.DATA_FIM DATA_FIM_LG
        , NULL DATA_FIM_ORACLE
        , NULL DATA_FIM_RSDATA
        , NULL DATA_FIM_SENIOR
        , aus.CID CID_LG
        , NULL CID_ORACLE
        , NULL CID_RSDATA
        , NULL CID_SENIOR
    FROM Colaborador col
    INNER JOIN AUSENCIAS_LG aus
        ON aus.EMPRESA = col.EMPRESA
            AND aus.MATRICULA = col.MATRICULA
    LEFT JOIN DeParaAfastamento dpa
        ON dpa.TipoAfastamento = aus.CODIGO_TIPO_AFASTAMENTO
            AND dpa.CodigoMotivoEsocial = aus.CODIGO_MOTIVO_ESOCIAL
            AND dpa.CodigoSituacao = aus.CODIGO_SITUACAO
    LEFT JOIN OracleMapaAusencias map
        ON map.TIPOS_AUSENCIA = dpa.IntegracaoOracle
    WHERE 1 = 1
    )
    , AusenciasSenior
AS (
    SELECT col.EMPRESA
        , col.MATRICULA
        , col.CPF
        , col.COLABORADOR
        , map.ORIGEM
        , map.AUSENCIA_ID
        , map.TIPOS_AUSENCIA TIPO_AFASTAMENTO
        , aus.DATA_INICIO
        , 'DATA_INICIO_SENIOR' PVT_DATA_INICIO
        , NULL DATA_FIM_LG
        , NULL DATA_FIM_ORACLE
        , NULL DATA_FIM_RSDATA
        , aus.DATA_TERMINO DATA_FIM_SENIOR
        , NULL CID_LG
        , NULL CID_ORACLE
        , NULL CID_RSDATA
        , NULL CID_SENIOR
    FROM Colaborador col
    INNER JOIN SeniorHistoricoAfastamentos_20241022_1409 aus
        ON aus.EMPLOYER = col.EMPRESA
            AND aus.EMPLOYEE = col.MATRICULA
    INNER JOIN OracleMapaAusencias map
        ON map.INTEGRACAO_SENIOR = aus.CODIGO_SITUACAO_SENIOR
    WHERE 1 = 1
    )
    , AusenciasOracle
AS (
    SELECT col.EMPRESA
        , col.MATRICULA
        , col.CPF
        , col.COLABORADOR
        , map.ORIGEM
        , aus.ABSENCE_TYPE_ID AUSENCIA_ID
        , map.TIPOS_AUSENCIA TIPO_AFASTAMENTO
        , aus.START_DATE DATA_INICIO
        , 'DATA_INICIO_ORACLE' PVT_DATA_INICIO
        , NULL DATA_FIM_LG
        , aus.END_DATE DATA_FIM_ORACLE
        , NULL DATA_FIM_RSDATA
        , NULL DATA_FIM_SENIOR
        , NULL CID_LG
        , NULL CID_ORACLE
        , NULL CID_RSDATA
        , NULL CID_SENIOR
    FROM Colaborador col
    INNER JOIN AUSENCIAS_ORACLE_20241104_2059 aus
        ON aus.EMPLOYER = col.EMPRESA
            AND aus.EMPLOYEE = col.MATRICULA
    INNER JOIN OracleMapaAusencias map
        ON map.TIPOS_AUSENCIA = aus.NAME
    WHERE 1 = 1
    )
    , AusenciasRSData
AS (
    SELECT col.EMPRESA
        , col.MATRICULA
        , col.CPF
        , col.COLABORADOR
        , map.ORIGEM
        , map.AUSENCIA_ID
        , map.TIPOS_AUSENCIA TIPO_AFASTAMENTO
        , aus.DATA_INICIO
        , 'DATA_INICIO_RSDATA' PVT_DATA_INICIO
        , NULL DATA_FIM_LG
        , NULL DATA_FIM_ORACLE
        , AUS.DATA_FIM DATA_FIM_RSDATA
        , NULL DATA_FIM_SENIOR
        , NULL CID_LG
        , NULL CID_ORACLE
        , REPLACE(aus.CID,'.','') CID_RSDATA
        , NULL CID_SENIOR
    FROM Colaborador col
    INNER JOIN AUSENCIAS_RSDATA_20241104_1910 aus
        ON aus.EMPRESA = col.EMPRESA
            AND aus.MATRICULA = col.MATRICULA
    INNER JOIN OracleMapaAusencias map
        ON map.INTEGRACAO_RSDATA = (
                CASE 
                    WHEN aus.AUSENCIA_ID = '132'
                        THEN '14'
                    ELSE aus.AUSENCIA_ID
                    END
                )
    WHERE 1 = 1
    )
    , Ausencias
AS (
    --SELECT * FROM AusenciasLG UNION
    
    --SELECT * FROM AusenciasSenior UNION
    
    SELECT * FROM AusenciasOracle UNION
    
    SELECT * FROM AusenciasRSData
    )
    , Temporaria
AS (
    SELECT *
    FROM (
        SELECT EMPRESA
            , MATRICULA
            , CPF
            , COLABORADOR
            , ORIGEM
            , AUSENCIA_ID
            , TIPO_AFASTAMENTO
            , DATA_INICIO
            , PVT_DATA_INICIO
        FROM Ausencias
        ) RowData
    PIVOT(MAX(DATA_INICIO) FOR PVT_DATA_INICIO IN ([DATA_INICIO_LG], [DATA_INICIO_ORACLE], [DATA_INICIO_RSDATA], [DATA_INICIO_SENIOR])) PVT_COLLUMN
    )
SELECT tem.EMPRESA
    , tem.MATRICULA
    , tem.CPF
    , tem.COLABORADOR
    , tem.ORIGEM
    , tem.AUSENCIA_ID
    , tem.TIPO_AFASTAMENTO
    , tem.DATA_INICIO_LG
    , tem.DATA_INICIO_ORACLE
    , tem.DATA_INICIO_RSDATA
    , tem.DATA_INICIO_SENIOR
    , lga.DATA_FIM_LG
    , ora.DATA_FIM_ORACLE
    , rsd.DATA_FIM_RSDATA
    , sen.DATA_FIM_SENIOR
    , lga.CID_LG
    , ora.CID_ORACLE
    , rsd.CID_RSDATA
    , sen.CID_SENIOR
FROM Temporaria tem
LEFT JOIN AusenciasLG lga
    ON lga.EMPRESA = tem.EMPRESA
        AND lga.MATRICULA = tem.MATRICULA
        AND lga.AUSENCIA_ID = tem.AUSENCIA_ID
        AND lga.DATA_INICIO = tem.DATA_INICIO_LG
LEFT JOIN AusenciasOracle ora
    ON ora.EMPRESA = tem.EMPRESA
        AND ora.MATRICULA = tem.MATRICULA
        AND ora.AUSENCIA_ID = tem.AUSENCIA_ID
        AND ora.DATA_INICIO = tem.DATA_INICIO_ORACLE
LEFT JOIN AusenciasRSData rsd
    ON rsd.EMPRESA = tem.EMPRESA
        AND rsd.MATRICULA = tem.MATRICULA
        AND rsd.AUSENCIA_ID = tem.AUSENCIA_ID
        AND rsd.DATA_INICIO = tem.DATA_INICIO_RSDATA
LEFT JOIN AusenciasSenior sen
    ON sen.EMPRESA = tem.EMPRESA
        AND sen.MATRICULA = tem.MATRICULA
        AND sen.AUSENCIA_ID = tem.AUSENCIA_ID
        AND sen.DATA_INICIO = tem.DATA_INICIO_SENIOR
ORDER BY 1
    , 2
    , 3