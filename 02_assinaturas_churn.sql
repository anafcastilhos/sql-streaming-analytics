-- ============================================================
-- BLOCO 2: ASSINATURAS E CHURN
-- ============================================================

-- Pergunta 4: Assinaturas ativas vs canceladas, por plano
SELECT
    plano,
    COUNT(CASE WHEN status = 'ativa' THEN 1 END) AS QtdAtivas,
    COUNT(CASE WHEN status = 'cancelada' THEN 1 END) AS QtdCanceladas
FROM assinaturas
GROUP BY plano;

-- Pergunta 5: Taxa de cancelamento (churn) por plano
WITH assinaturas_canceladas AS (
    SELECT plano, COUNT(id_assinatura) AS QtdCancelada
    FROM assinaturas
    WHERE status = 'cancelada'
    GROUP BY plano
),
todas_assinaturas AS (
    SELECT plano, COUNT(id_assinatura) AS TodasAssinaturas
    FROM assinaturas
    GROUP BY plano
)
SELECT
    t1.plano,
    ROUND(100.0 * QtdCancelada / TodasAssinaturas, 2) AS taxaChurn
FROM assinaturas_canceladas AS t1
JOIN todas_assinaturas AS t2 ON t1.plano = t2.plano;

-- Pergunta 6: Usuários que cancelaram e depois voltaram a assinar
SELECT
    id_usuario,
    COUNT(id_assinatura) AS QtdAssinaturas
FROM assinaturas
GROUP BY id_usuario
HAVING QtdAssinaturas > 1
   AND COUNT(CASE WHEN status = 'cancelada' THEN 1 END) > 0;
