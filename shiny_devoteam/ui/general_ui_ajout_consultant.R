#  Formulaire d'ajout d'un consultant par l'admin
modal_ajout_consultant <- shinyBS::bsModal(
  "form_ajout_consultant",
  "Ajouter un consultant à la base",
  "ajouter_consultant",
  size = "medium",
  column(
    width = 12,
    textInput(
      "form_email_manager",
      h4("Email du manager"),
      placeholder = "*****@devoteam.com"
    ),
    textInput(
      "form_email_collaborateur",
      h4("Email du nouveau consultant"),
      placeholder = "*****@devoteam.com"
    ),
    textInput(
      "form_email_sales",
      h4("Email du sales associé au consultant"),
      placeholder = "*****@devoteam.com"
    ),
    shinyWidgets::actionBttn(
      'submit_ajouter_consultant',
      'Envoyer',
      style = "material-flat",
      color = "danger",
      icon = tags$i(class="fas fa-users")
    )
  )
)