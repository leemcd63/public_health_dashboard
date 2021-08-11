
ui <- dashboardPage(skin = "black",

                    # ShinyDashboard tabs
                    dashboardHeader(title = "Health in Scotland - The Drug Crisis"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Scotland Health Overview", tabName = "overview"),
                        menuItem("Drug Deaths", tabName = "drug_deaths"),
                        menuItem("Alcohol Deaths", tabName = "alcohol_deaths")
                      )
                    ),

                    dashboardBody(
                      tabItems(
                        # OVERVIEW PANEL ---------------------------------------

                        tabItem(tabName = "overview",

                        ),


                        # DRUGS PANEL -------------------------------------------------------------
                        tabItem(tabName = "drug_deaths",
                                fluidRow(
                                  column(width = 6,
                                         box(width = NULL, solidHeader = TRUE, background = "purple",
                                             column(width = 6, align = "center",
                                                    selectInput("drug_map_year",
                                                                label = "Year:",
                                                                choices = c("All",
                                                                            sort(unique(drug_deaths$year))),
                                                                selected = "All")
                                             ),
                                             column(width = 6, align = "center",
                                                    selectInput("drug_map_name",
                                                                label = "Select Drug:",
                                                                choices = sort(unique(drug_deaths$drug_name)),
                                                                selected = "All drug-related deaths")
                                             )

                                         ),




                                         leafletOutput("drug_map", height = 600)


                                  ),

                                  column(width = 6,

                                         box(width = NULL, solidHeader = TRUE, background = "purple",
                                             column(width = 6, align = "center",
                                                    selectInput("drug_plot_area",
                                                                label = "Select Area:",
                                                                choices = c(unique(drug_deaths$council_area)))
                                             ),
                                             column(width = 6, align = "center",
                                                    selectInput("drug_plot_name",
                                                                label = "Select Drug:",
                                                                choices = sort(unique(drug_deaths$drug_name)),
                                                                selected = "All drug-related deaths")
                                             )

                                         ),

                                         plotlyOutput("drug_plot", height = 600, reportTheme = TRUE)

                                  )


                                )),


                                tabItem(tabName = "alcohol_deaths",
                                fluidRow(
                                    column(width = 6,
                                         box(width = NULL, solidHeader = TRUE, background = "green",
                                             column(width = 12, align = "center",
                                                    selectInput("year_input",
                                                         label = "Year:",
                                                         choices = c("All",
                                                                     sort(unique(alcohol_area$year_of_death))),
                                                         selected = "All",
                                                         width = "50%"))),



                                                leafletOutput("alcohol_map", height = 550)


                                  ),




                                  column(width = 6, align = "center",
                                         fluidRow(
                                         box(width = 12, solidHeader = TRUE, background = "green",
                                             column(width = 6,
                                                    selectInput("gender_input",
                                                                label = "Gender:",
                                                                choices = c("All",
                                                                            sort(unique(alcohol_deaths$gender))),
                                                                selected = "All")),
                                             column(width = 6,
                                                    selectInput("age_input",
                                                                label = "Age Group:",
                                                                choices = c("All",
                                                                            unique(alcohol_deaths$age_group)),
                                                                selected = "All")))),
                                         fluidRow(
                                         plotlyOutput("alcohol_plot", width = "95%", height = 550)
                                         )


                                  )

                                )
                        )
                      )
                    )
)
