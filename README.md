# dadosgal

Scripts para download e processamentos de dados agregados do GAL.

## download_gal.R

Realiza o download dos dados do GAL no painel de dados Kibana disponibilizados pelo Ministério da Saúde. É utilizado um filtro de data (`data_coleta`) e os dados dos gráficos são baixados, dia após dia. 

## leitura_gal.R

Faz a leitura dos arquivos baixados em um `data.frame` consolidado, calcula a positividade dos testes e plota gráficos.