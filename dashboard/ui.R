

ui <- dashboardPage(skin = "blue",
                    
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
                                fluidRow(align = "center",
                                         column(width = 2, align = "center",
                                                box(width = NULL, solidHeader = TRUE, background = "green",            
                                                    selectInput("year_input",
                                                                label = "Year:",
                                                                min = 2012,
                                                                max = 2019,
                                                                value = c(2012, 2019)
                                                    ),
                                                    radioButtons("gender_input",
                                                                 label = "Gender",
                                                                 choices = list("All" = male + female,
                                                                                "Male" = male,
                                                                                "Female" = female),
                                                                 selected = male + female),
                                                    selectInput("age_input",
                                                                label = "Age",
                                                                choices = list("0 years" = "0 years",
                                                                               "1-4 years" = "1-4 years",
                                                                               "2-9 years" = "2-9 years",
                                                                               "10-14 years" = "10-14 years",
                                                                               "14-19 years" = "14-19 years",
                                                                               "20-24 years" = "20-24 years",
                                                                               "25-29 years" = "25-29 years",
                                                                               "30-34 years" = "30-34 years",
                                                                               "35-39 years" = "35-39 years",
                                                                               "40-44 years" = "40-44 years",
                                                                               "45-49 years" = "45-49 years",
                                                                               "50-54 years" = "50-54 years",
                                                                               "55-59 years" = "55-59 years",
                                                                               "60-64 years" = "60-64 years",
                                                                               "65-69 years" = "65-69 years",
                                                                               "70-74 years" = "70-74 years",
                                                                               "75-79 years" = "75-79 years",
                                                                               "80-84 years" = "80-84 years",
                                                                               "85-89 years" = "85-89 years",
                                                                               "90 years" = "90 years")))
                                         )),
                                fluidRow(
                                  column(width = 10,
                                         tabsetPanel(
                                           
                                           tabPanel("Map",
                                                    leafletOutput("life_expectancy_map")
                                           ),
                                           
                                           tabPanel("Graph",
                                                    plotOutput("life_expectancy_plot", height = 500)
                                           )
                                         )
                                  )
                                )
                        )
                        
                        
                        # DRUGS PANEL -------------------------------------------------------------
                        tabItem(tabName = "drug_input",
                                fluidRow(
                                  column(width = 2, align = "center",
                                         box(width = NULL, solidHeader = TRUE, background = "green",
                                             selectInput("gender_input",
                                                         label = "Gender:",
                                                         choices = c("All", 
                                                                     sort(unique(SOURCE OBJECT HERE$gender))),
                                                         selected = "All"),
                                             
                                             selectInput("age_input",
                                                         label = "Age:",
                                                         choices = c("All", 
                                                                     sort(unique(SOURCE OBJECT HERE$age))),
                                                         selected = "All"),
                                             
                                             checkboxGroupInput("drug_input_select",
                                                                label = "Select Drug:"),
                                             
                                             
                                             actionButton("drug_input_all", "Select/Deselect All")
                                         )
                                  )
                                ),
                                
                                column(width = 10,
                                       tabsetPanel(
                                         
                                         tabPanel("Map",
                                                  leafletOutput("drug_map")
                                         ),
                                         
                                         tabPanel("Graph",
                                                  plotOutput("drug_plot", height = 500) 
                                         )
                                       )
                                )
                        )
                        
                        # ALCOHOL PANEL -------------------------------------------------------------
                        
                        tabItem(tabName = "alcohol_input",
                                fluidRow(
                                  column(width = 2, align = "center",
                                         box(width = NULL, solidHeader = TRUE, background = "green",
                                             selectInput("gender_input",
                                                         label = "Gender:",
                                                         choices = c("All", 
                                                                     sort(unique(SOURCE OBJECT HERE$gender))),
                                                         selected = "All"),
                                             
                                             selectInput("age_input",
                                                         label = "Age:",
                                                         choices = c("All", 
                                                                     sort(unique(SOURCE OBJECT HERE$age))),
                                                         selected = "All"),
                                             
                                             checkboxGroupInput("alcohol_input_select",
                                                                label = "Select Drug:"),
                                             
                                             
                                             actionButton("alcohol_input_all", "Select/Deselect All")
                                         )
                                  )
                                ),
                                
                                column(width = 10,
                                       tabsetPanel(
                                         
                                         tabPanel("Map",
                                                  leafletOutput("alcohol_map")
                                         ),
                                         
                                         tabPanel("Graph",
                                                  plotOutput("alcohol_plot", height = 500) 
                                         )
                                       )
                                )
                        )
                      )
                    )
)