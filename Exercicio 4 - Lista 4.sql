-- EXERCÍCIO 4
-- Melhore o modelo do estudo de caso (Estudante/Disciplina) 
-- criando a entidade departamento e associando a ela disciplinas. 
-- Cada departamento deve ser responsável por N disciplinas. 
-- E cada disciplina só pode ser ofertada por um departamento específico. 
-- Fica a cargo do projetista definir os atributos e relacionamentos necessários. 
-- Implemente o modelo ER, Lógico (MysqlWorkbench) e Físico (mysql)

-- Criar a Tabela
-- DDL para a nova tabela 'departamento'
USE EstudanteDisciplina_Ex2; -- Ou o nome do seu banco

CREATE TABLE `departamento` (
    `id_departamento` INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `nome_departamento` VARCHAR(100) NOT NULL,
    `localizacao` VARCHAR(100) NULL
);

-- Adicionar a Restrição de Chave Estrangeira na disciplina
-- DDL: Adiciona a FK na tabela 'disciplina'

ALTER TABLE disciplina
ADD CONSTRAINT fk_disciplina_departamento
FOREIGN KEY (ID_Departamento)
REFERENCES departamento(id_departamento)
ON DELETE RESTRICT -- Impede a exclusão de um departamento se houver disciplinas ativas
ON UPDATE CASCADE; -- Atualiza o ID na disciplina se o ID do departamento for alterado

-- Teste de Inserção
-- DML: Inserir novos departamentos

INSERT INTO departamento (nome_departamento, localizacao) VALUES
('Ciências da Computação', 'Prédio Principal'), -- ID=1
('Matemática Aplicada', 'Anexo B'),            -- ID=2
('Ciências Humanas', 'Prédio Central');        -- ID=3

-- DML: Atualizar disciplinas existentes para associá-las aos departamentos

-- Assumindo que:
-- Disciplina 1 = Programação Web
-- Disciplina 2 = Banco de Dados I
-- Disciplina 3 = Cálculo I

-- 'Programação Web' e 'Banco de Dados I' (IDs 1 e 2) vão para Ciências da Computação (ID=1)
UPDATE disciplina SET ID_Departamento = 1 WHERE ID_Disciplina IN (1, 2);

-- 'Cálculo I' (ID 3) vai para Matemática Aplicada (ID=2)
UPDATE disciplina SET ID_Departamento = 2 WHERE ID_Disciplina = 3;

-- DML: Consulta de teste (JOIN)
-- Mostra qual disciplina pertence a qual departamento.
SELECT
    D.Nome AS Nome_Disciplina,
    DP.nome_departamento
FROM
    disciplina D
JOIN
    departamento DP ON D.ID_Departamento = DP.id_departamento
ORDER BY
    DP.nome_departamento, D.Nome;