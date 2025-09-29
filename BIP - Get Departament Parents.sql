SELECT  
        tree.parent_pk1_value
       ,tree.pk1_start_value
       ,dpai.name dpto_pai
       ,dfilho.name dpto_filho
FROM    
        per_dept_tree_node tree
        LEFT OUTER JOIN
                hr_organization_v dpai
        ON      dpai.organization_id = tree.parent_pk1_value
        LEFT OUTER JOIN
                hr_organization_v dfilho
        ON      dfilho.organization_id = tree.pk1_start_value
where dpai.name LIKE '%Administracao E-commerce%'
ORDER BY 
        tree.parent_pk1_value;