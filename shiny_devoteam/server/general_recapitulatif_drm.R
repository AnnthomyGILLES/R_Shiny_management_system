

observeEvent(input$selectbutton_view[1], {
  values$selected_row <-
    as.numeric(strsplit(input$selectbutton_view[1], "_")[[1]][3])
  data <- values$data[values$selected_row, ]
  output$md_nom_consultant <-
    renderText({
      paste("Nom du consultant :",
            as.character(data['first_name']),
            as.character(data['last_name']))
    })
  output$md_email <-
    renderText({
      paste("Email du consultant :", as.character(data['email']))
    })
  output$md_email_sales <-
    renderText({
      paste("Email du sales :", as.character(data['email_sales']))
    })
  output$md_email_manager <-
    renderText({
      paste("Email du manager :", as.character(data['email_manager']))
    })
  
  output$md_nom_du_client <-
    renderText({
      paste("Nom du client :", as.character(data['nom_du_client']))
    })
  output$md_intitule_du_poste <-
    renderText({
      paste("Intitulé du poste :", as.character(data['intitule_du_poste']))
    })
  output$md_duree_mission <-
    renderText({
      paste("Durée de la mission :", as.character(data['duree_mission']))
    })
  output$md_nom_du_projet <-
    renderText({
      paste("Nom du projet :", as.character(data['nom_du_projet']))
    })
  
  output$md_nom_chef_projet <-
    renderText({
      paste("Nom du chef de projet :", as.character(data['nom_chef_projet']))
    })
  output$md_nom_coordinateur_projet <-
    renderText({
      paste("Nom du coordinateur de projet :", as.character(data['nom_coordinateur_projet']))
    })
  output$md_date_prochain_suivi <-
    renderText({
      paste("Date du prochain suivi :", as.character(data['date_prochain_suivi']))
    })
  output$md_dernier_point_de_suivi <-
    renderText({
      paste("Date du dernier point de suivi :", as.character(data['dernier_point_de_suivi']))
    })
  
  output$md_transmisson_client <-
    renderText({
      paste("Transmission du plan de prévention Client :",
            as.character(data['transmisson_client']))
    })
  output$md_charte_sii_client <-
    renderText({
      paste("Présentation de la charte SSI client :", as.character(data['charte_sii_client']))
    })
  output$md_complexite_du_projet <-
    renderText({
      paste("Complexité du projet :", as.character(data['complexite_du_projet']))
    })
  output$md_decouverte_env_travail <-
    renderText({
      as.character(data['decouverte_env_travail'])
    })
  
  output$md_env_contexte_client <-
    renderText({
      as.character(data['env_contexte_client'])
    })
  output$md_realisations_techniques <-
    renderText({
      as.character(data['realisations_techniques'])
    })
  output$md_difficultes_rencontrees <-
    renderText({
      as.character(data['difficultes_rencontrees'])
    })
  output$md_appreciation_globale <-
    renderText({
      as.character(data['appreciation_globale'])
    })
  if (data['updated_par_manager'] == TRUE) {
    output$md_nom_manager <-
      renderText({
        paste("Nom du manager :", as.character(data['nom_manager']))
      })
    output$md_axes_amelioration <-
      renderText({
        as.character(data['axes_amelioration'])
      })
    output$md_conges <-
      renderText({
        as.character(data['conges'])
      })
    output$md_formation <-
      renderText({
        as.character(data['formation'])
      })
    output$md_synthese_du_suivi <-
      renderText({
        as.character(data['synthese_du_suivi'])
      })
  }
  
  if (data['updated_par_sales'] == TRUE) {
    output$md_appreciation_globale_client <-
      renderText({
        as.character(data['appreciation_globale_client'])
      })
    output$md_nom_sales <-
      renderText({
        paste("Nom du sales :", as.character(data['nom_sales']))
      })
  }
  
  shinyjs::show(id = "validate_drm")
  shinyjs::hide(id = "download_report")
  
  if ((data['updated_par_sales'] == "false") ||
      (data['updated_par_manager'] == "false")) {
    shinyjs::hide(id = "validate_drm")
  }
  
  if (all(
    c(
      'valide_par_consultant',
      'valide_par_sales',
      'valide_par_manager'
    ) %in% names(data)
  )) {
    if((data['valide_par_consultant'] == TRUE) && (data['valide_par_sales'] == TRUE) && (data['valide_par_manager'] == TRUE)) {
      shinyjs::show(id = "download_report")
      shinyjs::hide(id = "validate_drm")
    }
  }
  
  
  output$panelStatus <- reactive({
    (data['updated_par_sales'] == TRUE) &&
      (data['updated_par_manager'] == TRUE)
  })
  shinyBS::toggleModal(session, "modal_recap_drm", toggle = "open")
}, ignoreInit = T)

