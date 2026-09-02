-- ============================================================
-- BLOCO 3: RETENÇÃO (COHORT ANALYSIS)
-- ============================================================

-- Pergunta 7: Usuários com reprodução, agrupados pela coorte (mês de cadastro)
WITH usuarios_reproducoes AS (
    SELECT t1.id_usuario, strftime('%Y-%m', data_cadastro) AS mes,
           COUNT(t2.id_reproducao) AS QtdReproducoes
    FROM usuarios AS t1
    JOIN reproducoes AS t2 ON t1.id_usuario = t2.id_usuario
    GROUP BY t1.id_usuario, mes
)
SELECT mes, COUNT(DISTINCT id_usuario) AS QtdUsuarios
FROM usuarios_reproducoes
GROUP BY mes
ORDER BY mes;
