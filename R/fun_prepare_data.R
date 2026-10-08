#' Fonction permettant de préparer les données pour la partie 
#' "informations sur la station"
#' 

prepare_data_sta <- function(data, id_station){
  
  #Sélection et arrangement des données
  info_station <- data %>% 
    dplyr::filter(
      Code_station_SANDRE == id_station) %>% 
    dplyr::select(
       Code_station_SANDRE, 
       SME_LB_STATION_MESURE_EAUX_SURFACE,
       SME_CD_DEPARTEMENT,
       Libelle_departement,
       Region,
       Libelle_bassin,
       SME_COORD_X_STATION_MESURE_EAUX_SURFACE,
       SME_COORD_Y_STATION_MESURE_EAUX_SURFACE,
       TPR_LIBELLE,
       OPE_CODE,
       code_pt_prelevement,
       OPE_DATE_REALISATION) %>% 
    dplyr::distinct() %>% #enlever les doublons
    dplyr::mutate(OPE_DATE_REALISATION = 
                    base::as.Date(OPE_DATE_REALISATION, 
                                  format = "%d/%m/%Y"))%>% 
    dplyr::group_by(
       Code_station_SANDRE, 
       SME_LB_STATION_MESURE_EAUX_SURFACE,
       SME_CD_DEPARTEMENT,
       Libelle_departement,
       Region,
       Libelle_bassin,
       SME_COORD_X_STATION_MESURE_EAUX_SURFACE,
       SME_COORD_Y_STATION_MESURE_EAUX_SURFACE,
       TPR_LIBELLE) %>% 
    dplyr::summarise(
      nombre_operation = dplyr::n_distinct(OPE_CODE), #compter le nombre d'opération par station
      nombre_pt_prelevement = dplyr::n_distinct(code_pt_prelevement), #compter le nombre de points de prélèvement différents
      code_pt_prelevement = base::list(unique(code_pt_prelevement)), #lister les différents codes de points de prélèvements
      date_premiere_ope = base::min(OPE_DATE_REALISATION, na.rm = TRUE), #récupérer la date de la première opération
      date_derniere_ope = base::max(OPE_DATE_REALISATION, na.rm = TRUE), #récupérer la date de la dernière opération
      .groups = "drop"
    ) %>% 
    dplyr::rename(
       libelle_station =SME_LB_STATION_MESURE_EAUX_SURFACE,
       code_departement=SME_CD_DEPARTEMENT,
       coord_x = SME_COORD_X_STATION_MESURE_EAUX_SURFACE,
       coord_y = SME_COORD_Y_STATION_MESURE_EAUX_SURFACE,
       systeme_projection = TPR_LIBELLE)

  info_station
}

#' Fonction permettant de préparer les données pour la partie "historicité de prospection"
prepare_data_jour_ope <- function(data, id_station){
  
  jour_ope <- data %>% 
    dplyr::filter(
      Code_station_SANDRE == id_station) %>% 
    dplyr::select(
       Code_station_SANDRE, 
       code_pt_prelevement,
       OPE_ID,
       OPE_VERSION_PROTOCOLE_LIBELLE,
       OPE_DATE_REALISATION,
       RME_NOM,
       VAL_LIBELLE,
       QUA_LIBELLE) %>% 
    dplyr::distinct() %>% 
    dplyr::arrange(OPE_ID) %>% 
    dplyr::mutate(OPE_DATE_REALISATION = 
                    base::as.Date(OPE_DATE_REALISATION, 
                                  format = "%d/%m/%Y")) %>%
    #convertir les variables en facteurs ordonnés pour faciliter l'affichage dans les graphiques
    dplyr::mutate(
      code_pt_prelevement = base::factor(
        code_pt_prelevement,
        levels = base::unique(code_pt_prelevement))
    )
  jour_ope
}

#' Fonction permettant de préparer les données pour la partie 
#' "Mesures générales par opération"

prepare_mesures_ope <- function(data, id_station){
  
  table_mesures <- data %>% 
    dplyr::filter(
      Code_station_SANDRE == id_station) %>% 
    dplyr::select(
       Code_station_SANDRE, 
       code_pt_prelevement,
       OPE_ID,
       OPE_DATE_REALISATION,
       OPE_VERSION_PROTOCOLE_LIBELLE,
       OPE_DEBIT_MESURE,
       OPE_LPBEV,
       OPE_LMEV,
       OPE_LR,
       OPE_DIP,
       OPE_PENTE_LIGNE_EAU) %>% 
    dplyr::distinct() %>% 
    dplyr::mutate(
      OPE_DATE_REALISATION = 
        base::as.Date(OPE_DATE_REALISATION, format = "%d/%m/%Y"),
      OPE_ID_NUM = base::as.numeric(OPE_ID)) %>% 
    dplyr::arrange(OPE_ID_NUM)%>%
    #convertir les variables en facteurs ordonnés pour faciliter l'affichage dans les graphiques
    dplyr::mutate(
      OPE_ID = base::factor(
        OPE_ID,
        levels = base::unique(OPE_ID)),
      code_pt_prelevement = base::factor(
        code_pt_prelevement,
        levels = base::unique(code_pt_prelevement))
    )
  
  table_mesures
}

