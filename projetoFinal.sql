CREATE DATABASE Formula1_2025;
USE Formula1_2025;

CREATE TABLE Equipes (
    id_equipe INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    motor VARCHAR(50) NOT NULL
);

CREATE TABLE Pilotos (
    id_piloto INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    pais VARCHAR(50),
    id_equipe INT,
    FOREIGN KEY (id_equipe) REFERENCES Equipes(id_equipe)
);

CREATE TABLE Corridas (
    id_corrida INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    data DATE NOT NULL,
    local VARCHAR(100) NOT NULL
);

CREATE TABLE Resultados (
    id_resultado INT PRIMARY KEY AUTO_INCREMENT,
    id_corrida INT,
    id_piloto INT,
    posicao INT,
    pontos INT,
    FOREIGN KEY (id_corrida) REFERENCES Corridas(id_corrida),
    FOREIGN KEY (id_piloto) REFERENCES Pilotos(id_piloto)
);

INSERT INTO Equipes (nome, motor) VALUES 
('McLaren', 'Mercedes'),
('Ferrari', 'Ferrari'),
('Red Bull Racing', 'Honda'),
('Mercedes', 'Mercedes'),
('Aston Martin', 'Mercedes');

INSERT INTO Pilotos (nome, pais, id_equipe) VALUES 
('Lando Norris', 'Reino Unido', 1),
('Oscar Piastri', 'Austrália', 1),
('Charles Leclerc', 'Mônaco', 2),
('Lewis Hamilton', 'Reino Unido', 2),
('Max Verstappen', 'Países Baixos', 3),
('Liam Lawson', 'Nova Zelândia', 3),
('George Russell', 'Reino Unido', 4),
('Andrea Kimi Antonelli', 'Itália', 4),
('Fernando Alonso', 'Espanha', 5),
('Lance Stroll', 'Canadá', 5);

INSERT INTO Corridas (nome, data, local) VALUES 
('Grande Prêmio da Austrália', '2025-03-16', 'Melbourne'),
('Grande Prêmio do Bahrein', '2025-03-23', 'Sakhir');

INSERT INTO Resultados (id_corrida, id_piloto, posicao, pontos) VALUES 
(1, 1, 1, 25),
(1, 5, 2, 18),
(1, 7, 3, 15);

SELECT 
    c.nome AS corrida,
    c.data,
    p.nome AS piloto,
    e.nome AS equipe,
    r.posicao,
    r.pontos
FROM 
    Resultados r
    JOIN Corridas c ON r.id_corrida = c.id_corrida
    JOIN Pilotos p ON r.id_piloto = p.id_piloto
    JOIN Equipes e ON p.id_equipe = e.id_equipe
ORDER BY 
    c.data,
    r.posicao;

CREATE VIEW ClassificacaoPilotos AS
SELECT 
    p.nome AS piloto,
    e.nome AS equipe,
    SUM(r.pontos) AS pontos_totais
FROM 
    Resultados r
    JOIN Pilotos p ON r.id_piloto = p.id_piloto
    JOIN Equipes e ON p.id_equipe = e.id_equipe
GROUP BY 
    p.nome, 
    e.nome
ORDER BY 
    pontos_totais DESC;

CREATE TRIGGER atualizar_pontuacao
AFTER INSERT ON Resultados
FOR EACH ROW
BEGIN
    UPDATE Pilotos
    SET pontos = (SELECT SUM(pontos) FROM Resultados WHERE id_piloto = NEW.id_piloto)
    WHERE id_piloto = NEW.id_piloto;
END;