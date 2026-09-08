#' Certains fichiers .csv présentent des colonnes supplémentaires crées lors de l'import 
#' Ces colonnes sont généralement dues à des séparateurs ";" en trop dans 
#' certaines lignes et ne contiennent aucune information
#' Cette fonction identifie ces colonnes et le supprime lorsque le nom est vide
#' ET que la variable ne contient aucune donnée

supprimer_colonnes_vides <- function(dt) {
  
  # Pour chaque colonne du tableau, détermine si elle doit être supprimée
  cols_a_supprimer <- sapply(names(dt), function(col) {
    
    # Vérifie si le nom de la colonne correspond à un nom généré
    # automatiquement par fread() : V1, V2, V3, ..
    nom_auto <- grepl("^V[0-9]+$", col)
    
    # Vérifie que toutes les valeurs de la colonne sont vides :
    # - NA
    # - chaîne de caractères vide ("")
    colonne_vide <- all(
      is.na(dt[[col]]) |
        dt[[col]] == ""
    )
    
    # La colonne sera supprimée uniquement si :
    # - son nom est du type V1, V2, ...
    # - et qu'elle est entièrement vide
    nom_auto && colonne_vide
  })
  
  # Conservation des colonnes qui ne sont pas à supprimer
  # (!cols_a_supprimer inverse le vecteur logique)
  dt[, !cols_a_supprimer, with = FALSE]
}
