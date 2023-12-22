observeEvent(session$userData$current_user(), {
  current_user <- session$userData$current_user()
    if (is.null(current_user)) {
      shinyjs::show("sign_in_panel")
      shinyjs::hide("main")
    } else {
      shinyjs::hide("sign_in_panel")
      
      if (current_user$emailVerified == TRUE) {
        shinyjs::show("main")
      }
      
      # else {
      #   shinyjs::show("verify_email_view")
      # }
      
  }

  
}, ignoreNULL = FALSE)




# Signed in user --------------------
# the `session$userData$current_user()` reactiveVal will hold information about the user
# that has signed in through Firebase.  A value of NULL will be used if the user is not
# signed in
session$userData$current_user <- reactiveVal(NULL)

# input$sof_auth_user comes from front end js in "www/sof-auth.js"
observeEvent(input$sof_auth_user, {
  # set the signed in user
  session$userData$current_user(input$sof_auth_user)
  
}, ignoreNULL = FALSE)