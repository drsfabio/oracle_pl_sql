SELECT
  *
FROM
  (
    SELECT
      AllPositionsTranslate.LANGUAGE,
      AllPositions.POSITION_CODE,
      AllPositionsTranslate.NAME,
      AllOrganizationUnits.INTERNAL_ADDRESS_LINE,
      OrganizationDepartment.NAME DEPARTMENT_NAME,
      REGEXP_SUBSTR(AllPositions.POSITION_CODE, '\d+', 1, 2) ESTABLISHMENT_CODE,
      Establishment.ESTABLISHMENT_NAME,
      Establishment.REGISTRATION_NUMBER,
      AllPositions.UNION_ID,
      PerJobs.JOB_CODE,
      PerJobs.NAME AS JOB_NAME,
      AllPositions.COST_CENTER,
      AllPositions.FTE,
      AllPositions.ATTRIBUTE2 AS CATEGORY_ESOCIAL,
      AllPositions.ATTRIBUTE4 AS ESCALA,
      AllPositions.HIRING_STATUS,
      AllPositions.POSITION_TYPE
    FROM
      HR_ALL_POSITIONS_F AllPositions
      INNER JOIN HR_ALL_POSITIONS_F_TL AllPositionsTranslate ON AllPositionsTranslate.POSITION_ID = AllPositions.POSITION_ID
      AND AllPositionsTranslate.LANGUAGE = USERENV('LANG')
      AND TRUNC(SYSDATE) BETWEEN AllPositionsTranslate.EFFECTIVE_START_DATE
      AND AllPositionsTranslate.EFFECTIVE_END_DATE
      LEFT JOIN HR_ALL_ORGANIZATION_UNITS_F OrganizationUnitsEstablishment ON OrganizationUnitsEstablishment.ORGANIZATION_ID = AllPositions.ORGANIZATION_ID
      AND LENGTH(OrganizationUnitsEstablishment.ESTABLISHMENT_ID) > 0
      LEFT JOIN XLE_ESTABLISHMENT_V Establishment ON Establishment.REGISTRATION_NUMBER = AllPositions.ATTRIBUTE19
      AND Establishment.MAIN_ESTABLISHMENT_FLAG = 'N'
      LEFT JOIN PER_JOBS PerJobs ON PerJobs.JOB_ID = AllPositions.JOB_ID
      AND SYSDATE BETWEEN PerJobs.EFFECTIVE_START_DATE
      AND PerJobs.EFFECTIVE_END_DATE
      LEFT JOIN HR_ALL_ORGANIZATION_UNITS_F AllOrganizationUnits ON AllOrganizationUnits.ORGANIZATION_ID = AllPositions.ORGANIZATION_ID
      AND SYSDATE BETWEEN AllOrganizationUnits.EFFECTIVE_START_DATE
      AND AllOrganizationUnits.EFFECTIVE_END_DATE
      LEFT JOIN HR_ORGANIZATION_V OrganizationDepartment ON OrganizationDepartment.ORGANIZATION_ID = AllPositions.ORGANIZATION_ID
      AND SYSDATE BETWEEN OrganizationDepartment.EFFECTIVE_START_DATE
      AND OrganizationDepartment.EFFECTIVE_END_DATE
    WHERE
      TRUNC(SYSDATE) BETWEEN AllPositions.EFFECTIVE_START_DATE
      AND AllPositions.EFFECTIVE_END_DATE
  ) Positions