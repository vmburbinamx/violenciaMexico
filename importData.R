library(readxl)
library(writexl)
library(dplyr)
library(tidyr)
newNames <- c("ANO", "CLAVE_ENT", "ENTIDAD", "BIEN_JURIDICO_AFECTADO", "TIPO_DE_DELITO", "SUBTIPO_DE_DELITO", "MODALIDAD", "SEXO", "RANGO_DE_EDAD",  "ENERO", "FEBRERO", "MARZO", "ABRIL", "MAYO", "JUNIO", "JULIO", "AGOSTO", "SEPTIEMBRE", "OCTUBRE", "NOVIEMBRE", "DICIEMBRE")
data <- read_excel("datos.xlsx", col_types = c("text", 
                                 "text", "text", "text", "text", "text", 
                                 "text", "text", "text", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", "numeric", 
                                 "numeric", "numeric"),
                   col_names = newNames,
                   skip = 1)
remove(newNames)
data <- data %>% filter(TIPO_DE_DELITO == "Homicidio", SUBTIPO_DE_DELITO == "Homicidio doloso")

data <- data %>% select(-c(CLAVE_ENT, BIEN_JURIDICO_AFECTADO, TIPO_DE_DELITO, SUBTIPO_DE_DELITO, MODALIDAD, SEXO, RANGO_DE_EDAD))

data <- data %>% gather("MES", "TOTAL", 3:ncol(data))

data <- data %>% group_by(ENTIDAD, ANO, MES) %>% summarise(TOTAL = sum(TOTAL))

data <- data %>% mutate(MES_EN_NUMERO = case_when(MES == "ENERO" ~ 1L,
                                                  MES == "FEBRERO" ~ 2L,
                                                  MES == "MARZO" ~ 3L,
                                                  MES == "ABRIL" ~ 4L,
                                                  MES == "MAYO" ~ 5L,
                                                  MES == "JUNIO" ~ 6L,
                                                  MES == "JULIO" ~ 7L,
                                                  MES == "AGOSTO" ~ 8L,
                                                  MES == "SEPTIEMBRE" ~ 9L,
                                                  MES == "OCTUBRE" ~ 10L,
                                                  MES == "NOVIEMBRE" ~ 11L,
                                                  MES == "DICIEMBRE" ~ 12L))

write_xlsx(data, path = "exportData.xlsx")
