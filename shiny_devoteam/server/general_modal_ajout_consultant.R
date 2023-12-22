observeEvent(input$ajouter_consultant, {
  if (is_admin()) {
    shinyBS::toggleModal(session, "form_ajout_consultant", toggle = "open")
  }
}, ignoreInit = T)


observeEvent(input$submit_ajouter_consultant, {
  query <- sprintf('{"email_collaborateur": "%s"}', input$form_email_collaborateur)
  df_consultant <- find_in_database(consultants_db, query = query, fields = '{}')
  
  if (input$form_email_collaborateur == "" ||
      input$form_email_sales == "" || input$form_email_manager == "")
  {
    shinyWidgets::sendSweetAlert(
      session = session,
      title = "Attention!",
      text = "Veuillez remplir tous les champs afin de soumettre ce formulaire.",
      type = "error"
    )
  } 
  else if (!all(is_valid_email(input$form_email_collaborateur) &&
             is_valid_email(input$form_email_sales) &&
             is_valid_email(input$form_email_manager))) {
    shinyWidgets::sendSweetAlert(
      session = session,
      title = "Attention!",
      text = "Votre email ne semble pas valide. Il faut un email de la forme *******@devoteam.com.",
      type = "error"
    )
  }
  else if (!is_empty(df_consultant)) {
    if (df_consultant["email_collaborateur"] == tolower(input$form_email_collaborateur)) {
      shinyWidgets::sendSweetAlert(
        session = session,
        title = "Opération impossible !",
        text = sprintf("Ce consultant est présent dans la base.\n L'email de son manager est le suivant %s, et celui de son sales %s", df_consultant["manager"], df_consultant["sales"]),
        type = "error"
      )
    }
  }
  else {
    table_consultant <-
      data.frame(
        email_collaborateur = tolower(input$form_email_collaborateur),
        role = "consultant",
        sales = tolower(input$form_email_sales),
        manager = tolower(input$form_email_manager),
        stringsAsFactors=FALSE
      )
    consultants_db$insert(table_consultant)
    
    
    query <- sprintf('{"email_collaborateur": "%s"}', input$form_email_sales)
    user_role <- find_in_database(sales_db, query = query, fields = '{ "email_collaborateur": true}')
    if (is_empty(user_role)) {
      new_sales <-
        data.frame(email_collaborateur = tolower(input$form_email_sales),
                   role = "sales")
      sales_db$insert(new_sales)
    }
    
    query <- sprintf('{"email_collaborateur": "%s"}', input$form_email_manager)
    user_role <- find_in_database(managers_db, query = query, fields = '{ "email_collaborateur": true}')
    if (is_empty(user_role)) {
      new_manager <-
        data.frame(
          email_collaborateur = tolower(input$form_email_manager),
          role = "manager",
          admin = "false"
        )
      managers_db$insert(new_manager)
    }
    
    shinyWidgets::confirmSweetAlert(
      session,
      inputId = "alert_ajout_consultant",
      title = "Envoyer ?",
      text = paste(
        "Le compte du consultant sera enregistré dans la base. Vérifiez donc bien les emails! \n",
        "Email du consultant:",
        input$form_email_collaborateur,
        "\n",
        "Email du sales:",
        input$form_email_sales,
        "\n",
        "Email du manager:",
        input$form_email_manager,
        "\n"
      ),
      type = "warning",
      btn_labels = c("Annuler", "Confirmer"),
      closeOnClickOutside = FALSE,
      html = FALSE
    )
    
  }
  
})

observeEvent(input$alert_ajout_consultant, {
  if (isTRUE(input$alert_ajout_consultant)) {
    data_updated_drm <- values$fields
    if (input$alert_ajout_consultant == TRUE) {
      shinyWidgets::sendSweetAlert(
        session = session,
        title = "Envoyé!",
        text = paste(
          "Le compte du consultant a bien été enregistré dans la base.\n",
          "Email du consultant:",
          input$form_email_collaborateur,
          "\n",
          "Email du sales:",
          input$form_email_sales,
          "\n",
          "Email du manager:",
          input$form_email_manager,
          "\n"
        ),
        type = "success"
      )
      
      shinyjs::reset("form_ajout_consultant")
      shinyBS::toggleModal(session, "form_ajout_consultant", toggle = "close")
    }
  }
})
