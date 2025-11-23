-- Melhore o modelo do estudo de caso (Estudante/Disciplina) colocando restrição 
-- de número de estudantes que podem cursar uma determinada disciplina.  
-- Essa alteração deve ser feita em qual(uais) modelo(s)? (ER, Lógico ou Físico)

-- RESPOSTA: Essa melhoria deve ser feita no modelo Lógico/Físico(DDL).  
-- Precisamos de um local para armazenar o limite de vagas
-- isso deve ser feito na tabela DISCIPLINA através da criação de um novo campo MaxAlunos

-- Adiciona a coluna 'MaxAlunos' à tabela 'disciplina'
ALTER TABLE disciplina ADD COLUMN MaxAlunos INT NOT NULL DEFAULT 30;

-- Exemplo de atualização de dados (DML)
-- Define que a disciplina de ID=1 (Programação Web) tem um máximo de 2 vagas para teste.
UPDATE disciplina SET MaxAlunos = 2 WHERE ID_Disciplina = 1;

-- Altera o delimitador padrão para permitir o bloco do trigger
DELIMITER //

-- Cria o Trigger
CREATE TRIGGER trg_restricao_vagas
BEFORE INSERT ON disciplina_tem_estudante
FOR EACH ROW
BEGIN
    -- Variável para armazenar o número atual de alunos
    DECLARE current_count INT;
    -- Variável para armazenar o limite de vagas
    DECLARE max_limit INT;

    -- 1. Conta quantos alunos já estão matriculados na disciplina
    SELECT COUNT(*)
    INTO current_count
    FROM disciplina_tem_estudante
    WHERE Disciplina_ID_Disciplina = NEW.Disciplina_ID_Disciplina;

    -- 2. Busca o limite máximo de vagas para a disciplina
    SELECT MaxAlunos
    INTO max_limit
    FROM disciplina
    WHERE ID_Disciplina = NEW.Disciplina_ID_Disciplina;

    -- 3. Verifica se a matrícula excederá o limite
    IF current_count >= max_limit THEN
        -- Se exceder, levanta um erro e impede a inserção
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRO: Limite de vagas excedido para esta disciplina.';
    END IF;
END;
//

-- Retorna o delimitador para o padrão (ponto e vírgula)
DELIMITER ;

-- Este INSERT deve funcionar: (Vagas 2/2)
INSERT INTO disciplina_tem_estudante (Disciplina_ID_Disciplina, EstudanteCpf) VALUES
(1, 98765432109);

-- TESTE DE ERRO
-- 1. Cria o Aluno 3
INSERT INTO estudante (CPF, Nome, NumMatricula) VALUES
(33333333333, 'Novo Aluno', '20240003');

-- 2. TENTATIVA DE INSERÇÃO INVÁLIDA (Vagas 3/2)
-- Este comando DEVE FALHAR e retornar a mensagem de erro do TRIGGER.
INSERT INTO disciplina_tem_estudante (Disciplina_ID_Disciplina, EstudanteCpf) VALUES
(1, 33333333333);