

ui <- dashboardPage(skin = "black",
                    
                    # ShinyDashboard tabs
                    dashboardHeader(title = "Health in Scotland - The Drug Crisis"), 
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Life Expectancy", tabName = "life_expectancy"),
                        menuItem("Drug Deaths", tabName = "drug_deaths"),
                        menuItem("Alcohol Deaths", tabName = "alcohol_deaths")
                      )
                    ),
                    dashboardBody(
                      tabItems(
                        # LIFE EXPECTANCY PANEL ---------------------------------------
                        tabItem(tabName = "life_expectancy",
                                tabsetPanel(
                                  tabPanel("By Area",
                                           fluidRow(
                                             column(width = 6,
                                                    
                                                    box(width = NULL, solidHeader = TRUE, background = "blue",  
                                                        
                                                        column(width = 6, align = "center",
                                                               
                                                               selectInput("year_input",
                                                                           label = "Year Group",
                                                                           choices = c("All (average)" = "All",
                                                                                       unique(life_expectancy_data$date_code)),
                                                                           selected = "All (average)")
                                                               
                                                        ),
                                                        
                                                        
                                                        
                                                        column(width = 6, align = "center",
                                                               
                                                               selectInput("gender_input",
                                                                           label = "Gender",
                                                                           choices = c("All (average)" = "All",
                                                                                       unique(life_expectancy_data$gender)),
                                                                           selected = "All (average)")
                                                               
                                                        )
                                                    ),
                                                    leafletOutput("life_exp_map", height = 600)
                                                    
                                             ),
                                             
                                             
                                             
                                             
                                             
                                             
                                             
                                             column(width = 6, align = "center",
                                                    
                                                    box(width = NULL, solidHeader = TRUE, background = "blue", 
                                                        
                                                        column(width = 6, offset = 3, align = "center",
                                                               
                                                               selectInput("area_input",
                                                                           label = "Council Area",
                                                                           choices = c("All (average)" = "All",
                                                                                       unique(life_expectancy_data$local_authority)),
                                                                           selected = "All (average)")
                                                        )
                                                    ),
                                                    plotlyOutput("life_expectancy_plot", height = 600)
                                             )
                                             
                                             
                                             
                                           ),
                                           
                                           
                                  ),
                                  
                                  
                                  tabPanel("All Areas",
                                           
                                           fluidRow(
                                             column(width = 12, offset = 4,
                                                    box(width = 4, solidHeader = TRUE, background = "blue", 
                                                        column(width = 8, offset = 2, align = "center",
                                                               selectInput("all_year_input",
                                                                           label = "Year Group",
                                                                           choices = c("All Years (average)" = "All Years (average)",
                                                                                       unique(life_expectancy_data$date_code)),
                                                                           selected = "All Years (average)")
                                                        ),
                                                    ),
                                             ),
                                             
                                             fluidRow(
                                                    column(width = 12,
                                                    plotlyOutput("all_life_expectancy_plot", height = 600)
                                                    )
                                             )
                                           )
                                  )
                                )
                        )
                      )
                    )
                    
)

