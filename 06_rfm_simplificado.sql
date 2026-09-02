-- ============================================================
-- BLOCO 6: RFM SIMPLIFICADO
-- ============================================================

-- Pergunta 12: Recência, frequência e faixa de engajamento por usuário
WITH engajamento AS (
    SELECT
        id_usuario,
        MAX(data_reproducao) AS UltimaReproducao,
        COUNT(id_reproducao) AS Frequencia
    FROM reproducoes
    GROUP BY id_usuario
),
data_referencia AS (
    SELECT MAX(data_reproducao) AS DataMaisRecente
    FROM reproducoes
)
SELECT
    e.id_usuario,
    e.Frequencia,
    CAST(julianday(d.DataMaisRecente) - julianday(e.UltimaReproducao) AS INTEGER) AS Recencia,
    CASE
        WHEN e.Frequencia >= 45 THEN 'Alto'
        WHEN e.Frequencia >= 25 THEN 'Médio'
        ELSE 'Baixo'
    END AS FaixaEngajamento
FROM engajamento AS e
CROSS JOIN data_referencia AS d
ORDER BY e.Frequencia DESC;
