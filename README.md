# Análise de Dados de uma Plataforma de Streaming — SQL Puro

Segundo projeto de SQL do meu cronograma de estudos em análise de dados. Depois de um primeiro projeto com uma base pequena, quis um desafio mais próximo do que se vê no mercado: uma base maior, com histórico ao longo do tempo, e perguntas de negócio mais avançadas — retenção, churn, RFM.

## Objetivo

Simular a análise de dados de uma plataforma de streaming de música e vídeo, olhando pra consumo, engajamento, assinaturas/cancelamentos e comportamento dos usuários ao longo do tempo.

## Sobre o banco de dados

Base sintética com 5 tabelas e cerca de 2 mil registros no total:

| Tabela | O que tem | Linhas |
|---|---|---|
| `usuarios` | id_usuario, nome, idade, cidade, data_cadastro, plano | 50 |
| `conteudos` | id_conteudo, titulo, tipo, genero, duracao_min, ano_lancamento | 28 |
| `assinaturas` | id_assinatura, id_usuario, plano, data_inicio, data_fim, status | 60 |
| `reproducoes` | id_reproducao, id_usuario, id_conteudo, data_reproducao, duracao_assistida_min | ~1800 |
| `avaliacoes` | id_avaliacao, id_usuario, id_conteudo, nota, data_avaliacao | ~190 |

## Perguntas respondidas

**Consumo e engajamento**
1. Quais os 5 conteúdos mais reproduzidos?
2. Qual o percentual médio de conclusão por tipo de conteúdo?
3. Quais os 5 usuários mais ativos?

**Assinaturas e churn**
4. Quantas assinaturas ativas e canceladas por plano?
5. Qual a taxa de churn por plano?
6. Quais usuários cancelaram e depois voltaram a assinar?

**Retenção (cohort analysis)**
7. Quantos usuários de cada coorte (mês de cadastro) tiveram atividade?

**Window functions avançadas**
8. Qual o intervalo em dias entre reproduções consecutivas de cada usuário?
9. Ranking dos conteúdos mais bem avaliados dentro de cada gênero.

**Self-join e comparações**
10. Quais pares de usuários assistiram o mesmo conteúdo no mesmo dia?
11. Como a nota média por gênero varia entre usuários com menos de 30 anos e 30+?

**RFM simplificado**
12. Recência, frequência e faixa de engajamento (Alto/Médio/Baixo) de cada usuário.

## O que usei de SQL

- Agregação condicional com CASE WHEN dentro de COUNT/AVG
- CTEs encadeadas para separar cálculos em etapas
- Window functions: LAG (intervalo entre eventos) e RANK com PARTITION BY (ranking por grupo)
- Self-join com condição de desigualdade para evitar pares duplicados
- Manipulação de datas com strftime e julianday
- CROSS JOIN para combinar uma métrica de referência com todas as linhas

## Cuidados técnicos que apareceram pelo caminho

Vale registrar dois erros que cometi e corrigi durante o projeto, porque são armadilhas comuns em SQL:

- **Divisão inteira**: ao calcular percentuais (conclusão de conteúdo, taxa de churn), dividir dois números inteiros no SQLite trunca o resultado. A correção é multiplicar por `100.0` (com casas decimais) antes da divisão, não depois.
- **Filtro antes da agregação**: na pergunta sobre reassinatura, filtrar por `status = 'cancelada'` antes de contar as assinaturas de um usuário conta só as canceladas, não o total — o que muda completamente a resposta. A solução foi usar `HAVING` com duas condições separadas, sem o `WHERE` prévio.

## Arquivos

- `01_consumo_engajamento.sql`
- `02_assinaturas_churn.sql`
- `03_retencao_cohort.sql`
- `04_window_functions_avancadas.sql`
- `05_selfjoin_comparacoes.sql`
- `06_rfm_simplificado.sql`
- `usuarios.csv`, `conteudos.csv`, `assinaturas.csv`, `reproducoes.csv`, `avaliacoes.csv`
- `streaming.db`

## Algumas coisas que percebi

A taxa de churn varia bastante por plano — o plano Básico tem quase o dobro da taxa de cancelamento do plano Premium, o que sugere que assinantes de planos mais caros tendem a ficar mais tempo. A análise de coorte mostrou crescimento na base de usuários mês a mês. E cruzando idade com avaliação, alguns gêneros (como Ação e Eletrônica) são melhor avaliados por usuários mais velhos, enquanto outros (Comédia, Documentário) vão melhor com o público mais jovem.
