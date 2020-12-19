# Leitura GAL
library(tidyverse)
library(lubridate)

# Pastas
pasta_exames <- "dados/exames/"
pasta_virus <- "dados/virus/"
pasta_fx_etaria <- "dados/fx_etaria/"

# Exames
files_exames <- list.files(pasta_exames, full.names = TRUE)
exames <- tibble()
for(file in files_exames){
  file_date <- as_date(substr(file, 78, 87))
  
  tmp <- read_csv(file = file, col_types = cols(
    `UF de residência` = col_character(),
    Resultados = col_character(),
    `Nº de exames realizados` = col_character())
  ) %>%
    mutate(date = file_date) %>%
    select(date, uf =  `UF de residência`, resultado = `Resultados`, freq_exames = `Nº de exames realizados`) %>%
    mutate(freq_exames = parse_number(freq_exames, locale = locale(grouping_mark = ".", decimal_mark = ",")))
  
  exames <- bind_rows(exames, tmp)
}


exames <- exames %>%
  pivot_wider(id_cols = c("date", "uf"), names_from = resultado, values_from = freq_exames) %>%
  rename(negativo = `Negativo / Não Detectável`, positivo = `Positivo / Detectável`, inconclusivo = `Inconclusivo / Indeterminado`) %>%
  mutate(n_exames = rowSums(.[3:5], na.rm = TRUE)) %>%
  select(date, uf, n_exames)




# Virus
files_virus <- list.files(pasta_virus, full.names = TRUE)
virus <- tibble()
for(file in files_virus){
  file_date <- as_date(substr(file, 76, 85))
  
  tmp <- read_csv(file = file, col_types = cols(
    `UF de residência` = col_character(),
    Vírus = col_character(),
    `Nº de vírus identificados` = col_character()
  )) %>%
    mutate(date = file_date) %>%
    select(date, uf =  `UF de residência`, virus = `Vírus`, freq_virus = `Nº de vírus identificados`) %>%
    mutate(freq_virus = parse_number(freq_virus, locale = locale(grouping_mark = ".", decimal_mark = ",")))
  
  virus <- bind_rows(virus, tmp)
}


covid19 <- virus %>%
  filter(virus == "Coronavirus SARS-CoV2") %>%
  select(-virus)

positividade <- left_join(exames, covid19, by = c("date", "uf")) %>%
  mutate(perc = round(freq_virus/n_exames*100, 2))

positividade %>%
  ggplot(aes(x = date, y = perc)) +
  geom_line() + 
  facet_wrap(~ uf) + 
  labs(
    title = "Positividade", 
    subtitle = "Testes RT-PCR",
    caption = "Fonte: Sistema Gerenciador de Ambiente Laboratorial (GAL)"
  ) +
  xlab("Data de coleta") + ylab("Percentual de exames positivos para SARS-CoV2")



positividade %>%
  select(date, uf, n_exames, freq_virus) %>%
  pivot_longer(cols = c("n_exames", "freq_virus")) %>%
  mutate(name = recode(name, "freq_virus" = "Exames positivo SARS-CoV2", "n_exames" = "Exames coletados")) %>%
  ggplot(aes(x = date, y = value, colour = name)) +
  geom_line() + 
  facet_wrap(~ uf, scales = "free_y") + 
  labs(
    title = "Testes RT-PCR", 
    caption = "Fonte: Sistema Gerenciador de Ambiente Laboratorial (GAL)",
    colour = ""
  ) +
  theme(legend.position = "bottom") +
  xlab("Data de coleta") + ylab("Percentual de exames positivos para SARS-CoV2")
