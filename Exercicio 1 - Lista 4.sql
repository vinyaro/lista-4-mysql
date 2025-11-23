-- ### Exercício 1
-- Execute todos os passos apresentados no estudo, partindo de um modelo vazio,
-- criando as tabelas e conectando com o mysql. Ao final do processo, verifique o banco
-- criado no seu mysql. Insira dados para testes.**

-- Não modelei os dados usando o WorkBench

-- Utilizei o DrawSQL em conta gratuita, por isso a exportação não é completa 
-- a conta gratuita dá acesso apenas a relações 1:1 1:N N:1
-- a conta gratuita também não exporta chave composta (primary key formada a partir de 2 colunas)

-- Abaixo o DDL

-- DDL CORRIGIDO: Estudante / Disciplina / Telefone
CREATE DATABASE EstudanteDisciplina;
USE EstudanteDisciplina;
-- 1. Criação das Tabelas
-- Tabela Estudante
CREATE TABLE `Estudante` (
    `CPF` INT UNSIGNED NOT NULL PRIMARY KEY, -- PK
    `Nome` VARCHAR(45) NULL,
    `NumMatricula` CHAR(11) NULL
);

-- Tabela Disciplina
CREATE TABLE `Disciplina` (
    `ID_Disciplina` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, -- PK (com auto-incremento)
    `Nome` VARCHAR(45) NULL,
    `ID_Departamento` INT NULL
);

-- Tabela Telefone - Permite N telefones por aluno
CREATE TABLE `Telefone` (
    `ID_Telefone` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Telefone` VARCHAR(45) NULL,
    `EstudanteCpf` INT UNSIGNED NOT NULL, -- FK
    -- PK Composta: O Telefone é único, mas a chave lógica permite N telefones por CPF
    PRIMARY KEY(`ID_Telefone`, `EstudanteCpf`), 
    FOREIGN KEY(`EstudanteCpf`) REFERENCES `Estudante`(`CPF`)
);

-- Tabela Associativa Disciplina_Tem_Estudante -> N:M
CREATE TABLE `Disciplina_Tem_Estudante` (
    `Disciplina_ID_Disciplina` INT UNSIGNED NOT NULL, -- PK, FK
    `EstudanteCpf` INT UNSIGNED NOT NULL, -- PK, FK
    
    -- Chave Primária COMPOSTA: Garante que um par (Disciplina, Estudante) seja único
    PRIMARY KEY(`Disciplina_ID_Disciplina`, `EstudanteCpf`), 
    
    -- Chaves Estrangeiras (Relações 1:N com as tabelas pais)
    FOREIGN KEY(`Disciplina_ID_Disciplina`) REFERENCES `Disciplina`(`ID_Disciplina`),
    FOREIGN KEY(`EstudanteCpf`) REFERENCES `Estudante`(`CPF`)
);

-- DML: Inserção de dados para teste do modelo Estudante/Disciplina/Telefone

-- ---------------------------------
-- 1. Tabelas Pai (Estudante e Disciplina)
-- ---------------------------------

-- Estudante (Tabela Pai - PK: CPF)
-- Usamos CPF como PK, então ele deve ser fornecido.
INSERT INTO estudante (CPF, Nome, NumMatricula) VALUES
(12345678901, 'João da Silva', '20240001'),
(98765432109, 'Maria Oliveira', '20240002');

-- Disciplina (Tabela Pai - PK: ID_Disciplina)
-- Como é AUTO_INCREMENT, podemos omitir o ID para que o MySQL o forneça.
INSERT INTO disciplina (Nome, ID_Departamento) VALUES
('Programação Web', 10),
('Banco de Dados I', 10),
('Cálculo I', 20);

-- ---------------------------------
-- 2. Tabela Filha (Telefone)
-- ---------------------------------

-- Telefone (PK Composta: ID_Telefone, EstudanteCpf)
-- João da Silva (CPF 12345678901) com dois telefones.
INSERT INTO telefone (Telefone, EstudanteCpf) VALUES
('31988887777', 12345678901), -- Telefone 1
('3133334444', 12345678901), -- Telefone 2
-- Maria Oliveira (CPF 98765432109) com um telefone.
('31977776666', 98765432109);

-- ---------------------------------
-- 3. Tabela Associativa (N:M)
-- ---------------------------------

-- Disciplina_Tem_Estudante (PK Composta: ID_Disciplina, EstudanteCpf)
-- Assumindo que:
-- 1 = Programação Web; 2 = Banco de Dados I; 3 = Cálculo I
-- 12345678901 = João; 98765432109 = Maria

INSERT INTO disciplina_tem_estudante (Disciplina_ID_Disciplina, EstudanteCpf) VALUES
-- João cursa Programação Web (1) e Banco de Dados (2)
(1, 12345678901),
(2, 12345678901),
-- Maria cursa Banco de Dados (2) e Cálculo (3)
(2, 98765432109),
(3, 98765432109);

-- ---------------------------------
-- 4. CONSULTA DE TESTE (JOIN)
-- ---------------------------------

-- Testar o relacionamento N:M: Quais alunos estão em qual disciplina?
SELECT 
    E.Nome AS Nome_Aluno,
    D.Nome AS Nome_Disciplina
FROM
    estudante E
JOIN
    disciplina_tem_estudante T ON E.CPF = T.EstudanteCpf
JOIN
    disciplina D ON T.Disciplina_ID_Disciplina = D.ID_Disciplina
ORDER BY
    E.Nome, D.Nome;