shinyUI(fluidPage(
  
  div(
  id = "sign_in_panel",
  class = "auth_panel text-center",
  img(src = 'devoteam-logo.png', height = '100%', width = '100%'),
  div(
    class = "form-group",
    style = "width: 100%",
    h3('Devoteam DRM'),
    hr(),
    shinyWidgets::actionBttn(
      'google_sign_in',
      'Google Sign in',
      style = "material-flat",
      color = "primary",
      icon = tags$i(class="fab fa-google"),
      size = "lg"
    ),
    hr()
  )
),
br(),

tags$footer("Copyright © Devoteam DRM 2019 -", tags$a(href="https://www.linkedin.com/in/annthomygilles/", "GILLES Annthomy"),  style = "text-align:center; align: center; padding: 0px; margin: 0px;")
))

