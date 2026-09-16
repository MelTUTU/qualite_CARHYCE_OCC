#' Préparation de la table contenant les coordonnées des points de prélèvement

table_coord_ppt <- function(data,
                            id_station) {
  
  coord_ppt <- data %>% 
    dplyr::filter(
      Code_station_SANDRE == id_station) %>% 
    dplyr::select(
       Code_station_SANDRE, 
       SME_LB_STATION_MESURE_EAUX_SURFACE,
       SME_CD_DEPARTEMENT,
       Libelle_departement,
       Region,
       code_pt_prelevement,
       PPR_COORD_X_AVAL_POINT_EAUX_SURF,
       PPR_COORD_Y_AVAL_POINT_EAUX_SURF) %>% 
    dplyr::distinct() %>% 
    dplyr::mutate(
      PPR_COORD_X_AVAL_POINT_EAUX_SURF= 
        base::as.numeric(PPR_COORD_X_AVAL_POINT_EAUX_SURF),
      PPR_COORD_Y_AVAL_POINT_EAUX_SURF= 
        base::as.numeric(PPR_COORD_Y_AVAL_POINT_EAUX_SURF)) %>% 
    
    #Passage au format sf, pour avoir des données spatiales
    sf::st_as_sf(coords = c("PPR_COORD_X_AVAL_POINT_EAUX_SURF",
                            "PPR_COORD_Y_AVAL_POINT_EAUX_SURF"),
                 crs=2154) %>% #les données initiales sont en Lambert83 
    
    sf::st_transform(3857) #reprojeter les données en Web mercator, 
                            #car on utilise Open street map en fond de carte
  
  coord_ppt
}