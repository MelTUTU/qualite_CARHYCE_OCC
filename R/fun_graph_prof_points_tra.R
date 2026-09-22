#'Créer un graphique permettant de visualiser la profondeur des points 
#'de chaque transect et par opération.
#'Si la profondeur est = 0 alors le point apparaît en rouge car cela traduit 
#'une erreur de protocole.

graph_prof_point<- function(data){
  
  #garder les valeurs correspondants au premier point de chaque transect
  data_filtre <- data %>% 
    dplyr::mutate(
      TRA_NUM= base::as.numeric(TRA_NUM),
      TRA_HPB_cm = (TRA_HPB) *100,
      TRA_HPB_cm_inv = (-TRA_HPB_cm) ) %>% 
    dplyr::arrange(OPE_ID_NUM, TRA_NUM) %>% 
    dplyr::mutate(
      label = base::factor(
        label,
        levels = base::unique(label)))
  
  #--- Graphique
  p <- ggplot2::ggplot(data_filtre) +
    
    #ligne correspondant à la hauteur plein bord du transect
    ggiraph::geom_line_interactive(
      ggplot2::aes(x=POI_NUM, 
                  y=TRA_HPB_cm_inv,
                  tooltip = paste0(
                    "ope_id: ",
                    OPE_ID,
                    "<br>",
                    "code_ppt: ",
                    code_pt_prelevement,
                    "<br>",
                    "HPB_transect: ",
                    TRA_HPB_cm,
                    " cm <br>")),
              color="darkgreen",
              linewidth=1.2)+
    
    #ligne en pointillets pour relier les points
    ggplot2::geom_line( ggplot2::aes(
      x = POI_NUM,
      y = POI_PROFONDEUR),
      linetype="dashed")+
    
    #Points interactifs correspondant aux valeurs de DIP
    ggiraph::geom_point_interactive(
      ggplot2::aes(
        x = POI_NUM,
        y = POI_PROFONDEUR,
        fill = POI_NUM == 1 & POI_PROFONDEUR == 0,
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
          "num_point: ",
          POI_NUM,
          "<br>",
          "profondeur: ",
          POI_PROFONDEUR,
          " cm <br>",
          "protocole: ",
          OPE_VERSION_PROTOCOLE_LIBELLE,
          "<br>")
      ),
      shape = 21,
      size = 2.5
    ) +
    ggplot2::scale_fill_manual(
      values = c(
        "TRUE" = "red",
        "FALSE" = "steelblue"
      ),
      guide = "none"
    )+
    ggplot2::scale_x_continuous(
      breaks = seq(
        from = 1,
        to = max(data_filtre$POI_NUM, na.rm = TRUE),
        by = 2
      )
    )+
    ggplot2::scale_y_reverse()+

    ggplot2::facet_grid(TRA_NUM~label, scales="free_x")+

    
    #Mise en forme du graphique
    ggplot2::theme_bw() +


    ggplot2::labs(
      title = "Profondeur des points de chaque transect, par opération", 
      x="Numéro de point",
      y = "Profondeur du point (cm)")+
    ggplot2::theme(
      axis.title = ggplot2::element_text(size=11, face="bold"),
      plot.title = ggplot2::element_text(size = 12, face = "bold"),
      legend.title = ggplot2::element_text(size=11, face="bold"),
      strip.text = ggplot2::element_text(size = 8, face = "bold"))
  

  
  ggiraph::girafe(ggobj = p,
                  height_svg = 15)
}