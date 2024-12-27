-- TAREFA 7: Particionamento da tabela enrollment

/*
    Sugestão de particionamento para a tabela enrollment, dividindo por ano de matrícula.
    Em um ambiente de produção, seria necessário avaliar o volume de dados e a frequência de consultas para definir a melhor estratégia de particionamento.
    Após isso, seria preciso criar as partições para cada ano e replicar as constraints e índices parciais para cada partição.
    O último passo seria mover os dados para as partições corretas, usando filtros na tabela principal anteriormente criada, para que sejam distribuídos corretamente.
*/

CREATE TABLE enrollment (
    id               UUID             PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id        UUID             NOT NULL,
    institution_id   UUID             NULL,
    person_id        UUID             NOT NULL,
    -- Incluir course_id se cada matrícula estiver vinculada a um curso dessa forma teriamos uma chave estrangeira para a tabela course trazendo uma performance melhor para a consulta
    course_id        UUID             NOT NULL,
    enrollment_date  DATE             NOT NULL,
    status           VARCHAR(20),
    -- Exclusão lógica implantada na tabela (Tarefa 4):
    deleted_at       TIMESTAMP        NULL,
    
    CONSTRAINT fk_enrollment_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenant(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    CONSTRAINT fk_enrollment_institution
        FOREIGN KEY (institution_id)
        REFERENCES institution(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    CONSTRAINT fk_enrollment_person
        FOREIGN KEY (person_id)
        REFERENCES person(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT

    -- Para que fique funcinal a inclusão do course_id:
    CONSTRAINT fk_enrollment_course
        FOREIGN KEY (course_id)
        REFERENCES course(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);
PARTITION BY RANGE (enrollment_date);

-- Partições para a tabela enrollment dividido anualmente

CREATE TABLE enrollment_2024 
    PARTITION OF enrollment
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE enrollment_2025
    PARTITION OF enrollment
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

 -- Particionamento default

CREATE TABLE enrollment_default
    PARTITION OF enrollment
    DEFAULT;

-- Caso seja necessário fazer uma replica das constraints que sejam parciais para cada partição, o mesmo pode ser aplicado para indices.