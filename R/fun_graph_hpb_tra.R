#'Créer un graphique permettant de visualiser la hauteur plein bord de chaque transect
#'
graph_hpb_tra <- function(data){
  
  #arrangement des données
  data_filtre <- data %>% 
    dplyr::select(
       Code_station_SANDRE, 
       code_pt_prelevement,
       OPE_ID,
       OPE_DATE_REALISATION,
       OPE_VERSION_PROTOCOLE_LIBELLE,
       TRA_ID,
       TRA_NUM,
       TRA_HPB,
       label,
       OPE_ID_NUM)%>% 
    dplyr::distinct() %>% 
    dplyr::mutate(
      TRA_NUM= base::as.numeric(TRA_NUM)) %>% 
    dplyr::arrange(OPE_ID_NUM, TRA_NUM) %>% 
    dplyr::mutate(
      label = base::factor(
        label,
        levels = base::unique(label)))
  
  max_y <- base::max(data_filtre$TRA_HPB, na.rm = TRUE) +0.1
  
  #--- Graphique
  p <- ggplot(data_filtre) +
    
    #Points interactifs correspondant aux valeurs de DIP
    ggiraph::geom_point_interactive(
      ggplot2::aes(
        x = TRA_NUM,
        y = TRA_HPB,
        tooltip = base::paste0(
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
          "hauteur PB: ",
          TRA_HPB,
          "<br>",
          "protocole: ",
          OPE_VERSION_PROTOCOLE_LIBELLE,
          "<br>")),
      size = 3,
      shape=21,
      fill="steelblue",
      color="black"
    )+
    
    ggplot2::facet_wrap(~label, 
               ncol=2)+
    
    #Mise en forme du graphique
    ggplot2::theme_bw() +
    ggplot2::scale_y_continuous(limits = c(0, max_y)) +
    ggplot2::scale_x_continuous(
      breaks = seq(
        from = 1,
        to = base::max(data_filtre$TRA_NUM, na.rm = TRUE),
        by = 2
      )
    )+
    ggplot2::labs(
       title = "Hauteur plein bord de chaque transect, par opération", 
       x="Numéro de transect",
       y = "Hauteur plein bord (m)")+
    ggplot2::theme(
      axis.title = ggplot2::element_text(size=11, face="bold"),
      plot.title = ggplot2::element_text(size = 12, face = "bold"),
      legend.title = ggplot2::element_text(size=11, face="bold"),
      strip.text = ggplot2::element_text(size = 8, face = "bold"))
  
  #afficher le graphique interactif
  ggiraph::girafe(ggobj = p,
                  height_svg = 4.5)
}