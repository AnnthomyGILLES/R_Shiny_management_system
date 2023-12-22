

shinyInput <- function(FUN, len, id, ...) {
  inputs <- character(len)
  for (i in seq_len(len)) {
    inputs[i] <- as.character(FUN(paste0(id, i), ...))
  }
  inputs
}

icon_generator <- function(FUN, len, name, class) {
  inputs <- character(len)
  for (i in seq_len(len)) {
    inputs[i] <- as.character(FUN(name, class))
  }
  inputs
}

output$mytable <- DT::renderDataTable({
  if(!is.null(values$query)) {
    df <-
      db$find(query = values$query,
              fields = '{}',
              sort = '{"date_soumission": -1}')
  }

  if(is_empty(df) || is.null(values$query)) {
    values$data = data.frame()
  } else {
    style_view_button <- NULL
    index <- which(df['valide_par_consultant'] == TRUE & df['valide_par_sales'] == TRUE & df['valide_par_manager'] == TRUE)
    if((df['valide_par_consultant'] == TRUE) && (df['valide_par_sales'] == TRUE) && (df['valide_par_manager'] == TRUE)) {
      style_view_button <- "background-color: #337ab7; border-color: #2e6da4"
    }
    df <-
      df %>% dplyr::mutate(
        view = shinyInput(
          actionButton,
          nrow(df),
          'button_view_',
          label = "",
          icon = tags$i(class="fas fa-eye"),
          onclick  = 'Shiny.onInputChange(\"selectbutton_view\",  [this.id, Math.random()])'
        )
      )
    
    # df$view[index] <- gsub('action-button"','action-button" style = "background-color: #FF9F1C', df$view[index])

    if (is_manager()) {
      df <-
        df %>% dplyr::mutate(
          update = shinyInput(
            actionButton,
            nrow(df),
            'button_manager_',
            label = "",
            icon = tags$i(class="fas fa-edit"),
            onclick  = 'Shiny.onInputChange(\"selectbutton_manager\",  [this.id, Math.random()])'
          )
        )
      df <- df %>% 
        dplyr::select(update, view, last_name, first_name, date_soumission, nom_du_client, nom_du_projet, duree_mission, nom_chef_projet, dernier_point_de_suivi, dplyr::everything())
      index <- df['updated_par_manager'] == TRUE
      df$update[index] <- as.character(tags$i(class="fas fa-check color-update"))
      index <- df['valide_par_manager'] == TRUE
      df$update[index] <- as.character(tags$i(class="fas fa-check-double color-validate"))  
      index <- which( df$valide_par_consultant == TRUE & df$valide_par_sales == TRUE & df$valide_par_manager == TRUE)
      df$update[index] <- as.character(tags$i(class="fas fa-check-circle color-successdrm"))
    } else if (is_sales()) {
      df <-
        df %>% dplyr::mutate(
          update = shinyInput(
            actionButton,
            nrow(df),
            'button_sales_',
            label = "",
            icon = tags$i(class="fas fa-edit"),
            onclick  = 'Shiny.onInputChange(\"selectbutton_sales\",  [this.id, Math.random()])'
          )
        )
      df <- df %>% 
        dplyr::select(update, view, last_name, first_name, date_soumission, nom_du_client, nom_du_projet,duree_mission, nom_chef_projet, dernier_point_de_suivi, dplyr::everything())
      index <- which(df['updated_par_sales'] == TRUE)
      df$update[index] <-  as.character(tags$i(class="fas fa-check color-update"))
      index <- df['valide_par_sales'] == TRUE
      df$update[index] <- as.character(tags$i(class="fas fa-check-double color-validate")) 
      index <- which( df$valide_par_consultant == TRUE & df$valide_par_sales == TRUE & df$valide_par_manager == TRUE)
      df$update[index] <- as.character(tags$i(class="fas fa-check-circle color-successdrm"))
    


    } else if(is_consultant()) {
      df <-
        df %>% dplyr::mutate(
          status = icon_generator(
            icon,
            nrow(df),
            'check',
            "color-update"
          )
        )
      df <- df %>% 
        dplyr::select(status, view, last_name, first_name, date_soumission, nom_du_client, nom_du_projet, duree_mission, nom_chef_projet, dernier_point_de_suivi, dplyr::everything())
      
      index <- which(df$updated_par_sales == "false" | df$updated_par_manager == "false")
      df$status[index] <- as.character(tags$i(class="fas fa-edit"))
      index <- which(df$updated_par_sales == TRUE & df$updated_par_manager == TRUE)
      df$status[index] <- as.character(tags$i(class="fas fa-check color-update"))
      index <- which(df$valide_par_consultant == TRUE)
      df$status[index] <- as.character(tags$i(class="fas fa-check-double color-validate")) 
      index <- which( df$valide_par_consultant == TRUE & df$valide_par_sales == TRUE & df$valide_par_manager == TRUE)
      df$status[index] <- as.character(tags$i(class="fas fa-check-circle color-successdrm"))
      
    }
    
    values$data <- df
    
  }
  

  
    DT::datatable(
      values$data,
      extensions = c("Responsive", "Buttons"),
      selection = "single",
      options = list(
        dom = "Bfrtip",
        buttons = c("csv", "excel", "pdf", "print")
      ),
      escape = FALSE
    )
  
})
