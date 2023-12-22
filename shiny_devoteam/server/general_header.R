observeEvent(values$data, {
  count_valuebox_1 <- NULL
  count_valuebox_2 <- NULL
  count_valuebox_3 <- NULL
  count_valuebox_4 <- NULL
  status <- NULL
  drms_valides <- NULL
  drms_succes <- NULL
  
  if (is_manager()) {
    status <- "Manager"
    drms_succes <- db$count(
      sprintf('{"email_manager": "%s", "valide_par_sales" : true, "valide_par_manager" : true, "valide_par_consultant" : true}', user$email)
    )
    
    drms_valides <- db$count(
      sprintf('{"email_manager": "%s", "valide_par_manager" : true }', user$email)
    )
    
    
    count_valuebox_1 <-
      list(count = db$count(values$query), label = "DRM soumis par le(s) consultant(s).")
    count_valuebox_2 <-
      list(count = db$count(
        sprintf('{"email_manager": "%s", "updated_par_manager" : true, "valide_par_manager" : "false"}', user$email)
      ), label = "DRM(s) complété(s) mais pas validé(s) par le manager.")
    count_valuebox_3 <-
      list(count = (db$count(
        sprintf('{"email_manager": "%s", "valide_par_manager" : true}', user$email)
      ) - drms_succes), label = "DRM(s) complété(s) et validé(s) par le manager.")
    count_valuebox_4 <-
      list(count = db$count(
        sprintf('{"email_manager": "%s", "valide_par_sales" : true, "valide_par_manager" : true, "valide_par_consultant" : true}', user$email)
      ), label = "DRM(s) validé(s) par toutes les parties.")
  } else if (is_consultant()) {
    status <- "Consultant"
    drms_succes <- db$count(
      sprintf('{"email": "%s", "valide_par_sales" : true, "valide_par_manager" : true, "valide_par_consultant" : true}', user$email)
    )
    
    drms_valides_par_consultant <- (db$count(
      sprintf('{"email": "%s", "valide_par_consultant" : true}', user$email)
    ) -  drms_succes)
    
    drms_saisie <- ( db$count(
      sprintf('{"email": "%s", "updated_par_manager" : true, "updated_par_sales" : true}', user$email)
    ) - drms_succes - drms_valides_par_consultant)
    
    count_valuebox_1 <-
      list(count = db$count(values$query), label = "DRM soumis.")
    count_valuebox_2 <-
      list(count = drms_saisie, label = "DRM(s) complété(s) par le manager et le sales.")
    count_valuebox_3 <-
      list(count = drms_valides_par_consultant, label = "DRM(s) validé(s) par le consultant.")
    count_valuebox_4 <-
      list(count = db$count(
        sprintf('{"email": "%s", "valide_par_sales" : true, "valide_par_manager" : true, "valide_par_consultant" : true}', user$email)
      ), label = "DRM(s) validé(s) par toutes les parties.")
  } else if (is_sales()) {
    status <- "Sales"
    drms_valides <- db$count(
      sprintf('{"email_sales": "%s", "valide_par_sales" : true }', user$email)
    )
    
    drms_succes <- db$count(
      sprintf('{"email_sales": "%s", "valide_par_sales" : true, "valide_par_manager" : true, "valide_par_consultant" : true}', user$email)
    )
    
    count_valuebox_1 <-
      list(count = db$count(values$query), label = "DRM soumis par le(s) consultant(s).")
    count_valuebox_2 <-
      list(count = db$count(
        sprintf('{"email_sales": "%s", "updated_par_sales" : true, "valide_par_sales" : "false"}', user$email)
      ), label = "DRM(s) complété(s) mais pas validé(s) par le sales.")
    count_valuebox_3 <-
      list(count = (db$count(
        sprintf('{"email_sales": "%s", "updated_par_sales" : true, "valide_par_sales" : true}', user$email)
      ) - drms_valides), label = "DRM(s) complété(s) et validé(s) par le sales.")
    count_valuebox_4 <-
      list(count = db$count(
        sprintf('{"email_sales": "%s", "valide_par_sales" : true, "valide_par_manager" : true, "valide_par_consultant" : true}', user$email)
      ), label = "DRM(s) validé(s) par toutes les parties.")
    
  }
  
  if (is_admin()) {
    status <- "Manager Admin"
  } 
  
  output$profile <- renderUI({
    shinydashboardPlus::widgetUserBox(
      title =  sprintf('%s - Connecté(e) en tant que %s', user$profile_name, status),
      subtitle = user$email,
      type = NULL,
      width = 12,
      src = user$photo_url,
      color = "aqua-active",
      closable = FALSE,
      boxToolSize = "sm",
      tags$br(),
      column(
        width = 3,
        descriptionBlock(
          number_color = "red",
          number_icon = "fas fa-file-upload",
          header = h3(as.character(count_valuebox_1$count)),
          text = h5(as.character(count_valuebox_1$label)),
          right_border = TRUE,
          margin_bottom = FALSE
        )
      ),
      column(
        width = 3,
        descriptionBlock(
          number_color = "blue",
          number_icon = "fas fa-check",
          header = h3(as.character(count_valuebox_2$count)),
          text = h5(as.character(count_valuebox_2$label)),
          right_border = FALSE,
          margin_bottom = FALSE
        )
      ),
      column(
        width = 3,
        descriptionBlock(
          number_color = "orange",
          number_icon = "fas fa-check-double",
          header = h3(as.character(count_valuebox_3$count)),
          text = h5(as.character(count_valuebox_3$label)),
          right_border = FALSE,
          margin_bottom = FALSE
        )
      ),
      column(
        width = 3,
        descriptionBlock(
          number_color = "green",
          number_icon = "fas fa-check-circle",
          header = h3(as.character(count_valuebox_4$count)),
          text = h5(as.character(count_valuebox_4$label)),
          right_border = FALSE,
          margin_bottom = FALSE
        )
      ),
      tags$br(),
      tags$br(),
      if (is_admin()) {
        column(
          width = 12,
          align = "center",
          column(
            width = 6,
            shinyWidgets::actionBttn(
              'ajouter_consultant',
              'Ajouter un consultant',
              style = "material-flat",
              color = "primary",
              icon = tags$i(class="fas fa-users")
            )
          ),
          column(
            width = 6,
            shinyWidgets::actionBttn(
              'supprimer_drm',
              'Supprimer un DRM',
              style = "material-flat",
              color = "danger",
              icon = tags$i(class="fas fa-trash-alt")
            )
          )
        )
      }
      
    )
  })
})