observeEvent(input$validate_drm, {
  selected_row <- values$selected_row
  data <- values$data[selected_row, ]
  

  shinyWidgets::confirmSweetAlert(
    session,
    inputId = "alert_validate_drm",
    title = "Envoyer ?",
    text = "Vous vous apprêtez à valider le DRM. Cette opération est irréversible.",
    type = "warning",
    btn_labels = c("Annuler", "Confirmer"),
    closeOnClickOutside = FALSE,
    html = FALSE
  )
})


observeEvent(input$alert_validate_drm, {
  if (isTRUE(input$alert_validate_drm)) {
    selected_row <- values$selected_row
    id <- values$data[selected_row, "_id"]
    tm <- format(Sys.time(), "%d/%m/%Y %H:%M:%OS")
    
    if (is_consultant()) {
      field_1 <- paste('"tm_validation_consultant" : "', tm, '",')
      field_2 <- paste('"valide_par_consultant" : true')
    } else if (is_sales()) {
      field_1 <- paste('"tm_validation_sales" : "', tm, '",')
      field_2 <- paste('"valide_par_sales" : true')
    } else if (is_manager()) {
      field_1 <- paste('"tm_validation_manager" : "', tm, '",')
      field_2 <- paste('"valide_par_manager" : true')
    }
    
    
    db$update(
      paste0('{"_id": { "$oid" : "', id, '" } }'),
      paste0('{ "$set" : { ',
             field_1,
             field_2,
             '} }')
    )
    
    shinyWidgets::sendSweetAlert(
      session = session,
      title = "Envoyé!",
      text = "Votre validation du DRM a bien été soumise.",
      type = "success"
    )
    values$data <- find_in_database(db, query = values$query, fields = '{}')
    
    shinyBS::toggleModal(session, "modal_recap_drm", toggle = "close")
  }
})


output$download_report <- downloadHandler(
  # For PDF output, change this to "report.pdf"
  
  filename = "report.pdf",
  content = function(file) {
    withProgress(message = 'Création du rapport', value = 0, {
      data <- values$data[values$selected_row, ]
      temp_report <- file.path(tempdir(), "report_drm.Rmd")
      temp_css <- file.path(tempdir(), "style_drm.css")
      temp_logo <- file.path(tempdir(), "logo_devoteam.png")
      temp_html_file <- file.path(tempdir(), "report.html")
      
      file.copy("report_drm.Rmd", temp_report, overwrite = TRUE)
      file.copy("style_drm.css", temp_css, overwrite = TRUE)
      file.copy("logo_devoteam.png", temp_logo, overwrite = TRUE)
      incProgress(0.4, detail = "Récupération des données")
      # Set up parameters to pass to Rmd document
      params <- list(
        nom_consultant = paste(as.character(data['first_name']), as.character(data['last_name'])),
        email = paste(data['email']),
        nom_sales = paste(data['nom_sales']),
        email_sales = paste(data['email_sales']),
        nom_manager = paste(data['nom_manager']),
        email_manager = paste(data['email_manager']),
        nom_du_client = data['nom_du_client'],
        intitule_du_poste = data['intitule_du_poste'],
        duree_mission = data['duree_mission'],
        nom_du_projet = data['nom_du_projet'],
        nom_chef_projet = data['nom_chef_projet'],
        nom_coordinateur_projet = data['nom_coordinateur_projet'],
        date_prochain_suivi = data['date_prochain_suivi'],
        dernier_point_de_suivi = data['dernier_point_de_suivi'],
        transmisson_client = data['transmisson_client'],
        charte_sii_client = data['charte_sii_client'],
        complexite_du_projet = data['complexite_du_projet'],
        decouverte_env_travail = data['decouverte_env_travail'],
        env_contexte_client = data['env_contexte_client'],
        realisations_techniques = data['realisations_techniques'],
        difficultes_rencontrees = data['difficultes_rencontrees'],
        appreciation_globale = data['appreciation_globale'],
        axes_amelioration = data['axes_amelioration'],
        conges = data['conges'],
        formation = data['formation'],
        synthese_du_suivi = data['synthese_du_suivi'],
        appreciation_globale_client = data['appreciation_globale_client'],
        tm_validation_manager = data['tm_validation_manager'],
        tm_validation_sales = data['tm_validation_sales'],
        tm_validation_consultant = data['tm_validation_consultant']
      )
      incProgress(0.7, detail = "Génération du rapport")
      
      rmarkdown::render(
        temp_report,
        prettydoc::html_pretty(theme = "architect", css = "style_drm.css"),
        output_file = temp_html_file,
        params = params,
        envir = new.env(parent = globalenv())
      )
      incProgress(0.85, detail = "Génération du document PDF")
      webshot::webshot(temp_html_file, file)
    })
  }
  
)
