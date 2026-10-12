# **Mise en qualité des données CARHYCE**

Ce dépôt contient les fonctions et scripts R Markdown utilisés par l'OFB Normandie 
pour la mise en qualité des données **CARHYCE**.


Il permet d'aboutir à la création de fiches par stations générées à partir des 
données brutes télécharger sur la base de données CARHYCE (https://carhyce.eaufrance.fr/). 
Ces fiches permettent de mettre en évidence les éventuelles erreurs de 
saisie, données aberrantes et points de vigilance.

## <span style='color:#2D0084;'> 1. Effectuer les vérifications de niveau A indiquées par le national</span>

Pour cette partie il faut suivre le script **1_Verification_national.Rmd**. 
Cette partie est indépendante du reste de la procédure de mise en qualité et 
permet de vérifier les erreurs mises en évidence par le traitement des données 
effectué au niveau national.

Le jeux de données utilisé ici est disponible sur le réseau, il est important de 
vérifier le chemin d'accès du fichier. 
Le script permet de filtrer le tableau afin de garder seulement les stations de 
Normandie.

## <span style='color:#2D0084;'> 2. Créer les tables de travail</span>
La procédure d'export et de stockage des données CARHYCE est présentée en première 
partie du script **2_Preparation_donnees.html**.
Ce script permet ensuite de construire les tables qui seront utilisées pour la 
création des fiches station. Une fois créées, ces tables sont enregistrées dans 
le dossier **Data/clean_data/** .

## <span style='color:#2D0084;'> 3. Générer les fiches de mise en qualité</span>
Pour générer les fiches de mise en qualité, il faut se rendre dans le dossier 
**fiches_qualite_stations** et faire tourner le script **script_generer_fiches.R**.

Dans ces fiches, nous retrouvons un ensembles de cartes, tableaux et graphiques 
interactifs qui permettent d'identifier les problèmes présents dans les données 
brutes.