#' Fonction permettant de préparer les données pour la partie 
#' "Transects"
#' 
prepare_table_transects <- function(data,
                                        id_station){
  
  data_filtre <- data %>% 
    dplyr::filter(
      Code_station_SANDRE == id_station) %>% 
    dplyr::select(
       Code_station_SANDRE, 
       code_pt_prelevement,
       OPE_ID,
       OPE_DATE_REALISATION,
       OPE_VERSION_PROTOCOLE_LIBELLE,
       OPE_DIP,
       TRA_ID,
       TRA_NUM,
       TRA_REMARQUES,
       TRA_LPB,
       TRA_L_MOUILLEE,
       TRA_HPB,
       POI_ID,
       POI_NUM,
       POI_PROFONDEUR,
       SUB_CODE,
       SUB_DEFINITION)%>% 
    dplyr::distinct() %>% 
    dplyr::mutate(
      OPE_DATE_REALISATION = 
        base::as.Date(OPE_DATE_REALISATION, format = "%d/%m/%Y"),
      OPE_ID_NUM= base::as.numeric(OPE_ID),  #créer une version numérique de la variable OPE_ID
      label = base::paste0("OPE_ID: ", #les labels permettrons de renommer les facettes des graphiques
                           OPE_ID)) %>% 
    dplyr::arrange(OPE_ID_NUM)%>%  #mettre dans l'ordre croissant de numéro d'opération
    #convertir les variables en facteurs ordonnés pour faciliter l'affichage dans les graphiques
    dplyr::mutate(
      OPE_ID = base::factor(
        OPE_ID,
        levels = base::unique(OPE_ID)),
      code_pt_prelevement = base::factor(
        code_pt_prelevement,
        levels = base::unique(code_pt_prelevement))
    )
  
  data_filtre
}

#' Granulométrie"
#' 
prepare_table_granulo<-function(data, id_station){
  
  etude_granulo <- data %>% 
    dplyr::filter(
      Code_station_SANDRE ==  id_station) %>% 
    dplyr::select(
       Code_station_SANDRE,
       OPE_ID,
       OPE_CODE,
       OPE_VERSION_PROTOCOLE_LIBELLE,
       OPE_DATE_REALISATION,
       code_pt_prelevement,
       MGR_ID,
       MGR_MESURES
    ) %>% 
    dplyr::distinct() %>% 
    dplyr::mutate(
     OPE_DATE_REALISATION = base::as.Date(
        OPE_DATE_REALISATION, 
        format = "%d/%m/%Y"),
     OPE_ID_NUM= base::as.numeric(OPE_ID),  #créer une version numérique de la variable OPE_ID
     label_ope = base::paste0("OPE_ID: ", #les labels permettrons de renommer les facettes des graphiques
                              OPE_ID, " ; code_pp: ", 
                              code_pt_prelevement),
     MGR_MESURES=base::as.numeric(MGR_MESURES)) %>% 
    dplyr::arrange(OPE_ID_NUM)%>%  #mettre dans l'ordre croissant de numéro d'opération
    dplyr::mutate(
      OPE_ID = base::factor(
        OPE_ID,
        levels = base::unique(OPE_ID)),
      code_pt_prelevement = base::factor(
        code_pt_prelevement,
        levels = base::unique(code_pt_prelevement)),
      label_ope = base::factor(
        label_ope,
        levels = base::unique(label_ope))
    )
  etude_granulo
}

prepare_table_colmatage <- function(data, id_station){
  
  table_colmatage <- data %>%
    dplyr::filter(Code_station_SANDRE ==  id_station) %>% 
    dplyr::select(Code_station_SANDRE,
           OPE_ID,
           OPE_CODE,
           OPE_VERSION_PROTOCOLE_LIBELLE,
           OPE_DATE_REALISATION,
           code_pt_prelevement,
           MCO_ID,
           MCO_RADIER,
           MCO_POSITION_LATERALE,
           MCO_MESURE) %>% 
    dplyr::distinct() %>% 
    dplyr::mutate(OPE_DATE_REALISATION =base:: as.Date(OPE_DATE_REALISATION, 
                                                       format = "%d/%m/%Y"),
           OPE_ID_NUM= base::as.numeric(OPE_ID),  #créer une version numérique de la variable OPE_ID
           label_ope = base::paste0("OPE: ", OPE_ID),
           MCO_MESURE= base::as.numeric(MCO_MESURE)) %>% 
    dplyr::arrange(OPE_ID_NUM)%>%  #mettre dans l'ordre croissant de numéro d'opération
    dplyr::mutate(
      OPE_ID = base::factor(
        OPE_ID,
        levels = base::unique(OPE_ID)),
      code_pt_prelevement = base::factor(
        code_pt_prelevement,
        levels = base::unique(code_pt_prelevement)),
      label_ope = base::factor(
        label_ope,
        levels = base::unique(label_ope)),
      MCO_POSITION_LATERALE = base::factor(
        MCO_POSITION_LATERALE,
        levels = base::unique(MCO_POSITION_LATERALE))
    )
  table_colmatage
}