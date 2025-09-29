select * from(select HAPF.POSITION_ID
,HAPF.POSITION_CODE
,HAPFTL.NAME POSITION_NAME
,HBP.PROFILE_ID PPROFILEID
 
,REPLACE(REPLACE(REPLACE (
                   REGEXP_REPLACE(REGEXP_REPLACE (
                      REGEXP_REPLACE (REPLACE (REPLACE (HPEITLP.DESCRIPTION
                                                       ,'&lt;'
                                                       ,'<')
                                              ,'&gt;'
                                              ,'>')
                                     ,'<[^>]*>|amp;amp;nbsp;|nbsp;'
                                     ,'')
                     ,'\&'
                      || 'amp;'
                     ,''),'bull;','-')
                  ,'&'
                  ,''),'<p>',''),'</p>','') as Position_Description
,REPLACE(REPLACE(REPLACE (
                   REGEXP_REPLACE(REGEXP_REPLACE (
                      REGEXP_REPLACE (REPLACE (REPLACE (HPEITLP.RESPONSIBILITIES
                                                       ,'&lt;'
                                                       ,'<')
                                              ,'&gt;'
                                              ,'>')
                                     ,'<[^>]*>|amp;amp;nbsp;|nbsp;'
                                     ,'')
                     ,'\&'
                      || 'amp;'
                     ,''),'bull;','-')
                  ,'&'
                  ,''),'<p>',''),'</p>','') as POSITION_RESPONSIBILITIES
,REPLACE(REPLACE(REPLACE (
                   REGEXP_REPLACE(REGEXP_REPLACE (
                      REGEXP_REPLACE (REPLACE (REPLACE (HPEITLP.QUALIFICATIONS
                                                       ,'&lt;'
                                                       ,'<')
                                              ,'&gt;'
                                              ,'>')
                                     ,'<[^>]*>|amp;amp;nbsp;|nbsp;'
                                     ,'')
                     ,'\&'
                      || 'amp;'
                     ,''),'bull;','-')
                  ,'&'
                  ,''),'<p>',''),'</p>','') as Position_QUALIFICATIONS
 
 
from HR_ALL_POSITIONS_F HAPF
,HR_ALL_POSITIONS_F_TL HAPFTL
,HRT_PROFILE_RELATIONS RLP
,HRT_PROFILES_B HBP
,HRT_PROFILES_TL HTLP
,HRT_PROFILE_EXTRA_INFO_B HPEBP
,HRT_PROFILE_EXTRA_INFO_TL HPEITLP
 
where 1=1
AND HAPF.POSITION_ID=HAPFTL.POSITION_ID(+)
AND RLP.OBJECT_ID=HAPF.POSITION_ID(+)
AND RLP.PROFILE_ID=HBP.PROFILE_ID(+)
AND HBP.PROFILE_ID=HTLP.PROFILE_ID(+)
AND HBP.PROFILE_ID=HPEBP.PROFILE_ID(+)
AND HBP.PROFILE_USAGE_CODE='M'
AND HPEBP.PROFILE_EXTRA_INFO_ID=HPEITLP.PROFILE_EXTRA_INFO_ID(+)
AND HPEITLP.LANGUAGE = USERENV('LANG')
 
 
AND trunc(SYSDATE) between HAPF.EFFECTIVE_START_DATE(+) and HAPF.EFFECTIVE_END_DATE(+)
AND trunc(SYSDATE) between HAPFTL.EFFECTIVE_START_DATE(+) and HAPFTL.EFFECTIVE_END_DATE(+)
order by HPEITLP.OBJECT_VERSION_NUMBER desc)