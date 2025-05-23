create table depto(
cod_depto INT PRIMARY KEY,
nome VARCHAR(50)
);

CREATE TABLE empregado(
cod_empregado INT PRIMARY KEY,
cod_depto INT,
nome VARCHAR (50),
dt_admissão DATE,
dt_nascimento DATE,
sexo ENUM('M', 'F'),
salario DECIMAL (10,2),
FOREIGN KEY (cod_depto) REFERENCES depto(cod_depto)
);

CREATE TABLE dependente(
cod_dependente INT PRIMARY KEY,
cod_empregado INT,
nome VARCHAR(50),
dt_nascimento DATE,
sexo ENUM('M','F'),
FOREIGN KEY (cod_empregado) REFERENCES empregado(cod_empregado)
);

ALTER TABLE empregado
ADD COLUMN est_civil CHAR(1);

INSERT INTO depto(cod_depto, nome) VALUES(1, 'TI');

INSERT INTO empregado(cod_empregado, cod_depto, nome, dt_nascimento, dt_admissão, sexo, salario)
VALUES (1001, 1, 'João', '1994-10-25', '2022-04-5', 'M', 5600.00);

DELIMITER //

CREATE PROCEDURE InfoSalariosDepto(IN p_cod_depto INT)
BEGIN
    DECLARE soma DECIMAL(10,2);
    DECLARE media DECIMAL(10,2);
    DECLARE maior DECIMAL(10,2);
    DECLARE menor DECIMAL(10,2);

    SELECT SUM(salario), AVG(salario), MAX(salario), MIN(salario)
    INTO soma, media, maior, menor
    FROM Empregado
    WHERE cod_depto = p_cod_depto;

    SELECT soma AS SomaSalarios, media AS MediaSalarial, maior AS MaiorSalario, menor AS MenorSalario;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE ContarFuncionariosSexo(IN p_nome_depto VARCHAR(50))
BEGIN
    DECLARE id INT;
    DECLARE qtd_m INT;
    DECLARE qtd_f INT;

    SELECT cod_depto INTO id FROM Depto WHERE nome = p_nome_depto;

    SELECT COUNT(*) INTO qtd_m FROM Empregado WHERE cod_depto = id AND sexo = 'M';
    SELECT COUNT(*) INTO qtd_f FROM Empregado WHERE cod_depto = id AND sexo = 'F';

    SELECT qtd_m AS Masculino, qtd_f AS Feminino;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE InserirDepartamento(IN p_cod INT, IN p_nome VARCHAR(50))
BEGIN
    INSERT INTO Depto (cod_depto, nome)
    VALUES (p_cod, p_nome);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE AumentoMulheres()
BEGIN
    UPDATE Empregado
    SET salario = salario * 1.05
    WHERE sexo = 'F';
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE AumentoHomens(IN percentual DECIMAL(5,2))
BEGIN
    UPDATE Empregado
    SET salario = salario * (1 + percentual / 100)
    WHERE sexo = 'M';
END //

DELIMITER ;