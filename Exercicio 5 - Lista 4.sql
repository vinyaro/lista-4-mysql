-- EXERCICIO 5
-- Crie o modelo ER (diagrama DER) para um banco de dados de uma escola (bem simplificado)
-- O modelo conceitual deve ter tratar as informações pessoais (responsáveis, endereço, dados de idade, escola anterior, etc.) e acadêmicas dos estudantes. 
-- Deve conter informações do ano letivo, das disciplinas cursadas, das ocorrências do aluno na escola. O sistema que será criado deve prever informações trimestrais do desempenho do aluno. 
-- Deve-se ter um sistema para registro de notas e frequências. Fica a cargo do projetistas fazer a concepção do modelo conceitual e gerar o DER.
-- Uma vez gerado o DER, use o MysqlWorkBench para criar o modelo relacional
-- A partir do modelo relacional, crie o banco de dados usando o processo de “Forward Engineer” do MysqlWorkBench
-- Conecte com seu mysql (ou, opcionalmente com o mysql da máquina newton) e crie o banco.
-- Insira dados e faça testes

-- CRIAÇÃO DE BANCO DE DADOS

CREATE DATABASE IF NOT EXISTS EscolaDB_Lista4;
USE EscolaDB_Lista4;

CREATE TABLE RESPONSAVEL (
    ID_Responsavel INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(150) NOT NULL,
    Telefone BIGINT,
    CPF VARCHAR(14) NOT NULL UNIQUE
);

CREATE TABLE ANO_LETIVO (
    Ano INT NOT NULL PRIMARY KEY,
    DataInicio DATE NOT NULL,
    DataFim DATE NOT NULL
);

CREATE TABLE TURMA (
    ID_Turma CHAR(10) NOT NULL PRIMARY KEY,
    NomeTurma VARCHAR(150),
    Ano INT NOT NULL,
    FOREIGN KEY (Ano) REFERENCES ANO_LETIVO(Ano)
);

CREATE TABLE DISCIPLINA (
    Cod_Disciplina CHAR(10) NOT NULL PRIMARY KEY,
    NomeDisciplina VARCHAR(150),
    CargaHoraria INT NOT NULL
);

CREATE TABLE ESTUDANTE (
    Matricula INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(150) NOT NULL,
    DataNascimento DATE NOT NULL,
    Endereco VARCHAR(255) NOT NULL,
    EscolaAnterior VARCHAR(100),
    ID_Responsavel INT NOT NULL,
    ID_Turma CHAR(10) NOT NULL,
    FOREIGN KEY (ID_Responsavel) REFERENCES RESPONSAVEL(ID_Responsavel),
    FOREIGN KEY (ID_Turma) REFERENCES TURMA(ID_Turma)
);

CREATE TABLE OCORRENCIA (
    ID_Ocorrencia INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    Tipo VARCHAR(50) NOT NULL,
    DataOcorrencia DATE NOT NULL,
    Descricao TEXT NOT NULL,
    Matricula INT NOT NULL,
    FOREIGN KEY (Matricula) REFERENCES ESTUDANTE(Matricula)
);

CREATE TABLE TURMA_DISCIPLINA (
    ID_Turma CHAR(10) NOT NULL,
    Cod_Disciplina CHAR(10) NOT NULL,
    NomeProfessor VARCHAR(150) NOT NULL,
    -- PK Composta
    PRIMARY KEY(ID_Turma, Cod_Disciplina),
    FOREIGN KEY (ID_Turma) REFERENCES TURMA(ID_Turma),
    FOREIGN KEY (Cod_Disciplina) REFERENCES DISCIPLINA(Cod_Disciplina)
);

CREATE TABLE DESEMPENHO (
    Matricula INT NOT NULL,
    Cod_Disciplina CHAR(10) NOT NULL,
    Trimestre INT NOT NULL,
    NotaFinal DECIMAL(4, 2) NOT NULL,
    Frequencia DECIMAL(5, 2) NOT NULL,
    -- PK Composta
    PRIMARY KEY(Matricula, Cod_Disciplina, Trimestre),
    FOREIGN KEY (Matricula) REFERENCES ESTUDANTE(Matricula),
    FOREIGN KEY (Cod_Disciplina) REFERENCES DISCIPLINA(Cod_Disciplina)
);

-- INSERÇÃO DE DADOS

USE EscolaDB_Lista4;

-- 1. RESPONSAVEL
INSERT INTO RESPONSAVEL (ID_Responsavel, Nome, Telefone, CPF) VALUES
(1, 'Joana Santos', 31987654321, '12345678901'),
(2, 'Pedro Almeida', 31998765432, '98765432109');

