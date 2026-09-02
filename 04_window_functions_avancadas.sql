-- ============================================================
-- BLOCO 4: WINDOW FUNCTIONS AVANÇADAS
-- ============================================================

-- Pergunta 8: Dias desde a reprodução anterior de cada usuário (LAG)
WITH reproducoes_com_lag AS (
    SELECT
        t1.id_usuario,
        t1.data_reproducao,
        LAG(t1.data_reproducao) OVER (
            PARTITION BY t1.id_usuario
            ORDER BY t1.data_reproducao
        ) AS data_anterior
    FROM reproducoes AS t1
)
SELECT
    id_usuario,
    data_reproducao,
    data_anterior,
    julianday(data_reproducao) - julianday(data_anterior) AS DiasDesdeUltima
FROM reproducoes_com_lag
ORDER BY id_usuario, data_reproducao;

-- Pergunta 9: Ranking de conteúdos mais bem avaliados por gênero
WITH media_por_conteudo AS (
    SELECT
        t1.id_conteudo,
        t1.titulo,
        t1.genero,
        AVG(t2.nota) AS NotaMedia
    FROM conteudos AS t1
    JOIN avaliacoes AS t2 ON t1.id_conteudo = t2.id_conteudo
    GROUP BY t1.id_conteudo, t1.titulo, t1.genero
)
SELECT
    genero,
    titulo,
    ROUND(NotaMedia, 2) AS NotaMedia,
    RANK() OVER (PARTITION BY genero ORDER BY NotaMedia DESC) AS Posicao
FROM media_por_conteudo
ORDER BY genero, Posicao;
