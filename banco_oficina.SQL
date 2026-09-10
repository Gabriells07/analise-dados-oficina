-- ==========================================
-- PROJETO: ANÁLISE DE DADOS DE OFICINA
-- Autor: Gabriel Oliveira da Silva
-- ==========================================

CREATE DATABASE oficina_automotiva;

USE oficina_automotiva;

-- Tabela de clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    email VARCHAR(100)
);

-- Tabela de veículos
CREATE TABLE veiculos (
    id_veiculo INT PRIMARY KEY AUTO_INCREMENT,
    id_cliente INT NOT NULL,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    placa VARCHAR(10) UNIQUE,
    cor VARCHAR(30),

    FOREIGN KEY (id_cliente)
        REFERENCES clientes(id_cliente)
);

-- Tabela de serviços
CREATE TABLE servicos (
    id_servico INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(150) NOT NULL,
    valor DECIMAL(10,2) NOT NULL
);

-- Tabela de ordens de serviço
CREATE TABLE ordens_servico (
    id_ordem INT PRIMARY KEY AUTO_INCREMENT,
    id_veiculo INT NOT NULL,
    id_servico INT NOT NULL,
    data_servico DATE NOT NULL,
    status_servico VARCHAR(30),

    FOREIGN KEY (id_veiculo)
        REFERENCES veiculos(id_veiculo),

    FOREIGN KEY (id_servico)
        REFERENCES servicos(id_servico)
);

-- ==========================================
-- DADOS DE EXEMPLO
-- ==========================================

INSERT INTO clientes (nome, telefone, email) VALUES
('Carlos Silva', '11999999999', 'carlos@email.com'),
('Mariana Souza', '11988888888', 'mariana@email.com'),
('João Santos', '11977777777', 'joao@email.com');

INSERT INTO veiculos (id_cliente, marca, modelo, placa, cor) VALUES
(1, 'Honda', 'Civic', 'ABC1D23', 'Branco'),
(2, 'Hyundai', 'HB20', 'DEF4G56', 'Prata'),
(3, 'Volkswagen', 'Polo', 'GHI7J89', 'Preto');

INSERT INTO servicos (descricao, valor) VALUES
('Reforma e pintura de para-choque', 600.00),
('Reforma de retrovisor', 300.00),
('Troca de farol', 250.00),
('Alinhamento de para-choque', 150.00);

INSERT INTO ordens_servico
(id_veiculo, id_servico, data_servico, status_servico) VALUES
(1, 1, '2026-09-01', 'Concluído'),
(2, 2, '2026-09-03', 'Concluído'),
(3, 4, '2026-09-05', 'Concluído'),
(1, 3, '2026-09-08', 'Concluído');

-- ==========================================
-- CONSULTAS PARA ANÁLISE DE DADOS
-- ==========================================

-- Mostrar todos os clientes
SELECT * FROM clientes;

-- Mostrar todos os veículos
SELECT * FROM veiculos;

-- Mostrar todas as ordens de serviço
SELECT * FROM ordens_servico;

-- Faturamento total
SELECT
    SUM(servicos.valor) AS faturamento_total
FROM ordens_servico
JOIN servicos
    ON ordens_servico.id_servico = servicos.id_servico;

-- Valor médio dos serviços realizados
SELECT
    AVG(servicos.valor) AS valor_medio_servicos
FROM ordens_servico
JOIN servicos
    ON ordens_servico.id_servico = servicos.id_servico;

-- Serviços mais realizados
SELECT
    servicos.descricao,
    COUNT(*) AS quantidade
FROM ordens_servico
JOIN servicos
    ON ordens_servico.id_servico = servicos.id_servico
GROUP BY servicos.descricao
ORDER BY quantidade DESC;

-- Histórico completo dos serviços
SELECT
    clientes.nome AS cliente,
    veiculos.marca,
    veiculos.modelo,
    veiculos.placa,
    servicos.descricao AS servico,
    servicos.valor,
    ordens_servico.data_servico,
    ordens_servico.status_servico
FROM ordens_servico
JOIN veiculos
    ON ordens_servico.id_veiculo = veiculos.id_veiculo
JOIN clientes
    ON veiculos.id_cliente = clientes.id_cliente
JOIN servicos
    ON ordens_servico.id_servico = servicos.id_servico
ORDER BY ordens_servico.data_servico;
