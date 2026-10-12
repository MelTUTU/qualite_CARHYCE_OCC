dispo_debit <- function(data){
  
  table_dispo_debit <- data %>%
    #création des variables contenant la mise en forme
    dplyr::mutate(
      lib_OPE_DEBIT_MESURE = if_else(
        is.na(OPE_DEBIT_MESURE),
        "❌",
        as.character(OPE_DEBIT_MESURE)
      ),
      lib_OPE_DEBIT_STATION_HYDRO = if_else(
        is.na(OPE_DEBIT_STATION_HYDRO),
        "❌",
        as.character(OPE_DEBIT_STATION_HYDRO)
      )
    ) %>%
    dplyr::select(
      OPE_ID,
      OPE_DATE_REALISATION,
      lib_OPE_DEBIT_MESURE,
      lib_OPE_DEBIT_STATION_HYDRO
    ) %>%
    #ranger par ordre croissant de date et d'opération
    dplyr::arrange(OPE_DATE_REALISATION,OPE_ID) %>%
    
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
      OPE_DATE_REALISATION = "ope_date",
      lib_OPE_DEBIT_MESURE = "Débit mesuré",
      lib_OPE_DEBIT_STATION_HYDRO = "Débit station hydro"
    ) %>%
    gt::cols_align(align = "center") %>%
    gt::tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_column_labels()
    ) %>%
    gt::tab_header(
      title = "Disponibilité des données de débit par opération"
    ) %>%
    gt::tab_source_note(
      source_note = md("❌ **Donnée indisponible**")
    ) %>%
    gt::tab_style(
      style = cell_text(weight = "bold"),
      locations = cells_title(groups = "title")
    )
  
  #retourner le tableau mis en forme
  table_dispo_debit
}