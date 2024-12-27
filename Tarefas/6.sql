-- TAREFA 6: Query que retorne os alunos de um curso em uma tenant e institution específicos

/*
    Essa query retorna os alunos de um curso em uma tenant e institution específicos utilizando os campos filtrados no where e trazendo apenas registros validos (deleted_at IS NULL).
*/

SELECT 
    p.id              AS person_id,
    p.name            AS person_name,
    p.birth_date      AS person_birth_date,
    e.enrollment_date AS enrollment_date,
    e.status          AS enrollment_status
FROM enrollment e
JOIN person p
    ON e.person_id = p.id 
WHERE e.tenant_id = :tenant_id 
    AND e.institution_id = :institution_id
    AND e.course_id = :course_id
    AND e.deleted_at IS NULL
ORDER BY p.name
LIMIT :limit