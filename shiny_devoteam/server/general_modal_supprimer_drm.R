observeEvent(input$supprimer_drm, {
  if (is_admin()) {
    shinyBS::toggleModal(session, "form_supprimer_drm", toggle = "open")
  }
}, ignoreInit = T)


output$drm_datatable <- DT::renderDataTable({
  df <-
    db$find(query = '{}',
            fields = '{}',
            sort = '{"date_soumission": -1}')
  
  df <-
    df %>% dplyr::mutate(
      delete = shinyInput(
        actionButton,
        nrow(df),
        'button_delete_',
        label = "",
        icon = tags$i(class="fas fa-trash"),
        onclick  = 'Shiny.onInputChange(\"selectbutton_delete\",  [this.id, Math.random()])'
      )
    )
  
  df <- df %>% 
    dplyr::select(delete, last_name, first_name, date_soumission, nom_du_client, nom_du_projet, dplyr::everything())
  
  values$drm_table <- df

  DT::datatable(
    values$drm_table,
    extensions = c("Responsive"),
    selection = "single",
    escape = FALSE
  )
  
})

observeEvent(input$selectbutton_delete[1], {
  values$selected_row <-
    as.numeric(strsplit(input$selectbutton_delete[1], "_")[[1]][3])
  data <- values$drm_table[values$selected_row, ]
  values$id <- as.character(data[, "_id"])
  id_drm <- as.character(data[, "identifiant_drm"])
  nom <- as.character(data[, "last_name"])
  prenom <- as.character(data[, "first_name"])
  
  if((data['valide_par_consultant'] == TRUE) && (data['valide_par_sales'] == TRUE) && (data['valide_par_manager'] == TRUE)) {
    shinyWidgets::sendSweetAlert(
      session = session,
      title = "Opération impossible !",
      text = "Toutes les parties (Manager, Sales et Consultant) ont déjà réalisé la validation de ce DRM. Il n'est donc plus possible de le supprimer.",
      type = "error"
    )
  } else {
    shinyWidgets::confirmSweetAlert(
      session,
      inputId = "alert_supprimer_drm",
      title = "Attention! Cette opération est irréversible.",
      text = sprintf("Vous vous apprêtez à supprimer le DRM suivant:\nIdentifiant DRM:%s\nNom du consultant: %s %s.", id_drm, nom, prenom),
      type = "warning",
      btn_labels = c("Annuler", "Confirmer"),
      closeOnClickOutside = FALSE,
      html = FALSE
    )
  }

})

observeEvent(input$alert_supprimer_drm, {
  if (isTRUE(input$alert_supprimer_drm)) {
    drm_id_to_delete <- sprintf('{"_id": { "$oid" : "%s" } }', values$id)
    db$remove(drm_id_to_delete, just_one = TRUE)
    
    shinyWidgets::sendSweetAlert(
      session = session,
      title = "Supprimé!",
      text = "Le DRM a été supprimé.",
      type = "success"
    )
    values$drm_table <- db$find(query = values$query,
                                fields = '{}',
                                sort = '{"date_soumission": -1}')
    values$drm_table <- values$drm_table[-values$selected_row, ]

    values$data <- db$find(query = values$query,
                           fields = '{}',
                           sort = '{"date_soumission": -1}')

    
    shinyBS::toggleModal(session, "form_supprimer_drm", toggle = "close")
  }
})