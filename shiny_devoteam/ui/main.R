#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

source("ui/themes.R", local = TRUE)$value
source("ui/formulaire_ui.R", local = TRUE)$value
source("ui/general_ui_ajout_consultant.R", local = TRUE)$value
source("ui/general_ui_recapitulatif_drm.R", local = TRUE)$value
source("ui/general_ui_formulaire_manager.R", local = TRUE)$value
source("ui/general_ui_formulaire_sales.R", local = TRUE)$value
source("ui/general_ui_supprimer_drm.R", local = TRUE)$value


header <- dashboardHeader(title = "Devoteam DRM", tags$li(
    class = "dropdown",
    shinyWidgets::actionBttn(
      'submit_sign_out',
      'Déconnexion',
      style = "bordered",
      color = "default",
      icon = tags$i(class="fas fa-sign-out-alt")
    )
  ))

sidebar <- dashboardSidebar(sidebarMenu(
  id = "sbMenu",
  menuItem(
    "Général",
    tabName = "general",
    icon = tags$i(class="fas fa-home"),
    selected = TRUE
  ),
  menuItem(
    "Formulaire",
    tabName = "formulaire",
    icon = tags$i(class="fas fa-file-alt")
  )
), collapsed = FALSE)

body <- dashboardBody(### changing theme
  
  theme_boe_website,
  
  tabItems(tabItem(
    tabName = "general",
    uiOutput('profile'),
    box(
      title = "Général",
      status = "primary",
      solidHeader = TRUE,
      width = 12,
      collapsible = TRUE,
      column(width = 12, DT::dataTableOutput("mytable")),
      
      #  Formulaire d'ajout d'un consultant par l'admin
      modal_ajout_consultant,
      
      #  Formulaire de suppression d'un DRM par l'admin
      modal_supprimer_drm,
      
      # Modadl de visualisation et de téléchargement du rapport
      modal_recapitulatif_drm,
      
      # Mise à jour du DRM par le manager
      modal_formulaire_manager,
      
      # Mise à jour du DRM par le sales
      modal_formulaire_sales
    )
  ),
  formulaire),
  tags$footer("Copyright © Devoteam DRM 2019 -", tags$a(href="https://www.linkedin.com/in/annthomygilles/", "GILLES Annthomy"),  style = "text-align:center; align: center; padding: 0px; margin: 0px;")
  )

hidden(tags$div(id = "main", dashboardPage(header, sidebar, body)))
