source("global.R")
ui <- fluidPage(
  shiny::singleton(
    shiny::tags$head(
      tags$link(rel = "stylesheet", href = "styles.css"),
      tags$link(rel = "stylesheet", href = "snackbar.css"),
      tags$link(rel = "stylesheet", href = "https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"),
      tags$script(src="snackbar.js"),
      tags$script(src="https://www.gstatic.com/firebasejs/5.7.0/firebase-app.js"),
      tags$script(src="https://www.gstatic.com/firebasejs/5.7.0/firebase-auth.js"),

      shiny::tags$script(src="sof-auth.js"),
      shiny::tags$script(src="timeout.js")
    )
  ),
  
  # load shinyjs on
  shinyjs::useShinyjs(),

  source("sof-auth/google_sign-in.R", local = TRUE)$value,
  source("ui/main.R", local = TRUE)$value
)




server <- shinyServer(function(input, output, session) {
  
  source(file.path("server", "connexion_serveur.R"),  local = TRUE)$value
  source(file.path("server", "general_modal_ajout_consultant.R"),  local = TRUE)$value
  source(file.path("server", "general_datatable.R"),  local = TRUE)$value
  source(file.path("server", "general_modal_manager.R"),  local = TRUE)$value
  source(file.path("server", "general_modal_sales.R"),  local = TRUE)$value
  source(file.path("server", "general_recapitulatif_drm.R"),  local = TRUE)$value
  source(file.path("server", "general_header.R"),  local = TRUE)$value
  source(file.path("server", "formulaire_serveur.R"),  local = TRUE)$value
  source(file.path("server", "database_management.R"),  local = TRUE)$value
  source(file.path("server", "general_modal_supprimer_drm.R"),  local = TRUE)$value

  
  # htmltools::htmlDependency(name = "font-awesome.min.css", version ="4.7.0", 
  #                           src = c(href = "https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"), stylesheet = "font-awesome.min.css")
  
  timestamp <- function() {
    format(Sys.time(), "%Y-%m-%d %H:%M:%OS")
  }
  
  human_timestamp <- function() {
    format(Sys.time(), "%Y%m-")
  }
  
  is_valid_email <- function(x) {
    grepl("^[a-zA-Z0-9_.+-]+@devoteam.com$", as.character(x), ignore.case=TRUE)
  }
  
  is_empty <- function(df) {
    return(is.data.frame(df) &&
             nrow(df) == 0)
  }

  
  user <- reactiveValues(email = NULL, profile_name = NULL, photo_url = NULL, data = NULL)
  values <- reactiveValues()
  
  observeEvent(input$sof_auth_user, {
    user$email = input$sof_auth_user$email
    user$profile_name = input$sof_auth_user$displayName
    user$photo_url = input$sof_auth_user$photoURL
  })
  
  is_admin <- function() {
    email <- user$email
    if (is.null(email)) return(FALSE)
    query <- sprintf('{"email_collaborateur": "%s"}', email)
    df <- find_in_database(admin_db, query = query, fields = '{ "admin": true }')
    if (is_empty(df)) return(FALSE)
    return(df["admin"] == TRUE)
  }
  
  is_manager <- function() {
    email <- user$email
    if (is.null(email)) return(FALSE)
    query <- sprintf('{"email_collaborateur": "%s"}', email)
    df <- find_in_database(managers_db, query = query, fields = '{ "role": true }')
    if (is_empty(df)) return(FALSE)
    return(df["role"] == "manager")
  }
  
  is_sales <- function() {
    email <- user$email
    if (is.null(email)) return(FALSE)
    query <- sprintf('{"email_collaborateur": "%s"}', email)
    df <- find_in_database(sales_db, query = query, fields = '{ "role": true }')
    if (is_empty(df)) return(FALSE)
    return(df["role"] == "sales")
  }
  
  is_consultant <- function() {
    email <- user$email
    if (is.null(email)) return(FALSE)
    query <- sprintf('{"email_collaborateur": "%s"}', email)
    df <- find_in_database(consultants_db, query = query, fields = '{ "email_collaborateur": true }')
    if (is_empty(df)) return(FALSE)
    return(df["email_collaborateur"] == email)
  }
  
  
  observeEvent(user$email, {

    if (is_manager()) {
      shinyjs::hide(id = "ajouter_consultant")
      shinyjs::hide(id = "supprimer_drm")
      shinyjs::hide(selector = '[data-value="formulaire"]')
      
      if (is.null(user$email)) return(FALSE)
      query <- sprintf('{"email_manager": "%s"}', user$email)
      df <- find_in_database(db, query = query, fields = '{}')
      values$query <-
        paste0('{"email_manager": "', user$email, '" }')
    } else if (is_sales()) {
      shinyjs::hide(id = "ajouter_consultant")
      shinyjs::hide(id = "supprimer_drm")
      shinyjs::hide(selector = '[data-value="formulaire"]')
      
      if (is.null(user$email)) return(FALSE)
      query <- sprintf('{"email_sales": "%s"}', user$email)
      df <- find_in_database(db, query = query, fields = '{}')
      values$query <-
        paste0('{"email_sales": "', user$email, '" }')
    }
    else if (is_consultant()) {
      shinyjs::hide(id = "ajouter_consultant")
      shinyjs::hide(id = "supprimer_drm")
      shinyjs::show(selector = '[data-value="formulaire"]')
      shinyjs::show(selector = '[data-value="general"]')
      
      values$query <-
        paste0('{"email": "', user$email , '" }')
    }
    
    if (is_admin()) {
      shinyjs::show(id = "ajouter_consultant")
      shinyjs::show(id = "supprimer_drm")
      shinyjs::hide(selector = '[data-value="formulaire"]')
      if(is.null(values$query)) values$query <- '{}'
    } 
    
    if (all(c(is_admin(), is_manager(), is_consultant(), is_sales()) == rep(FALSE, 4))) {
      shinyjs::hide(selector = '[data-value="formulaire"]')
      shinyjs::hide(selector = '[data-value="general"]')
      shinyjs::runjs("document.getElementById('submit_sign_out').click();")
    }
    
  })
  
  
  # Déconnexion de la base de donnée à l'arrêt de l'application
  onStop(function() {
    db$disconnect()
    admin_db$disconnect()
    sales_db$disconnect()
    consultants_db$disconnect()
    stopApp()
  })
  
  session$onSessionEnded(function() {
    db$disconnect()
    admin_db$disconnect()
    sales_db$disconnect()
    consultants_db$disconnect()
    stopApp()
  })
  
})

shinyApp(ui = ui, server = server)
# app <- shinyApp(ui = ui, server = server)
# 
# shiny::runApp(app)
