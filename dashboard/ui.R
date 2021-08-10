

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
                                # fluidRow(align = "center",
                                #          column(width = 2, align = "center",
                                #                 box(width = NULL, solidHeader = TRUE, background = "green",            
                                #                     selectInput("year_input",
                                #                                 label = "Year:",
                                #                                 min = 2012,
                                #                                 max = 2019,
                                #                                 value = c(2012, 2019)
                                #                     ),
                                #                     radioButtons("gender_input",
                                #                                  label = "Gender",
                                #                                  choices = list("All" = male + female,
                                #                                                 "Male" = male,
                                #                                                 "Female" = female),
                                #                                  selected = male + female),
                                #                     selectInput("age_input",
                                #                                 label = "Age",
                                #                                 choices = list("0 years" = "0 years",
                                #                                                "1-4 years" = "1-4 years",
                                #                                                "2-9 years" = "2-9 years",
                                #                                                "10-14 years" = "10-14 years",
                                #                                                "14-19 years" = "14-19 years",
                                #                                                "20-24 years" = "20-24 years",
                                #                                                "25-29 years" = "25-29 years",
                                #                                                "30-34 years" = "30-34 years",
                                #                                                "35-39 years" = "35-39 years",
                                #                                                "40-44 years" = "40-44 years",
                                #                                                "45-49 years" = "45-49 years",
                                #                                                "50-54 years" = "50-54 years",
                                #                                                "55-59 years" = "55-59 years",
                                #                                                "60-64 years" = "60-64 years",
                                #                                                "65-69 years" = "65-69 years",
                                #                                                "70-74 years" = "70-74 years",
                                #                                                "75-79 years" = "75-79 years",
                                #                                                "80-84 years" = "80-84 years",
                                #                                                "85-89 years" = "85-89 years",
                                #                                                "90 years" = "90 years")))
                                #          )),
                                # fluidRow(
                                #   column(width = 10,
                                #          tabsetPanel(
                                #            
                                #            tabPanel("Map",
                                #                     leafletOutput("life_expectancy_map")
                                #            ),
                                #            
                                #            tabPanel("Graph",
                                #                     plotOutput("life_expectancy_plot", height = 500)
                                #            )
                                #          )
                                #   )
                                # )
                        ),
                        
                        
                        # DRUGS PANEL -------------------------------------------------------------
                        tabItem(tabName = "drug_deaths",
                                fluidRow(
                                  column(width = 6,
                                         box(width = NULL, solidHeader = TRUE, background = "blue",
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
                                  
                                  column(width = 6, align = "center",
                                         
                                         box(width = NULL, solidHeader = TRUE, background = "blue",
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
                                         
                                         plotlyOutput("drug_plot", height = 600)
                                         
                                  )
                                  
                                  
                                ),
                                
                                # ALCOHOL PANEL -------------------------------------------------------------
                                
                                tabItem(tabName = "alcohol_deaths",
                                        #         fluidRow(
                                        #           column(width = 2, align = "center",
                                        #                  box(width = NULL, solidHeader = TRUE, background = "green",
                                        #                      selectInput("gender_input",
                                        #                                  label = "Gender:",
                                        #                                  choices = c("All", 
                                        #                                              sort(unique(SOURCE OBJECT HERE$gender))),
                                        #                                  selected = "All"),
                                        #                      
                                        #                      selectInput("age_input",
                                        #                                  label = "Age:",
                                        #                                  choices = c("All", 
                                        #                                              sort(unique(SOURCE OBJECT HERE$age))),
                                        #                                  selected = "All"),
                                        #                      
                                        #                      checkboxGroupInput("alcohol_input_select",
                                        #                                         label = "Select Drug:"),
                                        #                      
                                        #                      
                                        #                      actionButton("alcohol_input_all", "Select/Deselect All")
                                        #                  )
                                        #           )
                                        #         ),
                                        #         
                                        #         column(width = 10,
                                        #                tabsetPanel(
                                        #                  
                                        #                  tabPanel("Map",
                                        #                           leafletOutput("alcohol_map")
                                        #                  ),
                                        #                  
                                        #                  tabPanel("Graph",
                                        #                           plotOutput("alcohol_plot", height = 500) 
                                        #                  )
                                        #                )
                                        #         )
                                )
                        )
                      )
                    )
)