-- STREAMFLOW - PROJETO DO 2º/3º BIMESTRE
-- Banco de Dados II
-- SGBD usado: MySQL / MariaDB 
-- Por estar usando o MySQL e MariaDB eu não utilizei o diferencial do PostgreSQL nem a parte de ORM

-- criando o banco
CREATE DATABASE StreamFlow;

-- entrando no banco
USE StreamFlow;


-- PARTE 1: TABELAS DO PROJETO DO 2º BIMESTRE

-- tabela dos clientes
-- coloquei saldo e data da alteração porque foi pedido pelo professor
CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    cpf CHAR(11) NOT NULL UNIQUE,
    dados_pagamento VARCHAR(255),
    uf CHAR(2) NOT NULL,
    data_nascimento DATE NOT NULL,

    -- saldo usado na cobrança mensal
    saldo_creditos DECIMAL(10,2) NOT NULL DEFAULT 0.00,

    -- vai ser atualizado pelo trigger
    data_ultima_alteracao TIMESTAMP NULL
);


-- tabela dos planos
CREATE TABLE Planos (
    id_plano INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    quantidade_telas INT NOT NULL,
    qualidade ENUM('SD','HD','FULL HD','4K') NOT NULL
);


-- tabela das assinaturas
CREATE TABLE Assinaturas (
    id_assinatura INT AUTO_INCREMENT PRIMARY KEY,
    valor DECIMAL(10,2) NOT NULL,
    status_assinatura ENUM('ATIVA','SUSPENSA','CANCELADA') NOT NULL DEFAULT 'ATIVA',
    id_cliente INT NOT NULL,
    id_plano INT NOT NULL,

    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_plano) REFERENCES Planos(id_plano)
);


-- tabela dos perfis
CREATE TABLE Perfis (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    nome_exibicao VARCHAR(50) NOT NULL,
    preferencias VARCHAR(255),
    id_cliente INT NOT NULL,

    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);


-- categorias dos videos
CREATE TABLE Categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);


-- produtoras
CREATE TABLE Produtoras (
    id_produtora INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL
);


-- tabela dos videos
CREATE TABLE Videos (
    id_video INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    tipo ENUM('FILME','SERIE') NOT NULL,
    duracao_segundos INT NOT NULL,
    data_inclusao DATE DEFAULT (CURRENT_DATE),
    status_catalogo ENUM('ATIVO','REMOVIDO') DEFAULT 'ATIVO',

    id_categoria INT NOT NULL,
    id_produtora INT NOT NULL,

    FOREIGN KEY (id_categoria) REFERENCES Categorias(id_categoria),
    FOREIGN KEY (id_produtora) REFERENCES Produtoras(id_produtora)
);


-- tabela dos historicos de reprodução
-- nessa tabela adicionei o status concluida/pausada
CREATE TABLE Historicos (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_perfil INT NOT NULL,
    id_video INT NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_conexao VARCHAR(45) NOT NULL,
    dispositivo ENUM('SMARTTV','SMARTPHONE','TABLET','WEB') NOT NULL,
    tempo_assistido INT DEFAULT 0,

    -- status da reprodução
    status_reproducao ENUM('CONCLUIDA','PAUSADA') DEFAULT 'PAUSADA',

    FOREIGN KEY (id_perfil) REFERENCES Perfis(id_perfil),
    FOREIGN KEY (id_video) REFERENCES Videos(id_video)
);


-- essa parte já tinha no projeto do 2º bimestre
CREATE INDEX idx_continuar_assistindo
ON Historicos (id_perfil, data_hora);


-- TABELAS DO 3º BIMESTRE

-- tabela para guardar o faturamento de cada produtora
CREATE TABLE Faturamento_Produtoras (
    id_faturamento INT AUTO_INCREMENT PRIMARY KEY,
    id_produtora INT NOT NULL,
    competencia DATE NOT NULL,
    minutos_consumidos DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (id_produtora) REFERENCES Produtoras(id_produtora)
);


-- não pode ter dois registros da mesma produtora no mesmo mês
CREATE UNIQUE INDEX uq_faturamento
ON Faturamento_Produtoras (id_produtora, competencia);


