observeEvent(input$selectbutton_sales[1], {
  if (is_sales()) {
    values$selected_row <-
      as.numeric(strsplit(input$selectbutton_sales[1], "_")[[1]][3])
    shinyBS::toggleModal(session, "modal_sales", toggle = "open")
  }
  
}, ignoreInit = T)


observeEvent(input$submit_sales_form, {
  selected_row <- values$selected_row
  id <- values$data[selected_row, "_id"]
  data <- values$data

  if (input$appreciation_globale_sales == "")
  {
    shinyWidgets::sendSweetAlert(
      session = session,
      title = "Attention!",
      text = "Veuillez remplir tous les champs afin de soumettre ce formulaire.",
      type = "error"
    )
  } else if(data[selected_row, 'updated_par_sales'] == TRUE) {
    shinyWidgets::sendSweetAlert(
      session = session,
      title = "Opération impossible !",
      text = "Vous avez déjà réalisé la saisie de ce DRM. Il n'est donc plus possible de le modifier.",
      type = "error"
    )
  }
  else {

    last_name <- values$data[selected_row, "last_name"]
    first_name <- values$data[selected_row, "first_name"]
    
    field_1 <- sprintf('"appreciation_globale_client" : "%s" ,', stringr::str_replace_all(input$appreciation_globale_sales, "[\r\n]" , ""))
    field_2 <- sprintf('"updated_par_sales" : true ,')
    field_3 <- sprintf('"nom_sales" : "%s"', stringr::str_replace_all(user$profile_name, "[\r\n]" , ""))
    
    
    values$fields <- c(id, field_1, field_2, field_3)
    names(values$fields) = c("id", "field_1", "field_2", "field_3")
    
    
    shinyWidgets::confirmSweetAlert(
      session,
      inputId = "alert_update_drm_sales",
      title = "Envoyer ?",
      text = paste(
        "Vos informations vont être soumises au DRM du consultant:",
        last_name,
        first_name,
        ".\nAttention! Cette opération est irréversible et vous ne pourrez plus modifier votre saisie."
      ),
      type = "warning",
      btn_labels = c("Annuler", "Confirmer"),
      closeOnClickOutside = FALSE,
      html = FALSE
    )
  }
})


observeEvent(input$alert_update_drm_sales, {
  if (isTRUE(input$alert_update_drm_sales)) {
    data_updated_drm <- values$fields
    if (input$alert_update_drm_sales == TRUE) {
      db$update(
        paste0('{"_id": { "$oid" : "', data_updated_drm['id'], '" } }'),
        paste0(
          '{ "$set" : { ',
          data_updated_drm['field_1'],
          data_updated_drm['field_2'],
          data_updated_drm['field_3'],
          '} }'
        )
      )
      
      shinyWidgets::sendSweetAlert(
        session = session,
        title = "Envoyé!",
        text = "L'appréciation Client a bien été envoyée.",
        type = "success"
      )
      shinyjs::reset("modal_sales")
      shinyBS::toggleModal(session, "modal_sales", toggle = "close")
      values$data <- find_in_database(db, query = values$query, fields = '{}')
    }
  }
})
