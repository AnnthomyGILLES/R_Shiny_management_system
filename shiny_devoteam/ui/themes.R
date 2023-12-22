theme_boe_website <-dashboardthemes::shinyDashboardThemeDIY(
  
  ### general
  appFontFamily = "Arial"
  # ,appFontColor = "rgb(42,102,98)"
  ,appFontColor = "#003459"
  ,primaryFontColor = "#FDFFFC"
  ,infoFontColor = "#FDFFFC"
  ,successFontColor = "#FDFFFC"
  ,warningFontColor = "#FDFFFC"
  ,dangerFontColor = "#FDFFFC"
  ,bodyBackColor = "rgb(255,255,254)"
  
  ### header
  ,logoBackColor = "rgb(45,59,66)"
  
  ,headerButtonBackColor = "rgb(45,59,66)"
  ,headerButtonIconColor = "rgb(255,255,255)"
  ,headerButtonBackColorHover = "rgb(45,59,66)"
  ,headerButtonIconColorHover = "#f7485e"
  
  ,headerBackColor = "rgb(45,59,66)"
  ,headerBoxShadowColor = ""
  ,headerBoxShadowSize = "0px 0px 0px"
  
  ### sidebar
  ,sidebarBackColor = "#f7485e"
  ,sidebarPadding = 0
  
  ,sidebarMenuBackColor = "transparent"
  ,sidebarMenuPadding = 0
  ,sidebarMenuBorderRadius = 0
  
  ,sidebarShadowRadius = ""
  ,sidebarShadowColor = "0px 0px 0px"
  
  ,sidebarUserTextColor = "rgb(255,255,255)"
  
  ,sidebarSearchBackColor = "rgb(255,255,255)"
  ,sidebarSearchIconColor = "#f7485e"
  ,sidebarSearchBorderColor = "rgb(255,255,255)"
  
  ,sidebarTabTextColor = "rgb(255,255,255)"
  ,sidebarTabTextSize = 14
  ,sidebarTabBorderStyle = "none"
  ,sidebarTabBorderColor = "none"
  ,sidebarTabBorderWidth = 0
  
  ,sidebarTabBackColorSelected = "rgb(45,59,66)"
  ,sidebarTabTextColorSelected = "rgb(255,255,255)"
  ,sidebarTabRadiusSelected = "0px"
  
  ,sidebarTabBackColorHover = "rgb(186,51,83)"
  ,sidebarTabTextColorHover = "rgb(255,255,255)"
  ,sidebarTabBorderStyleHover = "none"
  ,sidebarTabBorderColorHover = "none"
  ,sidebarTabBorderWidthHover = 0
  ,sidebarTabRadiusHover = "0px"
  
  ### boxes
  ,boxBackColor = "rgb(248,248,248)"
  ,boxBorderRadius = 0
  ,boxShadowSize = "0px 0px 0px"
  ,boxShadowColor = ""
  ,boxTitleSize = 18
  ,boxDefaultColor = "rgb(248,248,248)"
  ,boxPrimaryColor = "rgb(0,144,255)"
  ,boxInfoColor = "rgb(225,225,225)"
  ,boxSuccessColor = "rgb(59,133,95)"
  ,boxWarningColor = "rgb(178,83,149)"
  ,boxDangerColor = "#f7485e"
  
  ,tabBoxTabColor = "rgb(248,248,248)"
  ,tabBoxTabTextSize = 14
  ,tabBoxTabTextColor = "rgb(42,102,98)"
  ,tabBoxTabTextColorSelected = "#f7485e"
  ,tabBoxBackColor = "rgb(248,248,248)"
  ,tabBoxHighlightColor = "#f7485e"
  ,tabBoxBorderRadius = 0
  
  ### inputs
  ,buttonBackColor = "#f7485e"
  ,buttonTextColor = "rgb(255,255,255)"
  ,buttonBorderColor = "#f7485e"
  ,buttonBorderRadius = 0
  
  ,buttonBackColorHover = "rgb(186,51,83)"
  ,buttonTextColorHover = "rgb(255,255,255)"
  ,buttonBorderColorHover = "rgb(186,51,83)"
  
  ,textboxBackColor = "rgb(255,255,255)"
  ,textboxBorderColor = "rgb(118,118,118)"
  ,textboxBorderRadius = 0
  ,textboxBackColorSelect = "rgb(255,255,255)"
  ,textboxBorderColorSelect = "rgb(118,118,118)"
  
  ### tables
  ,tableBackColor = "rgb(248,248,248)"
  ,tableBorderColor = "rgb(235,235,235)"
  ,tableBorderTopSize = 1
  ,tableBorderRowSize = 1
  
)

logo_boe_website <- dashboardthemes::shinyDashboardLogoDIY(
  
  boldText = "DevoTeam"
  ,mainText = ""
  ,textSize = 20
  ,badgeText = "DRM"
  ,badgeTextColor = "white"
  ,badgeTextSize = 4
  ,badgeBackColor = "#40E0D0"
  ,badgeBorderRadius = 3
  
)