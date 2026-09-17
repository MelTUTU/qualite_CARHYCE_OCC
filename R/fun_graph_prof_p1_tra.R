#'Créer un graphique permettant de visualiser la profondeur du premier point 
#'de chaque transect.
#'Si la profondeur est = 0 alors le point apparaît en rouge car cela traduit 
#'une erreur de protocole.

graph_point_1_tra <- function(data){
  
  #garder les valeurs correspondants au premier point de chaque transect
  data_filtre <- data %>% 
    dplyr::filter(POI_NUM =="1") %>% 
    dplyr::distinct() %>% 
    dplyr::mutate(
      TRA_NUM= base::as.numeric(TRA_NUM)) %>% 
    dplyr::arrange(OPE_ID_NUM, TRA_NUM) %>% 
    dplyr::mutate(
      label = base::factor(
        label,
        levels = base::unique(label)))
  
  #objet contenant le nombre de points de prélèvement
  n_PP <- dplyr::n_distinct(data_filtre$code_pt_prelevement)
  
  #limites supérieures et inférieures de l'axe y
  limit_sup_y <- max(data_filtre$POI_PROFONDEUR, na.rm = TRUE) +20
  limit_inf_y <- min(data_filtre$POI_PROFONDEUR, na.rm = TRUE) -20
  
  #--- Graphique
  p <- ggplot2::ggplot(data_filtre) +
    
    #Points interactifs correspondant aux valeurs de DIP
    ggiraph::geom_point_interactive(
      ggplot2::aes(
        x = TRA_NUM,
        y = POI_PROFONDEUR,
        fill = POI_PROFONDEUR == 0,
        shape = POI_PROFONDEUR == 0,
        tooltip = paste0(
          "ope_id: ",
          OPE_ID,
          "<br>",
          "code_ppt: ",
          code_pt_prelevement,
          "<br>",
          "ope_date: ",
          OPE_DATE_REALISATION,
          "<br>",
          "num_transect: ",
          TRA_NUM,
          "<br>",
          "profondeur P1: ",
          POI_PROFONDEUR,
          "<br>",
          "protocole: ",
          OPE_VERSION_PROTOCOLE_LIBELLE,
          "<br>")),
      size = 3,
    )+
    ggplot2::scale_fill_manual(
      values = c(
        "TRUE" = "red",
        "FALSE" = "steelblue"),
      guide = "none")+
    ggplot2::scale_shape_manual(
      values = c(
        "TRUE" = 23,
        "FALSE" = 21),
      guide = "none"
    )+
    
    ggplot2::facet_wrap(~label, 
               ncol=2)+
    
    #Mise en forme du graphique
    ggplot2::theme_bw() +
    ggplot2::scale_y_continuous(limits = c(limit_inf_y, 
                                           limit_sup_y)) +
    ggplot2::scale_x_continuous(
      breaks = seq(
        from = 1,
        to = max(data_filtre$TRA_NUM, na.rm = TRUE),
        by = 2
      )
    )+
    ggplot2::labs(
       title = "Profondeur du point n°1 de chaque transect, par opération", 
       x="Numéro de transect",
       y = "Profondeur du point n°1 (cm)")+
    ggplot2::theme(
      axis.title = ggplot2::element_text(size=11, face="bold"),
      plot.title = ggplot2::element_text(size = 12, face = "bold"),
      legend.title = ggplot2::element_text(size=11, face="bold"),
      strip.text = ggplot2::element_text(size = 8, face = "bold"))
  
  
  ggiraph::girafe(ggobj = p,
                  height_svg = 4.5)
}