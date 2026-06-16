-- criação do banco de dados do sistema StreamFlow
CREATE DATABASE StreamFlow;
USE StreamFlow;

-- tabela de clientes do streaming
CREATE TABLE Clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    cpf CHAR(11) NOT NULL UNIQUE,
    dados_pagamento VARCHAR(255),
    uf CHAR(2) NOT NULL,
    data_nascimento DATE NOT NULL
);

-- planos disponíveis na plataforma
CREATE TABLE Planos (
    id_plano INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL,
    valor DECIMAL(10,2) NOT NULL,
    quantidade_telas INT NOT NULL,
    qualidade ENUM('SD','HD','FULL HD','4K') NOT NULL
);

-- assinaturas dos clientes
CREATE TABLE Assinaturas (
    id_assinatura INT AUTO_INCREMENT PRIMARY KEY,
    valor DECIMAL(10,2) NOT NULL,
    status_assinatura ENUM('ATIVA','SUSPENSA','CANCELADA') NOT NULL DEFAULT 'ATIVA',

    id_cliente INT NOT NULL,
    id_plano INT NOT NULL,

    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente),
    FOREIGN KEY (id_plano) REFERENCES Planos(id_plano)
);

-- perfis criados dentro de cada conta
CREATE TABLE Perfis (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    nome_exibicao VARCHAR(50) NOT NULL,
    preferencias VARCHAR(255),
    id_cliente INT NOT NULL,

    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
);

-- categorias dos conteúdos
CREATE TABLE Categorias (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL
);

-- produtoras de conteúdo
CREATE TABLE Produtoras (
    id_produtora INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL
);

-- vídeos (filmes e séries)
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

-- histórico de reprodução (logs imutáveis)
CREATE TABLE Historicos (
    id_historico INT AUTO_INCREMENT PRIMARY KEY,
    id_perfil INT NOT NULL,
    id_video INT NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ip_conexao VARCHAR(45) NOT NULL,
    dispositivo ENUM('SMARTTV','SMARTPHONE','TABLET','WEB') NOT NULL,
    tempo_assistido INT DEFAULT 0,

    FOREIGN KEY (id_perfil) REFERENCES Perfis(id_perfil),
    FOREIGN KEY (id_video) REFERENCES Videos(id_video)
);

-- índice para otimizar a tela de continuar assistindo
CREATE INDEX idx_continuar_assistindo
ON Historicos (id_perfil, data_hora);

-- clientes
INSERT INTO Clientes (nome,email,cpf,dados_pagamento,uf,data_nascimento) VALUES
('Lucas Andrade','lucas@email.com','11111111111','Visa 1111','SP','2002-03-10'),
('Mariana Souza','mariana@email.com','22222222222','Master 2222','RJ','1999-07-21'),
('Carlos Lima','carlos@email.com','33333333333','Pix','MG','1988-11-05'),
('Juliana Rocha','juliana@email.com','44444444444','Visa 4444','BA','1995-01-18'),
('Pedro Martins','pedro@email.com','55555555555','Pix','PR','2001-09-30');

-- atualização de datas (ajuste pedagógico)
UPDATE Clientes SET data_nascimento='2000-01-01' WHERE id_cliente=1;
UPDATE Clientes SET data_nascimento='1998-05-12' WHERE id_cliente=2;
UPDATE Clientes SET data_nascimento='1985-09-09' WHERE id_cliente=3;
UPDATE Clientes SET data_nascimento='1993-02-20' WHERE id_cliente=4;
UPDATE Clientes SET data_nascimento='2003-12-11' WHERE id_cliente=5;

-- planos
INSERT INTO Planos (nome, valor, quantidade_telas, qualidade) VALUES
('Básico', 14.90, 1, 'HD'),
('Padrão', 24.90, 3, 'FULL HD'),
('Premium', 49.90, 5, '4K');

-- assinaturas
INSERT INTO Assinaturas (valor,status_assinatura,id_cliente,id_plano) VALUES
(14.90,'ATIVA',1,1),
(24.90,'ATIVA',2,2),
(49.90,'ATIVA',3,3),
(24.90,'SUSPENSA',4,2),
(14.90,'CANCELADA',5,1);

-- perfis
INSERT INTO Perfis (nome_exibicao,preferencias,id_cliente) VALUES
('Perfil Lucas','Ação,Drama',1),
('Kids Lucas','Animação',1),
('Mariana','Romance',2),
('Carlos','Documentário',3),
('Juliana','Suspense',4),
('Pedro','Comédia',5);

-- categorias
INSERT INTO Categorias (nome) VALUES
('Drama'),
('Comédia'),
('Ação'),
('Suspense'),
('Doramas'),
('Animação');

-- produtoras
INSERT INTO Produtoras (nome) VALUES
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

-- vídeos
INSERT INTO Videos (titulo,tipo,duracao_segundos,data_inclusao,status_catalogo,id_categoria,id_produtora) VALUES
('Cidade Perdida','FILME',6000,'2024-01-10','ATIVO',1,1),
('Missão Final','FILME',7200,'2024-02-15','ATIVO',3,2),
('Sombras Futuras','FILME',5400,'2024-03-20','ATIVO',4,3),
('Conexão Zero','FILME',5100,'2024-04-05','ATIVO',2,4),
('Horizonte Azul','FILME',6800,'2024-05-11','ATIVO',1,5);

-- histórico
INSERT INTO Historicos (id_perfil,id_video,data_hora,ip_conexao,dispositivo) VALUES
(1,1,'2025-01-01 10:00:00','192.168.0.1','SMARTPHONE'),
(2,2,'2025-01-02 11:00:00','192.168.0.2','SMARTTV'),
(3,3,'2025-01-03 12:00:00','192.168.0.3','WEB'),
(4,4,'2025-01-04 13:00:00','192.168.0.4','TABLET'),
(5,5,'2025-01-05 14:00:00','192.168.0.5','SMARTPHONE');

-- tempo assistido
UPDATE Historicos SET tempo_assistido=3200 WHERE id_historico=1;
UPDATE Historicos SET tempo_assistido=1800 WHERE id_historico=2;
UPDATE Historicos SET tempo_assistido=2500 WHERE id_historico=3;
UPDATE Historicos SET tempo_assistido=1400 WHERE id_historico=4;
UPDATE Historicos SET tempo_assistido=3000 WHERE id_historico=5;

CREATE VIEW vw_clientes_analitico AS
SELECT
    id_cliente,
    TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) AS idade,
    uf
FROM Clientes;

-- continuar assistindo
SELECT
    p.id_perfil,
    v.titulo,
    h.tempo_assistido,
    v.duracao_segundos,
    h.data_hora
FROM Historicos h
JOIN Perfis p ON p.id_perfil = h.id_perfil
JOIN Videos v ON v.id_video = h.id_video
WHERE h.tempo_assistido < v.duracao_segundos
ORDER BY h.data_hora DESC;

-- consumo por produtora
SELECT
    pr.nome,
    SUM(h.tempo_assistido)/60 AS minutos_assistidos
FROM Historicos h
JOIN Videos v ON v.id_video = h.id_video
JOIN Produtoras pr ON pr.id_produtora = v.id_produtora
GROUP BY pr.nome;

-- auditoria por região
SELECT
    c.uf,
    h.dispositivo,
    COUNT(*) AS total_acessos
FROM Clientes c
JOIN Perfis p ON p.id_cliente = c.id_cliente
JOIN Historicos h ON h.id_perfil = p.id_perfil
GROUP BY c.uf, h.dispositivo;