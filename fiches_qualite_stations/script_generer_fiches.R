#' Ce script permet de générer les fiches de mise en qualité pour chaque station.


# lecture des stations

stations_etude<-readRDS(here::here("Data/clean_data", 
             "codes_stations_suivies.rds"))

#Création des dossiers pour stocker les fichiers créés
dir.create(
  "R:/Public/04_SRC/CARHYCE/CDD/Mise_en_qualite/Fiches_stations",
  recursive = TRUE,
  showWarnings = FALSE
)

dir.create(
  "fiches_qualite_stations/figures", 
  showWarnings = FALSE) #permet de stocker les fichiers temporaires


#-------------------------------------------------------------------------------
# Format html
#-------------------------------------------------------------------------------

for (i in seq_along(stations_etude)) {
  
  id <- stations_etude[i]

  message(
    "Génération de la fiche ",
    i, "/",
    length(stations_etude),
    " - Station ",
    id)

  #boucle pour ne pas arrêter de générer l'ensemble des fiches si une erreur 
  #se produit pour une fiche
  
  tryCatch(
    
    {
      rmarkdown::render(
        here::here(
          "fiches_qualite_stations",
          "Template_Fiches_qualite.Rmd"
        ),
        output_format = "html_document",
        output_dir =
          "R:/Public/04_SRC/CARHYCE/CDD/Mise_en_qualite/Fiches_stations",
        output_file =
          paste0("Fiche-station-", id, ".html"),
        params = list(
          code_station = id
        ),
        clean = TRUE,
        quiet = TRUE
      )
      
      message("Fiche créée : Fiche-station-", id, ".html")
      
    },
    
    error = function(e) {
      
      message(
        "ERREUR pour la station ",
        id,
        " : ",
        e$message
      )
      
    }
    
  )
}


# Supprimer les éventuels fichiers temporaires restants
unlink("fiches_qualite_stations/figures", recursive = TRUE)
unlink("fiches_qualite_stations/rosm.cache", recursive = TRUE)
unlink("fiches_qualite_stations/*.log")
unlink("fiches_qualite_stations/*.aux")
unlink("fiches_qualite_stations/*.tex")
unlink("fiches_qualite_stations/*.out")

