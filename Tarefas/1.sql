-- TAREFA 1: Criação das tabelas + Exclusão Lógica na tabela enrollment

-- Passo opcional (caso ainda não esteja habilitado para ser utilizado):
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE tenant (
    id          UUID                PRIMARY KEY DEFAULT uuid_generate_v4(),
    name        VARCHAR(100)        NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE person (
    id         UUID                 PRIMARY KEY DEFAULT uuid_generate_v4(),
    name       VARCHAR(100)        NOT NULL,
    birth_date DATE,
    metadata   JSONB
);

CREATE TABLE institution (
    id         UUID                 PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id  UUID                 NOT NULL,
    name       VARCHAR(100)         NOT NULL,
    location   VARCHAR(100),
    details    JSONB,
    
    CONSTRAINT fk_institution_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenant(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE course (
    id              UUID             PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id       UUID             NOT NULL,
    institution_id  UUID             NOT NULL,
    name            VARCHAR(100)     NOT NULL,
    duration        INT,
    details         JSONB,
    
    CONSTRAINT fk_course_tenant
        FOREIGN KEY (tenant_id)
        REFERENCES tenant(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
        
    CONSTRAINT fk_course_institution
        FOREIGN KEY (institution_id)
        REFERENCES institution(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE enrollment (
    id               UUID             PRIMARY KEY DEFAULT uuid_generate_v4(),
    tenant_id        UUID             NOT NULL,
    institution_id   UUID             NULL,
    person_id        UUID             NOT NULL,
    -- Incluir course_id se cada matrícula estiver vinculada a um curso dessa forma teriamos uma chave estrangeira para a tabela course trazendo uma performance melhor para a consulta
    course_id       UUID             NOT NULL,
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