-- tabela que vai guardar as alterações feitas
CREATE TABLE Auditoria_Log (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    tabela VARCHAR(50) NOT NULL,
    operacao VARCHAR(30) NOT NULL,
    usuario VARCHAR(100) NOT NULL,
    valor_antigo TEXT,
    valor_novo TEXT,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- INSERTS DO PROJETO DO 2º BIMESTRE

-- clientes
INSERT INTO Clientes
(nome,email,cpf,dados_pagamento,uf,data_nascimento,saldo_creditos)
VALUES
('Lucas Andrade','lucas@email.com','11111111111','Visa 1111','SP','2000-01-01',20.00),
('Mariana Souza','mariana@email.com','22222222222','Master 2222','RJ','1998-05-12',50.00),
('Carlos Lima','carlos@email.com','33333333333','Pix','MG','1985-09-09',50.00),
('Juliana Rocha','juliana@email.com','44444444444','Visa 4444','BA','1993-02-20',50.00),
('Pedro Martins','pedro@email.com','55555555555','Pix','PR','2003-12-11',50.00);


-- planos
INSERT INTO Planos
(nome,valor,quantidade_telas,qualidade)
VALUES
('Básico',14.90,1,'HD'),
('Padrão',24.90,3,'FULL HD'),
('Premium',49.90,5,'4K');


-- assinaturas
INSERT INTO Assinaturas
(valor,status_assinatura,id_cliente,id_plano)
VALUES
(14.90,'ATIVA',1,1),
(24.90,'ATIVA',2,2),
(49.90,'ATIVA',3,3),
(24.90,'SUSPENSA',4,2),
(14.90,'CANCELADA',5,1);


-- perfis
INSERT INTO Perfis
(nome_exibicao,preferencias,id_cliente)
VALUES
('Perfil Lucas','Ação,Drama',1),
('Kids Lucas','Animação',1),
('Mariana','Romance',2),
('Carlos','Documentário',3),
('Juliana','Suspense',4),
('Pedro','Comédia',5);


-- categorias
INSERT INTO Categorias (nome)
VALUES
('Drama'),
('Comédia'),
('Ação'),
('Suspense'),
('Doramas'),
('Animação');


-- produtoras
INSERT INTO Produtoras (nome)
VALUES
('Neo Studios'),
('Pixel Works'),
('Nova Filmes'),
('Sky Media'),
('Blue Motion'),
('Prime Vision'),
('Echo Studio'),
('Iron House'),
('Sunset Films'),
('Lunar Entertainment');


-- videos
INSERT INTO Videos
(titulo,tipo,duracao_segundos,data_inclusao,status_catalogo,id_categoria,id_produtora)
VALUES
('Cidade Perdida','FILME',6000,'2024-01-10','ATIVO',1,1),
('Missão Final','FILME',7200,'2024-02-15','ATIVO',3,2),
('Sombras Futuras','FILME',5400,'2024-03-20','ATIVO',4,3),
('Conexão Zero','FILME',5100,'2024-04-05','ATIVO',2,4),
('Horizonte Azul','FILME',6800,'2024-05-11','ATIVO',1,5);


-- historicos
INSERT INTO Historicos
(id_perfil,id_video,data_hora,ip_conexao,dispositivo,tempo_assistido,status_reproducao)
VALUES
(1,1,'2025-01-01 10:00:00','192.168.0.1','SMARTPHONE',3200,'CONCLUIDA'),
(2,2,'2025-01-02 11:00:00','192.168.0.2','SMARTTV',1800,'PAUSADA'),
(3,3,'2025-01-03 12:00:00','192.168.0.3','WEB',2500,'CONCLUIDA'),
(4,4,'2025-01-04 13:00:00','192.168.0.4','TABLET',1400,'PAUSADA'),
(5,5,'2025-01-05 14:00:00','192.168.0.5','SMARTPHONE',3000,'CONCLUIDA');


-- PARTE 2: FUNCTION PARA CALCULAR A IDADE

-- mudando o delimitador para poder criar a function
DELIMITER $$


-- se já existir a function ela é apagada
DROP FUNCTION IF EXISTS calcular_idade$$


-- função que calcula a idade
CREATE FUNCTION calcular_idade(p_data_nascimento DATE)
RETURNS INT
DETERMINISTIC
BEGIN

    -- variavel que vai guardar a idade
    DECLARE idade INT;

    -- calculando a idade pela data de nascimento
    SET idade = TIMESTAMPDIFF(YEAR, p_data_nascimento, CURDATE());

    -- devolvendo a idade
    RETURN idade;

END$$


-- voltando o delimitador normal
DELIMITER;

-- teste da function
SELECT calcular_idade('2000-01-01') AS idade;


-- ATUALIZANDO A VIEW DO PROJETO DO 2º BIMESTRE

-- apagando a view antiga
DROP VIEW IF EXISTS vw_clientes_analitico;


-- criando a view de novo
-- agora a idade vai vir da function
CREATE VIEW vw_clientes_analitico AS
SELECT
    id_cliente,
    calcular_idade(data_nascimento) AS idade,
    uf
FROM Clientes;


-- testando a view
SELECT * FROM vw_clientes_analitico;


-- PARTE 3: FUNCTION DE MINUTOS POR PRODUTORA

DELIMITER $$


-- apagando a function se ela já existir
DROP FUNCTION IF EXISTS minutos_assistidos_por_produtora$$


-- função que soma os minutos assistidos de uma produtora
CREATE FUNCTION minutos_assistidos_por_produtora(
    p_id_produtora INT,
    p_competencia DATE
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN

    -- variavel que vai guardar o total
    DECLARE total_minutos DECIMAL(10,2);

    -- somando o tempo assistido
    SELECT
        IFNULL(SUM(h.tempo_assistido) / 60, 0)
    INTO total_minutos
    FROM Historicos h

    -- ligando o historico com o video
    JOIN Videos v
        ON v.id_video = h.id_video

    -- pegando apenas a produtora informada
    WHERE v.id_produtora = p_id_produtora

    -- pegando apenas o ano e o mês informado
    AND YEAR(h.data_hora) = YEAR(p_competencia)
    AND MONTH(h.data_hora) = MONTH(p_competencia)

    -- apenas reproduções concluidas ou pausadas
    AND h.status_reproducao IN ('CONCLUIDA','PAUSADA');


    -- devolvendo o total
    RETURN total_minutos;

END$$


DELIMITER ;


-- testando a function
SELECT minutos_assistidos_por_produtora(1,'2025-01-01')
AS minutos_assistidos;


-- PARTE 4: PROCEDURE DE COBRANÇA

DELIMITER $$


-- apagando a procedure antiga se ela já existir
DROP PROCEDURE IF EXISTS realizar_cobranca_mensal$$


-- procedure da cobrança mensal
CREATE PROCEDURE realizar_cobranca_mensal(
    IN p_id_cliente INT,
    IN p_valor DECIMAL(10,2),
    OUT p_novo_saldo DECIMAL(10,2)
)
BEGIN

    -- variavel para guardar o saldo atual
    DECLARE saldo_atual DECIMAL(10,2);

    -- verifica se o erro foi por saldo insuficiente
    DECLARE erro_saldo BOOLEAN DEFAULT FALSE;


    -- se der algum erro a transação vai ser cancelada
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN

        -- desfaz o que já foi feito
        ROLLBACK;

        -- se foi saldo insuficiente mostra essa mensagem
        IF erro_saldo = TRUE THEN

            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Saldo insuficiente para realizar a cobranca.';

        ELSE

            -- mensagem para outros erros
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Nao foi possivel realizar a cobranca.';

        END IF;

    END;


    -- começando a transação
    START TRANSACTION;


    -- pegando o saldo atual do cliente
    SELECT saldo_creditos
    INTO saldo_atual
    FROM Clientes
    WHERE id_cliente = p_id_cliente;


    -- verificando se tem saldo suficiente
    IF saldo_atual < p_valor THEN

        -- marca que o problema foi o saldo 
        SET erro_saldo = TRUE;

        -- gera o erro mostrando a mensagem de "Saldo insuficiente"
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Saldo insuficiente.';

    END IF;


    -- tirando o valor da cobrança do saldo
    UPDATE Clientes
    SET saldo_creditos = saldo_creditos - p_valor
    WHERE id_cliente = p_id_cliente;


    -- guardando o novo saldo no OUT
    SET p_novo_saldo = saldo_atual - p_valor;


    -- confirmando a alteração
    COMMIT;

END$$


DELIMITER ;


-- TESTANDO A COBRANÇA COM SALDO INSUFICIENTE

-- o cliente 1 tem 20 reais
SELECT id_cliente, saldo_creditos
FROM Clientes
WHERE id_cliente = 1;


-- tentando cobrar 49.90
-- deve dar erro de saldo insuficiente 
CALL realizar_cobranca_mensal(1,49.90,@novo_saldo);


-- vendo o saldo depois do erro
-- ele deve continuar com 20 reais
SELECT id_cliente, saldo_creditos
FROM Clientes
WHERE id_cliente = 1;


-- TESTANDO A COBRANÇA QUE VAI FUNCIONAR

-- agora cobrando 14.90
CALL realizar_cobranca_mensal(1,14.90,@novo_saldo);


-- mostrando o novo saldo
SELECT @novo_saldo AS novo_saldo;


-- conferindo direto na tabela de saldo do cliente
SELECT id_cliente, saldo_creditos
FROM Clientes
WHERE id_cliente = 1;


-- PARTE 5: PROCEDURE DE REGISTRAR A REPRODUÇÃO

DELIMITER $$


-- apagando caso já exista
DROP PROCEDURE IF EXISTS registrar_reproducao$$


-- procedure para registrar um play
CREATE PROCEDURE registrar_reproducao(
    IN p_id_perfil INT,
    IN p_id_video INT,
    IN p_ip VARCHAR(45),
    IN p_dispositivo VARCHAR(20),
    OUT p_id_historico INT
)
BEGIN

    -- se acontecer algum erro desfaz a transação
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN

        -- cancelando a operação
        ROLLBACK;

        -- mostrando uma mensagem mais simples
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nao foi possivel registrar a reproducao.';

    END;


    -- iniciando a transação
    START TRANSACTION;


    -- registrando o play
    -- a data e hora é criada pelo servidor
    INSERT INTO Historicos
    (
        id_perfil,
        id_video,
        ip_conexao,
        dispositivo,
        tempo_assistido,
        status_reproducao
    )
    VALUES
    (
        p_id_perfil,
        p_id_video,
        p_ip,
        p_dispositivo,
        0,
        'PAUSADA'
    );


    -- pegando o id que eu acabei de criar
    SET p_id_historico = LAST_INSERT_ID();


    -- confirmando a transação
    COMMIT;

END$$


DELIMITER ;


-- testando a procedure
CALL registrar_reproducao(
    1,
    1,
    '192.168.0.20',
    'WEB',
    @id_reproducao
);


-- mostrando o id criado
SELECT @id_reproducao AS id_reproducao;


-- conferindo o registro
SELECT *
FROM Historicos
WHERE id_historico = @id_reproducao;


-- PARTE 6: PROCEDURE COM CURSOR
DELIMITER $$


-- apagando se já existir
DROP PROCEDURE IF EXISTS gerar_faturamento_mensal$$


-- procedure que gera o faturamento das produtoras
CREATE PROCEDURE gerar_faturamento_mensal(
    IN p_competencia DATE
)
BEGIN

    -- variavel que guarda o id da produtora
    DECLARE v_id_produtora INT;

    -- guarda os minutos que foram calculados
    DECLARE v_minutos DECIMAL(10,2);

    -- verifica se o cursor chegou no final
    DECLARE fim INT DEFAULT 0;

    -- verifica se já existe faturamento
    DECLARE existe INT;


    -- cursor que pega todas as produtoras
    DECLARE cursor_produtoras CURSOR FOR
        SELECT id_produtora
        FROM Produtoras;


    -- quando não tiver mais produtoras muda o fim para 1
    DECLARE CONTINUE HANDLER FOR NOT FOUND
        SET fim = 1;


    -- se der outro erro vai tudo ser cancelado
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN

        -- desfaz as alterações feitas
        ROLLBACK;

        -- mostra uma mensagem simples
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nao foi possivel gerar o faturamento.';

    END;


    -- começando a transação
    START TRANSACTION;


    -- abrindo o cursor
    OPEN cursor_produtoras;


    -- começando o loop
    loop_produtoras: LOOP


        -- pegando uma produtora
        FETCH cursor_produtoras
        INTO v_id_produtora;


        -- se acabou o cursor sai do loop
        IF fim = 1 THEN

            LEAVE loop_produtoras;

        END IF;


        -- usando a function para calcular os minutos
        SET v_minutos =
            minutos_assistidos_por_produtora(
                v_id_produtora,
                p_competencia
            );


        -- vendo se já existe faturamento para esse mês
        SELECT COUNT(*)
        INTO existe
        FROM Faturamento_Produtoras
        WHERE id_produtora = v_id_produtora
        AND competencia = p_competencia;


        -- se ainda não existe cria um faturamento
        IF existe = 0 THEN

            INSERT INTO Faturamento_Produtoras
            (
                id_produtora,
                competencia,
                minutos_consumidos
            )
            VALUES
            (
                v_id_produtora,
                p_competencia,
                v_minutos
            );


        ELSE

            -- se já existe atualiza os minutos
            UPDATE Faturamento_Produtoras
            SET minutos_consumidos = v_minutos
            WHERE id_produtora = v_id_produtora
            AND competencia = p_competencia;

        END IF;


    END LOOP;


    -- fechando o cursor
    CLOSE cursor_produtoras;


    -- confirmando tudo
    COMMIT;

END$$


DELIMITER ;


-- teste do cursor
CALL gerar_faturamento_mensal('2025-01-01');


-- mostrando o faturamento criado
SELECT *
FROM Faturamento_Produtoras;


-- mostrando com o nome da produtora
SELECT
    f.id_faturamento,
    p.nome AS produtora,
    f.competencia,
    f.minutos_consumidos
FROM Faturamento_Produtoras f
JOIN Produtoras p
    ON p.id_produtora = f.id_produtora;


-- PARTE 7: TRIGGER DE SALDO


DELIMITER $$


-- apagando o trigger caso ele já exista
DROP TRIGGER IF EXISTS trg_clientes_antes_inserir$$


-- antes de inserir um cliente
CREATE TRIGGER trg_clientes_antes_inserir
BEFORE INSERT ON Clientes
FOR EACH ROW
BEGIN

    -- arruma o nome tirando espaços e colocando maiusculo
    SET NEW.nome = UPPER(TRIM(NEW.nome));


    -- não deixa cadastrar se o saldo for negativo
    IF NEW.saldo_creditos < 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O saldo nao pode ser negativo.';

    END IF;

END$$


DELIMITER ;


-- PARTE 8: TRIGGER DE UPDATE DO CLIENTE

DELIMITER $$


-- apagando o trigger caso ele já exista
DROP TRIGGER IF EXISTS trg_clientes_antes_atualizar$$


-- antes de atualizar um cliente
CREATE TRIGGER trg_clientes_antes_atualizar
BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN

    -- atualizando a data automaticamente
    SET NEW.data_ultima_alteracao = CURRENT_TIMESTAMP;


    -- não deixa colocar saldo negativo
    IF NEW.saldo_creditos < 0 THEN

        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'O saldo nao pode ficar negativo.';

    END IF;

END$$


DELIMITER ;


-- TESTE DO TRIGGER DE SALDO
-- esse teste deve funcionar
INSERT INTO Clientes
(nome,email,cpf,dados_pagamento,uf,data_nascimento,saldo_creditos)
VALUES
('  teste cliente  ','teste@email.com','99999999999','Pix','SP','2000-01-01',30.00);


-- conferindo o nome
-- ele deve aparecer como TESTE CLIENTE
SELECT *
FROM Clientes
WHERE email = 'teste@email.com';


-- esse teste deve dar erro
-- porque o saldo está negativo
INSERT INTO Clientes
(nome,email,cpf,dados_pagamento,uf,data_nascimento,saldo_creditos)
VALUES
('Cliente Erro','erro@email.com','88888888888','Pix','SP','2000-01-01',-10.00);


-- PARTE 9: TRIGGERS DO HISTÓRICO

DELIMITER $$


-- não deixa editar um historico
DROP TRIGGER IF EXISTS trg_historicos_nao_atualizar$$


CREATE TRIGGER trg_historicos_nao_atualizar
BEFORE UPDATE ON Historicos
FOR EACH ROW
BEGIN

    -- o historico não pode ser alterado
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'O historico de reproducao nao pode ser alterado.';

END$$


-- não deixa apagar um historico
DROP TRIGGER IF EXISTS trg_historicos_nao_excluir$$


CREATE TRIGGER trg_historicos_nao_excluir
BEFORE DELETE ON Historicos
FOR EACH ROW
BEGIN

    -- bloqueando a exclusão do historico
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'O historico de reproducao nao pode ser excluido.';

END$$


DELIMITER ;


-- TESTANDO OS TRIGGERS DO HISTÓRICO
-- esse update deve dar erro
UPDATE Historicos
SET tempo_assistido = 100
WHERE id_historico = 1;


-- esse delete tambem deve dar erro
DELETE FROM Historicos
WHERE id_historico = 1;


-- PARTE 10: TRIGGER DE AUDITORIA

DELIMITER $$


-- apagando o trigger se ele já existir
DROP TRIGGER IF EXISTS trg_perfis_auditoria$$


-- depois de atualizar um perfil
CREATE TRIGGER trg_perfis_auditoria
AFTER UPDATE ON Perfis
FOR EACH ROW
BEGIN

    -- guardando a alteração na tabela de auditoria
    INSERT INTO Auditoria_Log
    (
        tabela,
        operacao,
        usuario,
        valor_antigo,
        valor_novo
    )
    VALUES
    (
        'Perfis',
        'UPDATE',
        CURRENT_USER(),
        OLD.nome_exibicao,
        NEW.nome_exibicao
    );

END$$


DELIMITER ;


-- TESTE DA AUDITORIA
-- alterando o nome de um perfil
UPDATE Perfis
SET nome_exibicao = 'Lucas Novo'
WHERE id_perfil = 1;


-- vendo o log criado
SELECT *
FROM Auditoria_Log;


-- vendo a data de alteração do cliente
SELECT
    id_cliente,
    nome,
    data_ultima_alteracao
FROM Clientes;


-- CONSULTAS DO PROJETO

-- continuar assistindo
SELECT
    p.id_perfil,
    v.titulo,
    h.tempo_assistido,
    v.duracao_segundos,
    h.data_hora
FROM Historicos h
JOIN Perfis p
    ON p.id_perfil = h.id_perfil
JOIN Videos v
    ON v.id_video = h.id_video
WHERE h.tempo_assistido < v.duracao_segundos
ORDER BY h.data_hora DESC;


-- consumo por produtora
SELECT
    pr.nome,
    SUM(h.tempo_assistido) / 60 AS minutos_assistidos
FROM Historicos h
JOIN Videos v
    ON v.id_video = h.id_video
JOIN Produtoras pr
    ON pr.id_produtora = v.id_produtora
GROUP BY pr.nome;


-- auditoria por região
SELECT
    c.uf,
    h.dispositivo,
    COUNT(*) AS total_acessos
FROM Clientes c
JOIN Perfis p
    ON p.id_cliente = c.id_cliente
JOIN Historicos h
    ON h.id_perfil = p.id_perfil
GROUP BY c.uf, h.dispositivo;


-- vendo a auditoria criada pelos triggers
SELECT *
FROM Auditoria_Log;


-- vendo o faturamento da produtora
SELECT
    p.nome AS produtora,
    f.competencia,
    f.minutos_consumidos
FROM Faturamento_Produtoras f
JOIN Produtoras p
    ON p.id_produtora = f.id_produtora;