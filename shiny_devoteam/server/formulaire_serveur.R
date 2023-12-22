observeEvent(input$submit, {
  if (input$nom == "" ||
      input$prenom == "" || input$nom_du_client == "" ||
      input$intitule_du_poste == "" ||
      input$duree_mission == 0 ||
      input$nom_du_projet == "" || input$nom_chef_projet == "" ||
      input$nom_coordinateur_projet == "" ||
      input$decouverte_env_travail == "" ||
      input$env_contexte_client == "" ||
      input$realisations_techniques == "" ||
      input$difficultes_rencontrees == "" ||
      input$appreciation_globale == "")
  {
    shinyWidgets::sendSweetAlert(
      session = session,
      title = "Attention!",
      text = "Veuillez remplir tous les champs afin de soumettre ce formulaire.",
      type = "error"
    )
  } else {
    query <- paste0('{"email_collaborateur": "', user$email , '" }')
    user_role <-
      consultants_db$find(query = query, fields = '{ "sales": true, "manager": true, "_id": false}')
    sales_email <- user_role["sales"]
    manager_email <- user_role["manager"]
    
    
    values$fields <-
      data.frame(
        date_soumission = timestamp(),
        identifiant_drm = paste0(human_timestamp(), input$nom, input$prenom),
        last_name = input$nom,
        first_name = input$prenom,
        email = user$email,
        email_sales = paste(sales_email),
        email_manager = paste(manager_email),
        nom_du_client = input$nom_du_client,
        intitule_du_poste = input$intitule_du_poste,
        duree_mission = input$duree_mission,
        nom_du_projet = input$nom_du_projet,
        nom_chef_projet = input$nom_chef_projet,
        nom_coordinateur_projet = input$nom_coordinateur_projet,
        date_prochain_suivi = input$date_prochain_suivi,
        dernier_point_de_suivi = input$dernier_point_de_suivi,
        transmisson_client = input$transmisson_client,
        charte_sii_client = input$charte_sii_client,
        complexite_du_projet = input$complexite_du_projet,
        decouverte_env_travail = input$decouverte_env_travail,
        env_contexte_client = input$env_contexte_client,
        realisations_techniques = input$realisations_techniques,
        difficultes_rencontrees = input$difficultes_rencontrees,
        appreciation_globale = input$appreciation_globale,
        updated_par_manager = "false",
        updated_par_sales = "false",
        valide_par_consultant = "false",
        valide_par_sales = "false",
        valide_par_manager  = "false"
      )
    
    shinyWidgets::confirmSweetAlert(
      session,
      inputId = "alert_formulaire_consultant",
      title = "Envoyer ?",
      text = "Vos informations vont être soumises",
      type = "warning",
      btn_labels = c("Annuler", "Confirmer"),
      closeOnClickOutside = TRUE,
      html = FALSE
    )
  }
  
  
})

observeEvent(input$alert_formulaire_consultant, {
  if (isTRUE(input$alert_formulaire_consultant)) {
    identifiant_drm = paste0(human_timestamp(), input$nom, input$prenom)
    if(identifiant_drm %in% values$data[['identifiant_drm']]) {
      shinyWidgets::sendSweetAlert(
        session = session,
        title = "Opération impossible !",
        text = "Vous avez déjà réalisé la saisie de ce DRM. Il n'est donc plus possible de le modifier.",
        type = "error"
      )
    } else {
      data_updated_drm <- values$fields
      
      db$insert(values$fields)
      shinyWidgets::sendSweetAlert(
        session = session,
        title = "Envoyé!",
        text = "Votre DRM a bien été envoyé.",
        type = "success"
      )
      shinyjs::reset("formulaire_drm_consultant")
      values$data <-
        db$find(query = values$query,
                fields = '{}',
                sort = '{"date_soumission": -1}')
    }
  }
})



observeEvent(input$autofill, {
  data <-
    db$find(query = values$query,
            sort = '{"date_soumission": -1}',
            limit = 1)
  if (is_empty(data)) {
    shinyWidgets::sendSweetAlert(
      session = session,
      title = "Erreur!",
      text = "Vous ne possédez pas de formulaire afin de préremplir votre DRM actuel.",
      type = "error"
    )
  } else {
    updateTextInput(session, "nom", value = as.character(data["last_name"]))
    updateTextInput(session, "prenom", value = as.character(data["first_name"]))
    updateTextInput(session, "nom_du_client", value = as.character(data["nom_du_client"]))
    
    updateTextInput(session, "intitule_du_poste", value = as.character(data["intitule_du_poste"]))
    updateNumericInput(session, "duree_mission", value = as.numeric(data["duree_mission"]))
    updateTextInput(session, "nom_du_projet", value = as.character(data["nom_du_projet"]))
    updateTextInput(session, "nom_chef_projet", value = as.character(data["nom_chef_projet"]))
    
    updateTextInput(session, "nom_coordinateur_projet", value = as.character(data["nom_coordinateur_projet"]))
    updateDateInput(session, "date_prochain_suivi", value = as.character(data["date_prochain_suivi"]))
    updateDateInput(session, "dernier_point_de_suivi", value = as.character(data["dernier_point_de_suivi"]))
    
    updateRadioButtons(session, "transmisson_client", selected = as.character(data["transmisson_client"]))
    updateRadioButtons(session, "charte_sii_client", selected = as.character(data["charte_sii_client"]))
    updateRadioButtons(session, "complexite_du_projet", selected = as.character(data["complexite_du_projet"]))
    updateTextAreaInput(session, "decouverte_env_travail", value = as.character(data["decouverte_env_travail"]))
    updateTextAreaInput(session, "env_contexte_client", value = as.character(data["env_contexte_client"]))
    updateTextAreaInput(session, "realisations_techniques", value = as.character(data["realisations_techniques"]))
    updateTextAreaInput(session, "difficultes_rencontrees", value = as.character(data["difficultes_rencontrees"]))
    updateTextAreaInput(session, "appreciation_globale", value = as.character(data["appreciation_globale"]))
  }
  
})

observeEvent(input$reset_formulaire, {
  shinyjs::reset("formulaire_drm_consultant")
})
