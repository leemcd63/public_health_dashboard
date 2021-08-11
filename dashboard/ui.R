

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
                                  
                                  
                                ),
                                
                                
                                tabItem(tabName = "alcohol_deaths",
                                       
                                )
                        )
                      )
                    )
)