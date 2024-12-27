-- TAREFA 2: Construção de índices essenciais

-- Índice GIN para pesquisa no JSONB da tabela person (campo metadata)
CREATE INDEX idx_person_metadata_gin
    ON person USING GIN (metadata jsonb_path_ops);

-- Índice em institution(tenant_id)
CREATE INDEX idx_institution_tenant
    ON institution (tenant_id);

-- Índice em course(tenant_id, institution_id)
CREATE INDEX idx_course_tenant_institution
    ON course (tenant_id, institution_id);

-- Para a tabela enrollment, um índice em enrollment_date pois é um campo que pode ser utilizado em consultas frequentes.
CREATE INDEX idx_enrollment_date
    ON enrollment (enrollment_date);

-- Índice parcial para registros ativos (deleted_at IS NULL).
CREATE INDEX idx_enrollment_tenant_institution_not_deleted
    ON enrollment (tenant_id, institution_id)
    WHERE deleted_at IS NULL;