-- 2. ANO_LETIVO
INSERT INTO ANO_LETIVO (Ano, DataInicio, DataFim) VALUES
(2024, '2024-02-05', '2024-12-15');

-- 3. DISCIPLINA
INSERT INTO DISCIPLINA (Cod_Disciplina, NomeDisciplina, CargaHoraria) VALUES
('MAT101', 'Matemática I', 80),
('PORT101', 'Português I', 80),
('HIS101', 'História I', 60);

-- 4. TURMA
INSERT INTO TURMA (ID_Turma, NomeTurma, Ano) VALUES
('1A_2024', '1º Ano A', 2024),
('1B_2024', '1º Ano B', 2024);

-- 5. TURMA_DISCIPLINA
INSERT INTO TURMA_DISCIPLINA (ID_Turma, Cod_Disciplina, NomeProfessor) VALUES
('1A_2024', 'MAT101', 'Prof. Ana Lima'),
('1A_2024', 'PORT101', 'Prof. Carlos Braga'),
('1B_2024', 'MAT101', 'Prof. Ana Lima'),
('1B_2024', 'HIS101', 'Prof. Maria Souza');

-- 6. ESTUDANTE
INSERT INTO ESTUDANTE (Matricula, Nome, DataNascimento, Endereco, EscolaAnterior, ID_Responsavel, ID_Turma) VALUES
(1001, 'Alice Pereira', '2010-03-15', 'Rua A, 100', 'Escola X', 1, '1A_2024'),
(1002, 'Bruno Costa', '2010-09-22', 'Av. Central, 50', 'Escola Y', 2, '1A_2024'),
(1003, 'Cíntia Alves', '2009-11-10', 'Rua B, 20', 'Escola Z', 1, '1B_2024');]

-- 7. DESEMPENHO

-- Alice (1001) em Matemática (MAT101)
-- 1º Trimestre
INSERT INTO DESEMPENHO (Matricula, Cod_Disciplina, Trimestre, NotaFinal, Frequencia) VALUES
(1001, 'MAT101', 1, 8.50, 95.00);

-- 2º Trimestre (Mesma disciplina, mesmo aluno, TRIMESTRE DIFERENTE: OK)
INSERT INTO DESEMPENHO (Matricula, Cod_Disciplina, Trimestre, NotaFinal, Frequencia) VALUES
(1001, 'MAT101', 2, 7.80, 90.00); 

-- Alice (1001) em Português (PORT101)
-- 1º Trimestre (Disciplina diferente, mesmo aluno: OK)
INSERT INTO DESEMPENHO (Matricula, Cod_Disciplina, Trimestre, NotaFinal, Frequencia) VALUES
(1001, 'PORT101', 1, 9.20, 98.00);

-- TESTE DE FALHA: Tentar inserir a mesma nota no 1º trimestre novamente (DEVE FALHAR!)
-- Este comando irá falhar, prova que sua chave primária composta está funcionando.
INSERT INTO DESEMPENHO (Matricula, Cod_Disciplina, Trimestre, NotaFinal, Frequencia) VALUES
(1001, 'MAT101', 1, 6.00, 80.00);

-- CONSULTA #1
-- RELATÓRIO DE DESEMPENHO DO 2º TRIMESTRE

SELECT
    E.Nome AS Nome_Aluno,
    D.NomeDisciplina,
    P.Trimestre,
    P.NotaFinal,
    P.Frequencia
FROM
    ESTUDANTE E
JOIN
    DESEMPENHO P ON E.Matricula = P.Matricula -- Junta Aluno com Desempenho
JOIN
    DISCIPLINA D ON P.Cod_Disciplina = D.Cod_Disciplina -- Junta Desempenho com Disciplina
WHERE
    P.Trimestre = 2;

-- INSERIR DADOS DE TESTE NA TABELA OCORRENCIA

INSERT INTO OCORRENCIA (Tipo, DataOcorrencia, Descricao, Matricula) VALUES
('Comportamental', '2024-03-20', 'Atraso na entrada da aula de Português.', 1001),
('Disciplinar', '2024-04-10', 'Uso inadequado do celular em sala.', 1002);

-- CONSULTA #2
-- CONSULTA DE OCORRÊNCIAS

SELECT
    O.DataOcorrencia,
    O.Tipo AS Tipo_Ocorrencia,
    E.Nome AS Nome_Aluno,
    R.Nome AS Nome_Responsavel,
    R.Telefone AS Contato_Responsavel
FROM
    OCORRENCIA O
JOIN
    ESTUDANTE E ON O.Matricula = E.Matricula -- Junta Ocorrência com Aluno
JOIN
    RESPONSAVEL R ON E.ID_Responsavel = R.ID_Responsavel; -- Junta Aluno com Responsável