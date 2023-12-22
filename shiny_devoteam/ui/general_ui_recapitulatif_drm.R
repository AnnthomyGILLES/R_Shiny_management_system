# Modadl de visualisation et de téléchargement du rapport
modal_recapitulatif_drm <- shinyBS::bsModal(
  "modal_recap_drm",
  "DRM",
  "selectbutton_view",
  size = "large",
  column(width = 12,
         shinydashboard::box(
           title = "Contacts",
           status = "primary",
           solidHeader = TRUE,
           collapsible = TRUE,
           width = 12,
           column(
             width = 12, 
             column(width = 6, h5(textOutput('md_email_sales'))),
             column(width = 6, h5(textOutput('md_nom_sales')))
           ),
           column(
             width = 12, 
             column(width = 6, h5(textOutput('md_email_manager'))),
             column(width = 6, h5(textOutput('md_nom_manager')))
           ),
           column(
             width = 12, 
             column(width = 6, h5(textOutput('md_email'))),
             column(width = 6, h5(textOutput('md_nom_consultant')))
           )
         ),
         shinydashboard::box(
           title = "Le Projet",
           status = "primary",
           solidHeader = TRUE,
           collapsible = TRUE,
           width = 12,
           column(width = 6, h5(textOutput('md_nom_du_client'))),
           column(width = 6, h5(textOutput('md_nom_du_projet'))),
           column(width = 6, h5(textOutput('md_intitule_du_poste'))),
           column(width = 6, h5(textOutput('md_duree_mission'))),
           column(width = 6, h5(textOutput('md_transmisson_client'))),
           column(width = 6, h5(textOutput('md_charte_sii_client'))),
           column(width = 6, h5(textOutput('md_nom_chef_projet'))),
           column(width = 6, h5(textOutput('md_nom_coordinateur_projet'))),
           column(width = 12, h5(textOutput('md_complexite_du_projet')))
         ),
         shinydashboard::box(
           title = "Description de la mission",
           status = "primary",
           solidHeader = TRUE,
           collapsible = TRUE,
           width = 12,
           column(width = 12, h5('Découverte de l’environnement de travail et du contexte mission'), p(textOutput('md_decouverte_env_travail'))),
           column(width = 12, h5('Environnement et contexte client'), p(textOutput('md_env_contexte_client')))
         ),
         shinydashboard::box(
           title = "Réalisations clés techniques et/ou fonctionnelles",
           status = "primary",
           solidHeader = TRUE,
           collapsible = TRUE,
           width = 12,
           column(width = 12, p(textOutput('md_realisations_techniques')))
         ),
         shinydashboard::box(
           title = "Difficultés rencontrées et actions menées pour y remédier",
           status = "primary",
           solidHeader = TRUE,
           collapsible = TRUE,
           width = 12,
           column(width = 12, p(textOutput('md_difficultes_rencontrees')))
         ),
         shinydashboard::box(
           title = "Appréciation globale de la mission",
           status = "primary",
           solidHeader = TRUE,
           collapsible = TRUE,
           width = 12,
           column(width = 12, strong(tags$u('Consultant:')), p(textOutput('md_appreciation_globale'))),
           column(width = 12, strong(tags$u('Client:')), p(textOutput('md_appreciation_globale_client')))
         ),
         shinydashboard::box(
           title = "Axes d’amélioration et préconisations",
           status = "primary",
           solidHeader = TRUE,
           collapsible = TRUE,
           width = 12,
           column(width = 12, p(textOutput('md_axes_amelioration')))
         ),
         shinydashboard::box(
           title = "Synthèse du suivi",
           status = "primary",
           solidHeader = TRUE,
           collapsible = TRUE,
           width = 12,
           column(width = 12, p(textOutput('md_synthese_du_suivi')))
         ),
         shinydashboard::box(
           title = "Congés / Formation",
           status = "primary",
           solidHeader = TRUE,
           collapsible = TRUE,
           width = 12,
           column(width = 12, strong(tags$u('Prévision de Congés')), p(textOutput('md_conges'))),
           column(width = 12, strong(tags$u('Formation demandée pour le déroulement de la mission')), p(textOutput('md_formation')))
         ),
         column(width = 12, shinyWidgets::actionBttn('validate_drm', "Valider ce DRM", style = 'material-flat', color = 'warning')),
         column(width = 12, downloadButton("download_report", "Generate report"))
  )
)