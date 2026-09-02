-- ============================================================
-- BLOCO 1: CONSUMO E ENGAJAMENTO
-- ============================================================

-- Pergunta 1: Os 5 conteúdos com mais reproduções
SELECT
    t1.titulo,
    COUNT(t2.id_reproducao) AS QtdVezes
FROM conteudos AS t1
JOIN reproducoes AS t2 ON t1.id_conteudo = t2.id_conteudo
GROUP BY t1.titulo
ORDER BY QtdVezes DESC
LIMIT 5;

-- Pergunta 2: Percentual médio de conclusão por tipo de conteúdo
SELECT
    t1.tipo,
    ROUND(AVG(100.0 * t2.duracao_assistida_min / t1.duracao_min), 2) AS PercentualConclusao
FROM conteudos AS t1
JOIN reproducoes AS t2 ON t1.id_conteudo = t2.id_conteudo
GROUP BY t1.tipo;

-- Pergunta 3: Os 5 usuários mais ativos (mais reproduções)
SELECT
    t1.nome,
    COUNT(t2.id_reproducao) AS QtdReproducoes
FROM usuarios AS t1
JOIN reproducoes AS t2 ON t1.id_usuario = t2.id_usuario
GROUP BY t1.id_usuario, t1.nome
ORDER BY QtdReproducoes DESC
LIMIT 5;
