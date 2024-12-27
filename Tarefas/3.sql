-- TAREFA 3: Unicidade de (tenant_id, institution_id, person_id) considerando institution_id pode ser nulo

CREATE UNIQUE INDEX ux_enrollment_tenant_institution_person
    ON enrollment (tenant_id, institution_id, person_id)
    WHERE institution_id IS NOT NULL;

CREATE UNIQUE INDEX ux_enrollment_tenant_person_null_institution
    ON enrollment (tenant_id, person_id)
    WHERE institution_id IS NULL;
