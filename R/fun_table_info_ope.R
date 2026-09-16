# Sélection et arrangement des données

table_info_ope <- function(data, id_station){
  
  info_ope <- data %>%
    dplyr::filter(
      Code_station_SANDRE == id_station) %>% 
    dplyr::select(
           Code_station_SANDRE, 
           code_pt_prelevement,
           OPE_ID,
           OPE_VERSION_PROTOCOLE_LIBELLE,
           OPE_DATE_REALISATION,
           RME_NOM,
           PRO_LIBELLE,
           VAL_LIBELLE,
           QUA_LIBELLE) %>% 
    dplyr::distinct() %>% 
    dplyr::mutate(
      OPE_DATE_REALISATION = base::as.Date(
        OPE_DATE_REALISATION, 
        format = "%d/%m/%Y"),
      OPE_ID = base::as.numeric(OPE_ID))%>% 
    dplyr::arrange(Code_station_SANDRE,
                   OPE_DATE_REALISATION) %>% 
    
    #Mise en forme avec gt()
    gt::gt() %>% 
    gt::tab_options(
      table.font.size = 13,            # taille de police
      table.border.top.color = "black",
      table.border.bottom.color = "black",
      table.border.top.width = px(2),
      table.border.bottom.width = px(2)
    ) %>% 
    gt::cols_label(
      Code_station_SANDRE  = "code_station",
      code_pt_prelevement = "point_prelevement",
      OPE_VERSION_PROTOCOLE_LIBELLE = "version_protocole",
      OPE_DATE_REALISATION = "ope_date",
      RME_NOM ="réseau",
      PRO_LIBELLE = "avancement",
      VAL_LIBELLE = "validation",
      QUA_LIBELLE ="qualification"
    ) %>% 
    gt::cols_align(align = "left") %>% 
    gt::tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_column_labels()   
    )
  
  #afficher le tableau mis en forme
  info_ope
  
}
