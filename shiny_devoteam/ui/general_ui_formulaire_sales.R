# Formulaire complété par le Sales

modal_formulaire_sales <- shinyBS::bsModal(
  "modal_sales",
  "A compléter par le sales",
  "select_button",
  size = "medium",
  column(width = 12,
         textAreaInput(
           "appreciation_globale_sales",
           h4("Appréciation globale de la mission (Client)")
         ),
         shinyWidgets::actionBttn(
           'submit_sales_form',
           'Envoyer',
           style = "material-flat",
           color = "danger",
           icon = tags$i(class="fas fa-paper-plane")
         )
  )
)