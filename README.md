# ✏️ Lista 4 - Exercícios com MySQL Workbench 8.0 

Esta é uma lista de exercícios do site do [Professor Fantini](http://galileu.coltec.ufmg.br/fantini/hp/CursoBD/Curso/IntroducaoBD.php) vinculado ao Colégio Técnico da Universidade Federal de Minas Gerais (COLTEC/UFMG).
É excelente para praticar linguagem DDL no MySql Workbench. Além disso a lista possui como pré-requisito o conhecimento em modelagem conceitual de banco de dados e a criação do modelo Lógico/Físico.

---

## Exercício 1 [🔗](https://github.com/vinyaro/lista-4-mysql/blob/main/Exercicio%201%20-%20Lista%204.sql)
Execute todos os passos apresentados no estudo acima [(visite o site)](http://galileu.coltec.ufmg.br/fantini/hp/CursoBD/Curso/Lista04_BD_2020.php), partindo de um modelo vazio, criando as tabelas e conectando com o MySql. Ao final do processo, verifique o banco criado no seu mysql. Insira dados para testes.

## Exercício 2
Repare que na figura 6 [(visite o site)](http://galileu.coltec.ufmg.br/fantini/hp/CursoBD/Curso/Mysql_XX_Projetos_Parte04_ModeloFisico.php#Exercicios) temos as três tabelas criadas, mas sem definições de relacionamentos entre elas. A partir dessa observação pense e responda:
1. Podemos criar o banco de dados a partir dessa estrutura, sem definir os relacionamentos?
2. Se sim, analise o impacto e as consequências para a administração do banco de dados. Você acha que definir o banco apenas com as tabelas, sem existir relacionamentos entre elas é um problema?
3. Experimente fazer todo o processo (como foi feito no estudo da criação do banco acima), a partir da figura 6.

---

## Respostas ao Exercício 2

1. Sim, é possível criar o banco de dados apenas com as tabelas, sem definir os relacionamentos. Ao omitir os relacionamentos, deixamos de lado a criação das Chaves Estrangeiras (`FOREIGN KEY`). O MySQL executará os comandos `CREATE TABLE` que definem as colunas e as Chaves Primárias (`PRIMARY KEY`) sem erros.
2. Definir o banco apenas com tabelas (sem `FOREIGN KEYs`) é um problema grave na administração de um SGBD (Sistema Gerenciador de Banco de Dados) e traz consequências negativas - exemplifico três delas abaixo. É importante lembrar que o propósito principal de um modelo relacional é garantir a confiabilidade dos dados. Sem Chaves Estrangeiras (`FOREIGN KEYs`), você tem apenas um repositório de dados planos, não um banco de dados relacional íntegro.
- 2.1 Quebra da Integridade Referencial: Este é o maior impacto. O sistema perde a capacidade de impor regras de relacionamento. Por exemplo, podemos inserir um registro na tabela `Telefone` usando um `EstudanteCpf` que **não existe** na tabela `Estudante`. O banco de dados aceitará esse "CPF órfão", gerando dados inválidos.
- 2.2 Dificuldade em Consultas (JOINs): Consultas complexas se tornam mais difíceis, pois o SGBD não consegue otimizar as junções e fazendo com que o administrador tenha que confiar cegamente que os dados referenciados estão corretos.
- 2.3 Exclusão Inconsistente: Podemos excluir um Estudante (registro pai) sem que o SGBD alerte ou impeça, deixando para trás todos os registros relacionados em Telefone e Disciplina_has_Estudante (registros filhos) como lixo de dados
3. Ao refazer o banco de dados `EstudanteDisciplina` sem relacionamento e com apenas as três tabelas da figura 6,  o comando `Insert` funciona, deixando o administrador/usuário inserir dados nas tabelas. No entanto, essa inserção de dados quebra a integridade da tabela, pois não a protege de duplicações ou inserções de dados que não tenham relacionamento com outras tabelas, por exemplo, inserir um número de telefone na tabela `Telefone` para um CPF que não existe na tabela `Estudante`. Essa inserção é aceita pelo SGBD, porém quebra a integridade e a confiabilidade do banco de dados.

---

## Exercício 3 [🔗](https://github.com/vinyaro/lista-4-mysql/blob/main/Exercicio%203%20-%20Lista%204.sql)
Melhore o modelo do estudo de caso (Estudante/Disciplina) colocando restrição de número de estudantes que podem cursar uma determinada disciplina. Essa alteração deve ser feita em qual(uais) modelo(s)? (ER, Lógico ou Físico)
Resposta: Essa melhoria deve ser feita no modelo Lógico/Físico(DDL). Precisamos de um local para armazenar o limite de vagas e isso deve ser feito na tabela `DISCIPLINA` através da criação de um novo campo `MaxAlunos`.

## Exercício 4 [🔗](https://github.com/vinyaro/lista-4-mysql/blob/main/Exercicio%204%20-%20Lista%204.sql)
Melhore o modelo do estudo de caso (Estudante/Disciplina) criando a entidade departamento e associando a ela disciplinas. Cada departamento deve ser responsável por N disciplinas. E cada disciplina só pode ser ofertada por um departamento específico. Fica a cargo do projetista definir os atributos e relacionamentos necessários. Implemente o modelo ER, Lógico (MysqlWorkbench) e Físico (mysql)

## Exercício 5 [🔗](https://github.com/vinyaro/lista-4-mysql/blob/main/Exercicio%205%20-%20Lista%204.sql)
- Crie o modelo ER (diagrama DER) para um banco de dados de uma escola (bem simplificado)
- O modelo conceitual deve ter tratar as informações pessoais (responsáveis, endereço, dados de idade, escola anterior, etc.) e acadêmicas dos estudantes. Deve conter informações do ano letivo, das disciplinas cursadas, das ocorrências do aluno na escola. O sistema que será criado deve prever informações trimestrais do desempenho do aluno. Deve-se ter um sistema para registro de notas e frequências. Fica a cargo do projetistas fazer a concepção do modelo conceitual e gerar o DER.
- Uma vez gerado o DER, use o MysqlWorkBench para criar o modelo relacional
- A partir do modelo relacional, crie o banco de dados usando o processo de “Forward Engineer” do MysqlWorkBench
- Conecte com seu mysql (ou, opcionalmente com o mysql da máquina newton) e crie o banco.
- Insira dados e faça testes
