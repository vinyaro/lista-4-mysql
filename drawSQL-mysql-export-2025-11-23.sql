CREATE TABLE `ESTUDANTE`(
    `Matricula` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Nome` VARCHAR(150) NOT NULL DEFAULT 'NOT_NULL',
    `DataNascimento` DATE NOT NULL,
    `Endereço` VARCHAR(150) NOT NULL,
    `EscolaAnterior` VARCHAR(100) NOT NULL,
    `ID_Responsavel` INT NOT NULL,
    `ID_Turma` CHAR(10) NOT NULL
);
CREATE TABLE `RESPONSAVEL`(
    `ID_Responsavel` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Nome` VARCHAR(150) NOT NULL,
    `Telefone` BIGINT NOT NULL,
    `CPF` VARCHAR(14) NOT NULL
);
ALTER TABLE
    `RESPONSAVEL` ADD UNIQUE `responsavel_cpf_unique`(`CPF`);
CREATE TABLE `ANO_LETIVO`(
    `Ano` INT UNSIGNED NOT NULL,
    `DataInicio` DATE NOT NULL,
    `DataFim` DATE NOT NULL,
    PRIMARY KEY(`Ano`)
);
CREATE TABLE `TURMA`(
    `ID_Turma` CHAR(10) NOT NULL,
    `NomeTurma` VARCHAR(150) NOT NULL,
    `Ano` INT NOT NULL,
    PRIMARY KEY(`ID_Turma`)
);
CREATE TABLE `DISCIPLINA`(
    `Cod_Disciplina` CHAR(10) NOT NULL,
    `NomeDisciplina` VARCHAR(150) NOT NULL,
    `CargaHorario` INT NOT NULL,
    PRIMARY KEY(`Cod_Disciplina`)
);
CREATE TABLE `OCORRENCIA`(
    `ID_Ocorrencia` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `Tipo` VARCHAR(50) NOT NULL,
    `DataOcorrencia` DATE NOT NULL,
    `Descricao` TEXT NOT NULL,
    `Matricula` INT NOT NULL
);
CREATE TABLE `TURMA_DISCIPLINA`(
    `ID_Turma` CHAR(10) NOT NULL,
    `Cod_Disciplina` CHAR(10) NOT NULL,
    `NomeProfessor` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`ID_Turma`)
);
ALTER TABLE
    `TURMA_DISCIPLINA` ADD PRIMARY KEY(`Cod_Disciplina`);
CREATE TABLE `DESEMPENHO`(
    `Matricula` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `Cod_Disciplina` CHAR(10) NOT NULL,
    `Trimestre` INT NOT NULL,
    `NotaFinal` DECIMAL(4, 2) NOT NULL,
    `Frequencia` DECIMAL(5, 2) NOT NULL,
    PRIMARY KEY(`Cod_Disciplina`)
);
ALTER TABLE
    `DESEMPENHO` ADD PRIMARY KEY(`Trimestre`);
ALTER TABLE
    `ESTUDANTE` ADD CONSTRAINT `estudante_matricula_foreign` FOREIGN KEY(`Matricula`) REFERENCES `DESEMPENHO`(`Matricula`);
ALTER TABLE
    `OCORRENCIA` ADD CONSTRAINT `ocorrencia_matricula_foreign` FOREIGN KEY(`Matricula`) REFERENCES `ESTUDANTE`(`Matricula`);
ALTER TABLE
    `DISCIPLINA` ADD CONSTRAINT `disciplina_cod_disciplina_foreign` FOREIGN KEY(`Cod_Disciplina`) REFERENCES `DESEMPENHO`(`Cod_Disciplina`);
ALTER TABLE
    `DISCIPLINA` ADD CONSTRAINT `disciplina_cod_disciplina_foreign` FOREIGN KEY(`Cod_Disciplina`) REFERENCES `TURMA_DISCIPLINA`(`ID_Turma`);
ALTER TABLE
    `ESTUDANTE` ADD CONSTRAINT `estudante_matricula_foreign` FOREIGN KEY(`Matricula`) REFERENCES `RESPONSAVEL`(`ID_Responsavel`);
ALTER TABLE
    `TURMA` ADD CONSTRAINT `turma_ano_foreign` FOREIGN KEY(`Ano`) REFERENCES `ANO_LETIVO`(`Ano`);
ALTER TABLE
    `TURMA_DISCIPLINA` ADD CONSTRAINT `turma_disciplina_id_turma_foreign` FOREIGN KEY(`ID_Turma`) REFERENCES `TURMA`(`ID_Turma`);