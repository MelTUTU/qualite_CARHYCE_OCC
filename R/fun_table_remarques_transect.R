table_remarques_transect <- function(data, id_station){
  
  remarques <- data %>%
    dplyr::filter(
      Code_station_SANDRE == id_station,
      TRA_REMARQUES != ""
    ) %>%
    dplyr::select(
      Code_station_SANDRE,
      code_pt_prelevement,
      OPE_ID,
      OPE_DATE_REALISATION,
      TRA_NUM,
      TRA_REMARQUES
    ) %>%
    dplyr::distinct() %>%
    dplyr::mutate(
      OPE_DATE_REALISATION = as.Date(
        OPE_DATE_REALISATION,
        format = "%d/%m/%Y"
      ),
      TRA_NUM = as.numeric(TRA_NUM)
    ) %>%
    dplyr::arrange(
      Code_station_SANDRE,
      OPE_DATE_REALISATION,
      TRA_NUM
    )
  
  DT::datatable(
    remarques,
    rownames = FALSE,
    options = list(
      pageLength = 10,
      lengthChange = FALSE
    ),
    colnames = c(
      "code_station",
      "point_prelevement",
      "ope_id",
      "ope_date",
      "transect",
      "remarques"
    ),
    caption = htmltools::tags$caption(
      style = paste(
        "caption-side: top;",
        "text-align: center;",
        "color: #000000;",
        "font-size: 18px;", 
        "font-weight: bold;"),
      "Remarques concernant les transects"
    )
  )
}