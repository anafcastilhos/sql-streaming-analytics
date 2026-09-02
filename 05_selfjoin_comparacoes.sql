-- ============================================================
-- BLOCO 5: SELF-JOIN E COMPARAÇÕES
-- ============================================================

-- Pergunta 10: Pares de usuários que assistiram o mesmo conteúdo no mesmo dia
SELECT
    t1.id_usuario AS Usuario1,
    t2.id_usuario AS Usuario2,
    t1.id_conteudo,
    t1.data_reproducao
FROM reproducoes AS t1
JOIN reproducoes AS t2
    ON t1.id_conteudo = t2.id_conteudo
    AND t1.data_reproducao = t2.data_reproducao
    AND t1.id_usuario < t2.id_usuario;

-- Pergunta 11: Nota média por gênero, comparando usuários com menos de 30 anos vs 30+
SELECT
    t3.genero,
    CASE WHEN t1.idade < 30 THEN 'Menos de 30' ELSE '30 ou mais' END AS FaixaEtaria,
    ROUND(AVG(t2.nota), 2) AS NotaMedia
FROM usuarios AS t1
JOIN avaliacoes AS t2 ON t1.id_usuario = t2.id_usuario
JOIN conteudos AS t3 ON t2.id_conteudo = t3.id_conteudo
GROUP BY t3.genero, FaixaEtaria
ORDER BY t3.genero, FaixaEtaria;
