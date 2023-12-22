#  Formulaire de suppression d'un DRM par l'admin
modal_supprimer_drm <- shinyBS::bsModal(
  "form_supprimer_drm",
  "Supprimer un DRM de la base - Vous avez la visibilité sur tous les DRMs.",
  "supprimer_drm",
  size = "large",
  column(
    width = 12, DT::dataTableOutput("drm_datatable")
  )
)