-- TAREFA 5: Query de busca de matrículas por curso em uma determinada instituição

/*
    Essa query filtra o tenant_id e institution_id obrigatoriamente, dessa forma podemos ir para a segunda parte que seria buscar no campo de metadata da tabela person os registros que estão dentro do JSONB correspondendo ao texto pesquisado.
    Também foi implantado o filtro por e.deleted_at IS NULL para trazer somente registros válidos.
    
*/

SELECT
    c.id        AS course_id,
    c.name      AS course_name,
    COUNT(e.id) AS total_enrollments
FROM enrollment e
JOIN person p
    ON e.person_id = p.id
JOIN course c
    ON e.course_id = c.id
WHERE e.tenant_id = :tenant_id
    AND e.institution_id = :institution_id
    AND e.deleted_at IS NULL
    AND to_tsvector('portuguese', p.metadata:text) @@ to_tsquery('portuguese', :searchQuery)
GROUP BY c.id, c.name
ORDER BY c.name;