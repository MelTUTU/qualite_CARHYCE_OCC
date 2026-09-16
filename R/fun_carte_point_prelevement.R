#'Fonction permettant de générer la carte présentant la localisation de la station 
#'utilisée en partie 1 de la fiche station


carte_station <- function(data){
  
  bbox <- sf::st_bbox(data)
  
  map_station <- ggplot2::ggplot() +
    
    #fond de carte open street map
    ggspatial::annotation_map_tile(type = "osm") + 
    
    #Points interactifs correspondant à la localisation des points de prélèvement
    ggiraph::geom_sf_interactive(
      data = data,
      ggplot2::aes(
        shape=code_pt_prelevement,
        tooltip = base::paste(
          "Station :", Code_station_SANDRE,
          "\nPoint de prélèvement :", code_pt_prelevement
        )
      ),
      colour = "darkgreen",
      size = 5.5
    ) +
    
    #emprise de la carte
    ggplot2::coord_sf(
      xlim = c(bbox["xmin"] - 300, bbox["xmax"] + 300),
      ylim = c(bbox["ymin"] - 300, bbox["ymax"] + 300)) +
    
    #Mise en forme générale
    ggplot2::labs(
      title="Visualisation de la position géographique des points de prélèvement",
      x = NULL,
      y = NULL
    ) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title=ggtext::element_markdown(size=15, face="bold"),
      legend.title = ggplot2::element_text(size=13, face="bold"),
      legend.text= ggplot2::element_text(size=11),
      axis.text = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank()
    ) +
    
    #ajouter le nord
    ggspatial::annotation_north_arrow(
      which_north = "true",
      style = ggspatial::north_arrow_orienteering(),
      width = grid::unit(0.5, "cm"),
      height = grid::unit(0.6, "cm")
    )+
    
    #ajouter l'échelle
    ggspatial::annotation_scale(
      location = "br",
      line_width = 0.50,
      height = grid::unit(0.3, "cm")
    )
  
  #afficher la carte interactive
  ggiraph::girafe(
    ggobj = map_station)
}