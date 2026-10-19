# création de la fonction permettant de générer le graphique des jours de prospection

graph_historique_ope <- function(data) {
  
  #objet contenant le nombre de points de prélèvement
  n_PP <- dplyr::n_distinct(data$code_pt_prelevement) 
  
  
  #Faire afficher un message si la date de réalisation est manquante 
  #pour une opération
  if (base::any(base::is.na(data$OPE_DATE_REALISATION))) {
    
    ope_sans_date <- data %>%
      dplyr::filter(base::is.na(OPE_DATE_REALISATION)) %>%
      dplyr::distinct(OPE_ID)
    
    base::cat(
      base::paste0(
        "<div class='alerte-rouge'>",
        "⚠ Date manquante pour l'opération : ",
        base::paste(ope_sans_date$OPE_ID, collapse = ", "),
        "</div>"
      )
    )
  }
  
  # calcul de la durée des périodes entre deux opérations consécutives 
  # d'un même point de prélèvement
  
  periodes <- data %>%
    dplyr::arrange(code_pt_prelevement, OPE_DATE_REALISATION) %>% 
    dplyr::group_by(code_pt_prelevement) %>%
    dplyr::mutate(
      date_debut = OPE_DATE_REALISATION,
      date_fin = dplyr::lead(OPE_DATE_REALISATION) #renvoie la date de la ligne suivante
    ) %>%
    dplyr::filter(!base::is.na(date_fin)) %>% #suppression de la dernière ligne (il n'y a pas d'opé suivante)
    dplyr::mutate(
      duree_ans = base::round(
        base::as.numeric(date_fin - date_debut) / 365.25, 1), #arrondir au dixième
      couleur = dplyr::case_when(
        duree_ans <4.6 ~ "En avance protocole",
        duree_ans <= 6.6 ~ "OK Protocole",
        duree_ans <= 7.6 ~ "En retard, acceptable protocole",
        TRUE ~ "En retard, hors protocole"
      )
    )
  
  p <- ggplot2::ggplot(data) +
    
    #rectangles interactifs permettant de visualiser la durée 
    #des périodes entre deux opérations
    ggiraph::geom_rect_interactive(
      data = periodes,
      ggplot2::aes(
        xmin = (date_debut+30),
        xmax = (date_fin-30),
        ymin = 0.8,
        ymax = 1.2,
        fill = couleur,
        tooltip = base::paste0(
          duree_ans, " ans entre les deux opérations")),
      alpha = 0.4)+
    ggplot2::scale_fill_manual(
      values = c(
        "En avance protocole" = "grey",
        "OK Protocole" = "#7FC97F",
        "En retard, acceptable protocole" = "#FDB462",
        "En retard, hors protocole" = "#FB8072"),
      name = "Intervalle de temps entre opérations")+
    #mise en forme de la légende associée
    ggplot2::guides(
      fill = ggplot2::guide_legend(
        override.aes = base::list(
          colour = NA,
          linetype = 0)))+
    
    #points interactifs correspondant aux dates des opérations
    ggiraph::geom_point_interactive(
      ggplot2::aes(
        x = OPE_DATE_REALISATION,
        y = Code_station_SANDRE,
        shape = code_pt_prelevement, #formes différentes par points de prélèvements
        tooltip = base::paste0(
          "ope_id: ", OPE_ID, "<br>",
          "ope_date: ", OPE_DATE_REALISATION
        ),
        data_id = OPE_ID
      ),
      size = 3,
      stroke = 2,
      show.legend = TRUE
    ) +
    
    #mise en forme du graphique
    ggplot2::scale_shape_manual(values = c(1, 4)) +
    ggplot2::labs(
      y = NULL,
      x = "Date",
      title = "Historicité des jours de prospection, et mise en évidence <br> de l'intervalle de temps entre deux opérations consécutives",
      shape = "Point de prélèvement"
    ) +
    ggplot2::theme_bw() +
    ggplot2::scale_x_date(
      date_breaks = "2 year",
      date_labels = "%Y-%m",
      expand = c(0.1, 0.1)
    ) +
    ggplot2::theme(
      axis.title= ggplot2::element_text(size = 8, face = "bold"),
      axis.text.x = ggplot2::element_text(size = 7, angle = 45, hjust = 1),
      plot.title = ggtext::element_markdown(size = 9, face = "bold"),
      axis.text.y = ggplot2::element_text(size = 7, face = "bold"),
      legend.text = ggplot2::element_text(size=6),
      legend.title= ggplot2::element_text(size=7, face="bold")
    )
  
  # si il y a plusieurs points de prélèvement, 
  # afficher le graphique avec des facettes par point de prélèvement
  if (n_PP > 1) {
    p <- p +
      ggplot2::facet_wrap(
        ~code_pt_prelevement,
        ncol = 1
      )
  }
  
  ggiraph::girafe(ggobj = p,
                  height_svg = 4)
}
