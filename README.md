# Radar da Economia Brasileira

Análise exploratória e preditiva da economia brasileira, cobrindo juros, inflação, câmbio, atividade econômica e mercado de trabalho entre **2010 e setembro de 2026**.

O projeto também desenvolve um modelo de machine learning para prever o IPCA do mês seguinte e compara seu desempenho com referências simples. Um relatório técnico completo, com gráficos e glossário, está no arquivo `Relatorio_Radar_Economia_Brasileira.pdf`.

<img width="931" height="923" alt="Captura de Tela 2026-10-26 às 10 33 26" src="https://github.com/user-attachments/assets/f8d353bd-3c29-48df-b2d3-31b38aea275e" />

## Perguntas e respostas

**1. Como a Selic se relaciona com a inflação?**
A relação mais forte aparece cerca de **13 meses depois** (correlação de **-0,53**), compatível com o efeito defasado da política monetária.

**2. Qual foi o juro real e quando a política monetária foi mais restritiva?**
O juro real ex-post ficou negativo em **21 meses**, todos na pandemia, e atingiu o maior nível da série em **fevereiro de 2026: 10,78% a.a.**

**3. Quanto da variação do dólar chega ao IPCA?**
Pouco. O repasse foi pequeno e significativo apenas com **quatro meses de defasagem** (≈ 0,022 p.p. por 1% de variação do dólar).

**4. A atividade e o emprego responderam aos juros altos?**
De forma fraca. Entre 2023 e 2026, a atividade econômica e o emprego permaneceram resilientes mesmo com juros reais elevados. A correlação entre Selic e desemprego no mesmo mês reflete sobretudo o Banco Central reagindo a um mercado aquecido (causalidade reversa), e não o efeito do juro sobre o emprego.

**5. É possível prever o IPCA do mês seguinte melhor que referências simples?**
Sim, por margem modesta: **Random Forest** e **Ridge** reduziram o MAE em cerca de **5% a 6%** frente à média de 12 meses. A previsão para **outubro de 2026** foi de **0,53%**, com intervalo empírico de 90% entre **0,07% e 1,12%**.

## Dados

As séries foram obtidas da API de Séries Temporais do **Banco Central do Brasil (SGS)**:

| Indicador | Código SGS | Uso |
|---|---:|---|
| IPCA mensal | 433 | Inflação e variável-alvo |
| Selic meta | 432 | Política monetária |
| Dólar comercial, venda | 1 | Câmbio |
| Taxa de desocupação | 24369 | Mercado de trabalho |
| IBC-Br | 24363 | Atividade econômica |

## Metodologia

- Coleta das séries por API em Python e armazenamento de arquivos de backup.
- Carga e transformação dos dados no **Google BigQuery** utilizando SQL.
- Construção de uma base mensal com IPCA acumulado em 12 meses, Selic média, dólar médio, IBC-Br, desemprego e juro real ex-post.
- Análise exploratória com correlações defasadas, regressões com erros-padrão robustos e identificação de períodos econômicos relevantes.
- Modelagem com variáveis defasadas, sazonalidade, **Ridge** e **Random Forest**. Desemprego e IBC-Br ficaram de fora por serem divulgados com atraso.
- Validação temporal do tipo **walk-forward**, com 72 meses de teste, sem embaralhamento dos dados.
- Disponibilização dos resultados em dashboards no **Looker Studio** e em uma visualização interativa em HTML.

## Desempenho dos modelos

Erros em pontos percentuais do IPCA mensal; menor é melhor.

| Modelo | MAE | RMSE | MAE sem mar/2020 a dez/2022 |
|---|---:|---:|---:|
| Random Forest | 0,285 | 0,378 | 0,216 |
| Ridge | 0,289 | 0,377 | 0,217 |
| Média dos últimos 12 meses | 0,304 | 0,422 | 0,230 |
| Mês anterior | 0,323 | 0,432 | 0,273 |
| Mesmo mês do ano anterior | 0,394 | 0,518 | 0,280 |

O ganho se manteve ao excluir os anos de pandemia, o que indica que ele não depende desse período. Random Forest e Ridge tiveram desempenho equivalente. A inflação recente foi a variável mais importante, seguida pela sazonalidade e pelas variações defasadas do dólar. A Selic teve menor peso no horizonte de um mês.

**Acompanhamento da previsão**

| Mês | Previsto | Real | Erro |
|---|---:|---:|---:|
| Out/2026 | 0,53% | _a preencher após divulgação do IBGE_ | _a preencher_ |

## Tecnologias

- **Python**: análise, modelagem e visualizações
- **SQL**: transformação e organização dos dados
- **Google Cloud BigQuery**: armazenamento e processamento
- **Looker Studio**: dashboard analítico
- **HTML e JavaScript (Chart.js)**: dashboard interativo complementar
- **Banco Central do Brasil (SGS)**: fonte dos dados

## Limitações

- Amostra mensal relativamente pequena, com aproximadamente 190 observações.
- Ganho preditivo modesto e sem teste estatístico formal da diferença entre modelos.
- Choques estruturais, como pandemia, guerra e mudanças tributárias, podem romper padrões históricos e não são captados pelo modelo.
- Foram utilizadas séries revisadas, e não necessariamente os dados disponíveis no momento de cada previsão.
- Correlação não implica causalidade; há, por exemplo, possível causalidade reversa entre juros e desemprego.
- O modelo de repasse cambial não controla commodities, preços administrados ou expectativas de inflação.
- A previsão de um mês à frente não deve ser extrapolada para horizontes mais longos.

## Como reproduzir

```bash
git clone https://github.com/vidigal22/radar-economia-br.git
cd radar-economia-br
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
gcloud auth application-default login
```

Crie o dataset `economia_br` no BigQuery (região **US**), troque o `PROJECT_ID` nos notebooks e execute-os na ordem. Rode `sql/01_vw_base_mensal.sql` antes do notebook da base mensal e os demais arquivos de `sql/` depois do notebook do modelo. No BigQuery Sandbox as tabelas expiram em 60 dias; os CSVs em `data/` permitem refazer o processo. Nunca suba credenciais ao GitHub.

## Conclusão

O projeto mostra que a política monetária atua com defasagem sobre a inflação, que o repasse cambial recente é pequeno e que modelos simples superam, por margem modesta, referências ingênuas na previsão do IPCA. Os resultados servem como apoio ao acompanhamento de cenários e não substituem a análise de choques de política e de preços administrados, onde ocorrem os maiores erros de previsão.
