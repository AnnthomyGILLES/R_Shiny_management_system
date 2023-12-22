observeEvent(input$selectbutton_manager[1], {
  if (is_manager()) {
    values$selected_row <-
      as.numeric(strsplit(input$selectbutton_manager[1], "_")[[1]][3])
    shinyBS::toggleModal(session, "modal_manager", toggle = "open")
  }
  
}, ignoreInit = T)


observeEvent(input$submitmanager_form, {
  selected_row <- values$selected_row
  id <- values$data[selected_row, "_id"]
  
  if (input$axes_amelioration == "" || input$synthese_du_suivi == "" || input$conges == "" || input$formation == "")
  {
    shinyWidgets::sendSweetAlert(
      session = session,
      title = "Attention!",
      text = "Veuillez remplir tous les champs afin de soumettre ce formulaire.",
      type = "error"
    )
  }
  else if(values$data[selected_row, 'updated_par_manager'] == TRUE) {
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
    
    field_1 <- sprintf('"axes_amelioration" : "%s" ,', stringr::str_replace_all(input$axes_amelioration, "[\r\n]" , ""))
    field_2 <- sprintf('"synthese_du_suivi" : "%s" ,', stringr::str_replace_all(input$synthese_du_suivi, "[\r\n]" , ""))
    field_3 <- sprintf('"conges" : "%s" ,', stringr::str_replace_all(input$conges, "[\r\n]" , ""))
    field_4 <- sprintf('"formation" : "%s" ,', stringr::str_replace_all(input$formation, "[\r\n]" , ""))
    field_5 <- sprintf('"updated_par_manager" : true ,')
    field_6 <- sprintf('"valide_par_manager" : "false" ,')
    field_7 <- sprintf('"nom_manager" : "%s"', stringr::str_replace_all(user$profile_name, "[\r\n]" , ""))
    
    values$fields <-
      c(id, field_1, field_2, field_3, field_4, field_5, field_6, field_7)
    names(values$fields) = c("id", "field_1", "field_2", "field_3", "field_4", "field_5", "field_6", "field_7")
    
    shinyWidgets::confirmSweetAlert(
      session,
      inputId = "alert_update_drm",
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

#  Soumission de la réponse du manager dans la base de données
observeEvent(input$alert_update_drm, {
  if (isTRUE(input$alert_update_drm)) {
    
  data_updated_drm <- values$fields

  if (input$alert_update_drm == TRUE) {
    #  Soumission de la réponse du manager dans la base de données
    db$update(
      paste0('{"_id": { "$oid" : "', data_updated_drm['id'], '" } }'),
      paste0(
        '{ "$set" : {',
        data_updated_drm['field_1'],
        data_updated_drm['field_2'],
        data_updated_drm['field_3'],
        data_updated_drm['field_4'],
        data_updated_drm['field_5'],
        data_updated_drm['field_6'],
        data_updated_drm['field_7'],
        '} }'
      )
    )
    shinyWidgets::sendSweetAlert(
      session = session,
      title = "Envoyé!",
      text = "Votre DRM a bien été envoyé.",
      type = "success"
    )
    shinyjs::reset("modal_manager")
    shinyBS::toggleModal(session, "modal_manager", toggle = "close")
    values$data <- find_in_database(db, query = values$query, fields =  '{}', sort = '{"date_soumission": -1}')
  }
  }
})
