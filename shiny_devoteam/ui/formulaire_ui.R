disclaimer <-
  list(
    "Protection des données confidentielles des clients",
    "Dans le cadre de votre prestation, nous vous rappelons que vous devez tenir strictement confidentiels tous
documents, données et informations de toute nature qui vous ont été communiqués ou auxquels vous avez eu
accès dans le cadre de l’exécution de votre prestation.",
    "Cela signifie que vous ne devez en aucun cas transférer, stocker ou traiter ces données sur un matériel, support
ou espace personnel ni sur aucun réseau ou appareil informatique autres que ceux mis à votre disposition par le
client ou autorisé par celui-ci pour l’exécution de votre prestation.",
    "Nous vous informons que les clients sont désormais équipés informatiquement pour détecter toute fuite de
données.",
    "Enfin, nous tenons à vous préciser qu’un agissement contraire à ces règles serait susceptible d’entraîner des
sanctions disciplinaires mais également d’engager votre responsabilité financière et pénale selon le niveau de
gravité des manquements."
  )

formulaire <- shinydashboard::tabItem(tabName = "formulaire",
                      div(
                        id = "formulaire_drm_consultant",
                        shinydashboard::box(
                          title = "Fiche de suivi de prestation",
                          status = "primary",
                          solidHeader = TRUE,
                          width = 12,
                          column(
                            width = 12,
                            tags$h4(disclaimer[1]),
                            tags$p(disclaimer[2]),
                            tags$p(disclaimer[3]),
                            tags$p(disclaimer[4]),
                            tags$p(disclaimer[5])
                          ),
                          column(
                            width = 6,
                            shinyWidgets::actionBttn(
                              'autofill',
                              'Pré-remplir',
                              style = "material-flat",
                              color = "primary",
                              icon = tags$i(class="fas fa-file-signature")
                            )
                          ),
                          column(
                            width = 6,
                            shinyWidgets::actionBttn(
                              'reset_formulaire',
                              'Réinitialiser',
                              style = "material-flat",
                              color = "default",
                              icon = tags$i(class="fas fa-undo")
                            )
                          ),
                          column(width = 6, textInput("nom", h4("Nom"))),
                          column(width = 6, textInput("prenom", h4("Prénom"))),
                          # column(width = 12, textInput("email_sales", h4("Email du sales"))),
                          column(
                            width = 6,
                            textInput("nom_du_client", h4("Nom du client")),
                            textInput("intitule_du_poste", h4("Intitulé du poste")),
                            numericInput(
                              "duree_mission",
                              label = h4("Durée de la mission (en semaine)"),
                              value = 0,
                              min = 0
                            )
                          ),
                          column(
                            width = 6,
                            textInput("nom_du_projet", h4("Nom du projet")),
                            textInput("nom_chef_projet", h4("Nom & Prénom du Chef de projet")),
                            textInput("nom_coordinateur_projet",
                                      h4("Nom & Prénom du Coordinateur"))
                          ),
                          column(
                            width = 12,
                            column(width = 6,
                                   dateInput(
                                     "dernier_point_de_suivi",
                                     label = h4("Dernier point de suivi"),
                                     format = "dd-mm-yyyy"
                                   )),
                            column(width = 6,
                                   dateInput(
                                     "date_prochain_suivi",
                                     label = h4("Prochaine date de suivi prestation"),
                                     format = "mm-yyyy"
                                   ))
                          ),
                          column(
                            width = 12,
                            column(
                              width = 6,
                              radioButtons(
                                "transmisson_client",
                                h4("Transmission du plan de prévention Client"),
                                c("Oui" = "Oui", "Non" = "Non"),
                                inline = TRUE
                              )
                            ),
                            column(
                              width = 6,
                              radioButtons(
                                "charte_sii_client",
                                h4("Présentation de la charte SSI client"),
                                c("Oui" = "Oui", "Non" = "Non"),
                                inline = TRUE
                              )
                            )
                          ),
                          column(
                            width = 12,
                            radioButtons(
                              "complexite_du_projet",
                              h4("Complexité du projet"),
                              choices = list(
                                "Basse" = "Basse",
                                "Normale" = "Normale",
                                "Elevé" = "Elevé",
                                "Très Elevé" = "Très Elevé"
                              ),
                              inline = TRUE
                            )
                          ),
                          column(
                            width = 12,
                            h4("Description de la mission"),
                            textAreaInput(
                              "decouverte_env_travail",
                              h4("Découverte de l’environnement de travail et du contexte mission")
                            )
                          ),
                          column(width = 12, textAreaInput(
                            "env_contexte_client",
                            h4("Environnement et contexte client")
                          )),
                          column(width = 12, textAreaInput(
                            "realisations_techniques",
                            h4("Réalisations clés techniques et/ou fonctionnelles")
                          )),
                          column(width = 12, textAreaInput(
                            "difficultes_rencontrees",
                            h4("Difficultés rencontrées et actions menées pour y remédier")
                          )),
                          column(width = 12, textAreaInput(
                            "appreciation_globale",
                            h4("Appréciation globale de la mission")
                          )),
                          column(
                            width = 12,
                            shinyWidgets::actionBttn(
                              'submit',
                              'Envoyer',
                              style = "material-flat",
                              color = "danger",
                              icon = tags$i(class="fas fa-paper-plane")
                            )
                          )
                        )
                      ))