# ETL GAL
library(tidyverse)
library(RSelenium)

# Pastas
pasta <- paste0(getwd(), "/dados/gal/tmp/")
pasta_exames <- paste0(getwd(), "/dados/gal/exames/")
pasta_virus <- paste0(getwd(), "/dados/gal/virus/")
pasta_fx_etaria <- paste0(getwd(), "/dados/gal/fx_etaria/")

rD <- rsDriver(browser = "firefox", check = FALSE, verbose = FALSE, 
               extraCapabilities = list(
                 "moz:firefoxOptions" = list(
                   args = list('--headless'),
                   prefs = list(
                     "browser.download.dir" = pasta,
                     "browser.download.folderList" = 2L,
                     "browser.download.manager.showWhenStarting" = FALSE,
                     "browser.helperApps.neverAsk.saveToDisk" = "application/xls;application/xlsx;text/csv;text/plain"
                   )))
)

remDr <- rD[["client"]]

remDr$navigate("https://dafbnafar-kb.saude.gov.br/s/desenvolvimento/app/kibana#/dashboard/dc5f0570-7f1f-11ea-ae22-c5191b41d130?_g=()")

Sys.sleep(15)


datas <- as.character(seq.Date(from = as.Date("2020-01-20"), to = Sys.Date(), by = "day"))


for(data in datas){
  message(data)
  
  webElem <- remDr$findElement(using = "class", "euiFieldText")
  webElem$clearElement()
  webElem$sendKeysToElement(list(paste0("data_coleta: ", data), key = "enter"))
  Sys.sleep(3)
  
  ## Exames
  
  # Clica no gráfico
  webElem <- remDr$findElement(using = "xpath", '//div[@data-test-subj="dashboardPanelHeading-Examesrealizados,segundoresultadoporUFderesidência"]/div[@class="dshPanel__headerButtonGroup"]/div[1]/div[1]/button')
  webElem$clickElement()
  Sys.sleep(1)
  
  # Clica no inspect
  webElem <- remDr$findElement(using = "xpath", '//button[@data-test-subj="dashboardPanelAction-openInspector"]')
  webElem$clickElement()
  Sys.sleep(1)
  
  # Clica no download
  webElem <- remDr$findElement(using = "xpath", '//div[@id="inspectorDownloadData"]/div[1]/button')
  webElem$clickElement()
  Sys.sleep(1)
  
  # Clica em Raw CSV
  webElem <- remDr$findElement(using = "xpath", '//span[1]/button[@class="euiContextMenuItem"]')
  webElem$clickElement()
  Sys.sleep(1)
  
  # Verifica download 
  
  download_ok <- FALSE
  while(download_ok == FALSE){
    novo <- list.files(path = pasta)
    
    if(length(novo) != 0){
      
      Sys.sleep(1)
      
      message("Download ok!")
      download_ok <- TRUE
    } else {
      message("Ainda não...")
      Sys.sleep(5)
    }
  }
  
  file.copy(from = paste0(pasta,novo), to = paste0(pasta_exames, "exames_", data, ".csv"))
  file.remove(paste0(pasta,novo))
  
  # Fecha janela
  webElem <- remDr$findElement(using = "xpath", '//button[@data-test-subj="euiFlyoutCloseButton"]')
  webElem$clickElement()
  Sys.sleep(1)
  
  
  ## Vírus identificados
  
  # Clica no gráfico
  webElem <- remDr$findElement(using = "xpath", '//div[@data-test-subj="dashboardPanelHeading-Vírusidentificados,segundoUFderesidência"]/div[@class="dshPanel__headerButtonGroup"]/div[1]/div[1]/button')
  webElem$clickElement()
  Sys.sleep(1)
  
  # Clica no inspect
  webElem <- remDr$findElement(using = "xpath", '//button[@data-test-subj="dashboardPanelAction-openInspector"]')
  webElem$clickElement()
  Sys.sleep(1)
  
  # Clica no download
  webElem <- remDr$findElement(using = "xpath", '//div[@id="inspectorDownloadData"]/div[1]/button')
  webElem$clickElement()
  Sys.sleep(1)
  
  # Clica em Raw CSV
  webElem <- remDr$findElement(using = "xpath", '//span[1]/button[@class="euiContextMenuItem"]')
  webElem$clickElement()
  Sys.sleep(1)
  
  # Verifica download 
  
  download_ok <- FALSE
  while(download_ok == FALSE){
    novo <- list.files(path = pasta)
    
    if(length(novo) != 0){
      
      Sys.sleep(1)
      
      message("Download ok!")
      download_ok <- TRUE
    } else {
      message("Ainda não...")
      Sys.sleep(5)
    }
  }
  
  file.copy(from = paste0(pasta,novo), to = paste0(pasta_virus, "virus_", data, ".csv"))
  file.remove(paste0(pasta,novo))
  
  # Fecha janela
  webElem <- remDr$findElement(using = "xpath", '//button[@data-test-subj="euiFlyoutCloseButton"]')
  webElem$clickElement()
  Sys.sleep(1)
  
  
  ## Faixa etária
  
  # Clica no gráfico
  webElem <- remDr$findElement(using = "xpath", '//div[@data-test-subj="dashboardPanelHeading-NúmerodeamostrascomcoronavírusSARS-CoV-2detectadoporRT-PCR,segundofaixaetária"]/div[@class="dshPanel__headerButtonGroup"]/div[1]/div[1]/button')
  webElem$clickElement()
  Sys.sleep(1)
  
  # Clica no inspect
  webElem <- remDr$findElement(using = "xpath", '//button[@data-test-subj="dashboardPanelAction-openInspector"]')
  webElem$clickElement()
  Sys.sleep(1)
  
  # Clica no download
  webElem <- remDr$findElement(using = "xpath", '//div[@id="inspectorDownloadData"]/div[1]/button')
  webElem$clickElement()
  Sys.sleep(1)
  
  # Clica em Raw CSV
  webElem <- remDr$findElement(using = "xpath", '//span[1]/button[@class="euiContextMenuItem"]')
  webElem$clickElement()
  Sys.sleep(1)
  
  # Verifica download 
  
  download_ok <- FALSE
  while(download_ok == FALSE){
    novo <- list.files(path = pasta)
    
    if(length(novo) != 0){
      
      Sys.sleep(1)
      
      message("Download ok!")
      download_ok <- TRUE
    } else {
      message("Ainda não...")
      Sys.sleep(5)
    }
  }
  
  file.copy(from = paste0(pasta,novo), to = paste0(pasta_fx_etaria, "fx_etaria_", data, ".csv"))
  file.remove(paste0(pasta,novo))
  
  # Fecha janela
  webElem <- remDr$findElement(using = "xpath", '//button[@data-test-subj="euiFlyoutCloseButton"]')
  webElem$clickElement()
  Sys.sleep(1)
}

remDr$close()