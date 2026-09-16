#' Fonction permettant de mettre en forme la table "informations sur la station"
#' On utilise ici les données que l'on a préparé précédemment avec la fonction
#' prepare_data()

table_info_station <- function(data){
  
  
  #afficher un message SI il y a plusieurs points de prélèvement pour la station 
  if (data$nombre_pt_prelevement > 1) {
    
    base::cat(
      base::paste0(
        "<div class='alerte-rouge'>", #mise en forme définie dans le css
        "⚠ Plusieurs points de prélèvement !", #message à afficher
        "</div>"
      )
    )
  }
  
  # Passage au format long 
  info_station_long <- data %>% 
    dplyr::mutate(
      dplyr::across(
        dplyr::everything(), 
        as.character)) %>%
    tidyr::pivot_longer(
      cols = dplyr::everything(),
      names_to = "variable",
      values_to = "valeur") %>% 
    
  #mise en forme du tableau avec gt()
    gt::gt() %>% 
    gt::tab_options(
      column_labels.hidden = TRUE,     # cacher les noms de colonnes
      table.font.size = 13,            # taille de police
      table.border.top.color = "black",
      table.border.bottom.color = "black",
      table.border.top.width = px(2),
      table.border.bottom.width = px(2)
    ) %>% 
    gt::cols_align(align = "left") %>% #aligner le texte sur la gauche
    gt::tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_body(columns = 1)   # première colonne en gras
    )
  #retourner le tableau
  info_station_long
  
}