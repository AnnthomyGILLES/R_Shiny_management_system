# Formulaire complété par le manager

modal_formulaire_manager <- shinyBS::bsModal(
  "modal_manager",
  "A compléter par le manager",
  "selectbutton_manager",
  size = "medium",
  column(width = 12,
         textAreaInput(
           "axes_amelioration",
           h4("Axes d’amélioration et préconisations")
         ),
         textAreaInput(
           "synthese_du_suivi",
           h4("Synthèse du suivi")
         ),
         textAreaInput("conges",
                       h4("Congés / Formation"), placeholder = "Prévision de Congés"),
         textAreaInput("formation",
                       h4("Formation"), placeholder = "Formation demandée pour le déroulement de la mission (à faire valider par le client)"),
         shinyWidgets::actionBttn(
           'submitmanager_form',
           'Envoyer',
           style = "material-flat",
           color = "danger",
           icon = tags$i(class="fas fa-paper-plane")
         )
  )
)