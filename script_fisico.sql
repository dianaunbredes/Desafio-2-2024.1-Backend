-- SCRIPT FÍSICO - DETRAN (MySQL 8)
DROP DATABASE IF EXISTS detran;
CREATE DATABASE detran CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE detran;

CREATE TABLE proprietario (
    cpf             CHAR(11)     NOT NULL,
    nome            VARCHAR(100) NOT NULL,
    endereco        VARCHAR(150) NOT NULL,
    bairro          VARCHAR(60)  NOT NULL,
    cidade          VARCHAR(60)  NOT NULL,
    estado          CHAR(2)      NOT NULL,
    sexo            CHAR(1)      NOT NULL,
    data_nascimento DATE         NOT NULL,
    CONSTRAINT pk_proprietario PRIMARY KEY (cpf),
    CONSTRAINT ck_prop_sexo CHECK (sexo IN ('M','F'))
);

CREATE TABLE telefone_proprietario (
    id_telefone INT         NOT NULL AUTO_INCREMENT,
    cpf         CHAR(11)    NOT NULL,
    telefone    VARCHAR(15) NOT NULL,
    CONSTRAINT pk_telefone PRIMARY KEY (id_telefone),
    CONSTRAINT fk_tel_prop FOREIGN KEY (cpf) REFERENCES proprietario (cpf)
);

CREATE TABLE modelo (
    codigo_modelo CHAR(6)      NOT NULL,
    descricao     VARCHAR(60)  NOT NULL,
    CONSTRAINT pk_modelo PRIMARY KEY (codigo_modelo)
);

CREATE TABLE categoria (
    codigo_categoria CHAR(2)     NOT NULL,
    descricao        VARCHAR(40) NOT NULL,
    CONSTRAINT pk_categoria PRIMARY KEY (codigo_categoria)
);

CREATE TABLE veiculo (
    placa            CHAR(7)     NOT NULL,
    chassi           CHAR(17)    NOT NULL,
    cor_predominante VARCHAR(30) NOT NULL,
    ano_fabricacao   SMALLINT    NOT NULL,
    codigo_modelo    CHAR(6)     NOT NULL,
    codigo_categoria CHAR(2)     NOT NULL,
    cpf_proprietario CHAR(11)    NOT NULL,
    CONSTRAINT pk_veiculo PRIMARY KEY (placa),
    CONSTRAINT uq_veiculo_chassi UNIQUE (chassi),
    CONSTRAINT fk_vei_modelo FOREIGN KEY (codigo_modelo) REFERENCES modelo (codigo_modelo),
    CONSTRAINT fk_vei_categoria FOREIGN KEY (codigo_categoria) REFERENCES categoria (codigo_categoria),
    CONSTRAINT fk_vei_prop FOREIGN KEY (cpf_proprietario) REFERENCES proprietario (cpf)
);

CREATE TABLE tipo_infracao (
    codigo_tipo INT           NOT NULL,
    descricao   VARCHAR(100)  NOT NULL,
    valor       DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_tipo_infracao PRIMARY KEY (codigo_tipo),
    CONSTRAINT ck_tipo_valor CHECK (valor > 0)
);

CREATE TABLE local_infracao (
    latitude           DECIMAL(9,6) NOT NULL,
    longitude          DECIMAL(9,6) NOT NULL,
    velocidade_permitida SMALLINT   NULL,
    CONSTRAINT pk_local PRIMARY KEY (latitude, longitude)
);

CREATE TABLE agente (
    matricula        INT          NOT NULL,
    nome             VARCHAR(100) NOT NULL,
    data_contratacao DATE         NOT NULL,
    CONSTRAINT pk_agente PRIMARY KEY (matricula)
);

CREATE TABLE infracao (
    id_infracao       INT          NOT NULL AUTO_INCREMENT,
    placa             CHAR(7)      NOT NULL,
    data_hora         DATETIME     NOT NULL,
    codigo_tipo       INT          NOT NULL,
    latitude          DECIMAL(9,6) NOT NULL,
    longitude         DECIMAL(9,6) NOT NULL,
    velocidade_afetada SMALLINT    NULL,
    matricula_agente  INT          NOT NULL,
    CONSTRAINT pk_infracao PRIMARY KEY (id_infracao),
    CONSTRAINT uq_infracao UNIQUE (placa, data_hora),
    CONSTRAINT fk_inf_veiculo FOREIGN KEY (placa) REFERENCES veiculo (placa),
    CONSTRAINT fk_inf_tipo FOREIGN KEY (codigo_tipo) REFERENCES tipo_infracao (codigo_tipo),
    CONSTRAINT fk_inf_local FOREIGN KEY (latitude, longitude) REFERENCES local_infracao (latitude, longitude),
    CONSTRAINT fk_inf_agente FOREIGN KEY (matricula_agente) REFERENCES agente (matricula)
);

-- Atributos derivados (idade e tempo de serviço) calculados em views
CREATE VIEW vw_proprietario AS
SELECT p.*, TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) AS idade
FROM proprietario p;

CREATE VIEW vw_agente AS
SELECT a.*, TIMESTAMPDIFF(MONTH, data_contratacao, CURDATE()) AS tempo_servico_meses
FROM agente a;
