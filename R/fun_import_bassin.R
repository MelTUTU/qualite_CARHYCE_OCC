#' Importer l'ensemble des fichiers .csv téléchargés lors des exports de données CARHYCE.
#'
#' @param dossier chemin d'accès du dossier dans lequel se trouvent les tables à importer.

import_bassin <- function(dossier) {
  # Recherche de tous les fichiers .csv du dossier
  fichiers <- list.files(
    dossier,
    pattern = "\\.csv$",
    #pattern à repérer
    full.names = TRUE # récupérer le chemin complet
  )
  
  #création d'une liste nommée
  setNames(
    #Lecture successive de chaque fichier .csv
    lapply(fichiers, function(f) {
      #nom du fichier sans le chemin, utilisé pour les messages affichés lors de l'import
      nom_fichier <- basename(f)
      
      #tentative de lecture du fichier
      table <- tryCatch({
        # Message indiquant la méthode de lecture utilisée
        message("Lecture de ",
                nom_fichier,
                " : méthode avec encoding = 'Latin-1' et fill=TRUE")
        
        # Lecture du fichier CSV
        # fill = TRUE permet de compléter les lignes dont le
        # nombre de colonnes est inférieur à celui attendu
        fread(
          f,
          sep = ";",
          dec = ".",
          colClasses = "character",
          encoding = "Latin-1",
          fill = TRUE
        )
      }, 
      error = function(e) {
        # Si la lecture précédente échoue,
        # affichage du message d'erreur retourné par fread()
        message(
          "Lecture de ",
          nom_fichier,
          " : échec méthode 1 -> tentative avec fill = FALSE ",
          e$message
        )
        
        # Nouvelle tentative de lecture sans fill = TRUE
        # Cette étape est nécessaire pour certains fichiers
        # contenant des guillemets mal interprétés par fread()
        fread(
          f,
          sep = ";",
          dec = ".",
          colClasses = "character",
          encoding = "Latin-1",
          fill = FALSE
        )
        
      })
      # Suppression des éventuels espaces avant ou après
      # les noms de variables
      setnames(table, trimws(names(table)))
      
      # Suppression des colonnes générées automatiquement
      # par fread() (V1, V2, V3, ...)
      # lorsqu'elles sont entièrement vides
      table <- supprimer_colonnes_vides(table)
      
      #retour de la table nettoyée
      table
      
    }),
    
    # Attribution du nom de chaque élément de la liste
    # Exemple :
    # OPERATION.csv -> OPERATION
    # TRANSECT.csv -> TRANSECT
    tools::file_path_sans_ext(basename(fichiers))
  )
}