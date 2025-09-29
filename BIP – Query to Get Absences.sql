select
  ABSENCE_TYPE_ID,
  ANC_ABSENCE_TYPES_F_ALTCD,
  NAME,
  ATTRIBUTE1,
  ATTRIBUTE2,
  BASE_NAME,
  CREATED_BY
from
  anc_absence_types_vl
where
  sysdate between EFFECTIVE_START_DATE
  and EFFECTIVE_END_DATE
  and LANGUAGE = USERENV('LANG')
  and NAME = 'Afastamento INSS - Auxilio Doença'
  