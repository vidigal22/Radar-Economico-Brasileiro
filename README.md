# Radar da Economia Brasileira

Análise exploratória e preditiva da economia brasileira, cobrindo juros, inflação, câmbio, atividade econômica e mercado de trabalho entre **2010 e setembro de 2026**.

O projeto também desenvolve um modelo de machine learning para prever o IPCA do mês seguinte e compara seu desempenho com referências simples.

> **Aviso:** este projeto tem fins educacionais e analíticos. Não constitui recomendação de investimento.

## Destaques

- A Selic apresentou sua relação mais forte com a inflação aproximadamente **13 meses depois**, com correlação de **-0,53**.
- O juro real ex-post atingiu o maior nível da série em **fevereiro de 2026: 10,78% a.a.**
- O repasse da variação do dólar para o IPCA foi pequeno e apareceu principalmente com **quatro meses de defasagem**.
- Entre 2023 e 2026, a atividade econômica e o emprego permaneceram resilientes mesmo com juros reais elevados.
- Os modelos **Random Forest** e **Ridge** superaram as referências simples, mas com ganho modesto: cerca de **5% a 6% de redução no MAE** em relação à média de 12 meses.
- A previsão do IPCA para **outubro de 2026** foi de **0,53%**, com intervalo empírico de 90% entre **0,07% e 1,12%**.

## Objetivos

1. Investigar a relação entre Selic, inflação, câmbio, atividade econômica e desemprego.
2. Avaliar a defasagem dos efeitos da política monetária sobre a inflação.
3. Estimar o repasse cambial para o IPCA.
4. Analisar o comportamento da atividade econômica durante períodos de juros elevados.
5. Construir e validar modelos para previsão do IPCA mensal.

## Dados

As séries foram obtidas da API de Séries Temporais do **Banco Central do Brasil (SGS)**:

| Indicador | Código SGS | Uso |
|---|---:|---|
| IPCA mensal | 433 | Inflação e variável-alvo |
| Selic meta | 432 | Política monetária |
| Dólar comercial — venda | 1 | Câmbio |
| Taxa de desocupação | 24369 | Mercado de trabalho |
| IBC-Br | 24363 | Atividade econômica |

## Metodologia

- Coleta automatizada das séries por API e armazenamento de arquivos de backup.
- Carga e transformação dos dados no **Google BigQuery** utilizando SQL.
- Construção de uma base mensal com IPCA acumulado em 12 meses, Selic média, dólar médio, IBC-Br, desemprego e juro real ex-post.
- Análise exploratória com correlações defasadas, regressões com erros-padrão robustos e identificação de períodos econômicos relevantes.
- Modelagem com variáveis defasadas, sazonalidade, **Ridge** e **Random Forest**.
- Validação temporal do tipo **walk-forward**, com 72 meses de teste, sem embaralhamento dos dados.
- Disponibilização dos resultados em dashboards no **Looker Studio** e em uma visualização interativa em HTML.

## Desempenho dos modelos

Erros em pontos percentuais do IPCA mensal; menor é melhor.

| Modelo | MAE | RMSE |
|---|---:|---:|
| Random Forest | 0,285 | 0,378 |
| Ridge | 0,289 | 0,377 |
| Média dos últimos 12 meses | 0,304 | 0,422 |
| Mês anterior | 0,323 | 0,432 |
| Mesmo mês do ano anterior | 0,394 | 0,518 |

A inflação recente foi a variável mais importante para a previsão, seguida pela sazonalidade e pelas variações defasadas do dólar. A Selic teve menor peso no horizonte de um mês, embora sua influência seja mais relevante em horizontes longos.

## Tecnologias

- **Python** — análise, modelagem e visualizações
- **SQL** — transformação e organização dos dados
- **Google Cloud BigQuery** — armazenamento e processamento
- **Looker Studio** — dashboard analítico
- **HTML** — dashboard interativo complementar
- **Banco Central do Brasil (SGS)** — fonte dos dados

## Limitações

- Amostra mensal relativamente pequena, com aproximadamente 190 observações.
- Ganho preditivo modesto e sem teste estatístico formal da diferença entre modelos.
- Choques estruturais, como pandemia, guerra e mudanças tributárias, podem romper padrões históricos.
- Foram utilizadas séries revisadas, e não necessariamente os dados disponíveis no momento de cada previsão.
- Correlação não implica causalidade; há, por exemplo, possível causalidade reversa entre juros e desemprego.
- O modelo de repasse cambial não controla commodities, preços administrados ou expectativas de inflação.
- A previsão de um mês à frente não deve ser extrapolada para horizontes mais longos.

## Conclusão

O **Radar da Economia Brasileira** transforma dados públicos em informação acionável para o acompanhamento de cenários econômicos. Ao combinar indicadores de inflação, juros, câmbio, atividade e emprego com modelos preditivos e dashboards interativos, o projeto apoia empresas, analistas e gestores na identificação de tendências, avaliação de riscos e planejamento de decisões. Os resultados mostram que a previsão automatizada agrega valor em relação a referências simples, mas deve ser integrada ao contexto econômico e ao julgamento estratégico — especialmente em períodos de choques e mudanças de política.
