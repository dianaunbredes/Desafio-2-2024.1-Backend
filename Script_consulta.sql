-- SCRIPT CONSULTA - DETRAN
USE detran;

-- A) Veículos de um proprietário (CPF informado pelo usuário)
SET @cpf = '11111111111';
SELECT v.placa, v.chassi, v.cor_predominante, v.ano_fabricacao,
       m.descricao AS modelo, c.descricao AS categoria,
       p.cpf, p.nome AS proprietario
FROM veiculo v
JOIN proprietario p ON p.cpf = v.cpf_proprietario
JOIN modelo m ON m.codigo_modelo = v.codigo_modelo
JOIN categoria c ON c.codigo_categoria = v.codigo_categoria
WHERE v.cpf_proprietario = @cpf;

-- B) Proprietários por qualquer parte do nome
SET @nome = 'silva';
SELECT cpf, nome, endereco, bairro, cidade, estado, sexo, data_nascimento, idade
FROM vw_proprietario
WHERE nome LIKE CONCAT('%', @nome, '%')
ORDER BY nome;

-- C) Infrações e dados do veículo em um período (DE ... ATÉ ...)
SET @de  = '2026-01-01';
SET @ate = '2026-06-30';
SELECT i.id_infracao, i.data_hora, t.descricao AS tipo_infracao, t.valor,
       i.latitude, i.longitude, i.velocidade_afetada, l.velocidade_permitida,
       a.nome AS agente,
       v.placa, v.chassi, v.cor_predominante, v.ano_fabricacao,
       m.descricao AS modelo, c.descricao AS categoria
FROM infracao i
JOIN veiculo v        ON v.placa = i.placa
JOIN modelo m         ON m.codigo_modelo = v.codigo_modelo
JOIN categoria c      ON c.codigo_categoria = v.codigo_categoria
JOIN tipo_infracao t  ON t.codigo_tipo = i.codigo_tipo
JOIN local_infracao l ON l.latitude = i.latitude AND l.longitude = i.longitude
JOIN agente a         ON a.matricula = i.matricula_agente
WHERE i.data_hora >= @de AND i.data_hora < DATE_ADD(@ate, INTERVAL 1 DAY)
ORDER BY i.data_hora;

-- D) Quantidade de veículos por modelo (ordem decrescente)
SELECT m.codigo_modelo, m.descricao AS modelo, COUNT(v.placa) AS qtd_veiculos
FROM modelo m
LEFT JOIN veiculo v ON v.codigo_modelo = m.codigo_modelo
GROUP BY m.codigo_modelo, m.descricao
ORDER BY qtd_veiculos DESC, m.descricao;
