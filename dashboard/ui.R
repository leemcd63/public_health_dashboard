

ui <- dashboardPage(skin = "black",
                    
                    # ShinyDashboard tabs
                    dashboardHeader(title = "Health in Scotland - The Drug Crisis"), 
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Scotland Health Overview", tabName = "life_expectancy"),
                        menuItem("Drug Deaths", tabName = "drug_deaths"),
                        menuItem("Alcohol Deaths", tabName = "alcohol_deaths")
                      )
                    ),
                    dashboardBody(
                      tabItems(
                        # OVERVIEW PANEL ---------------------------------------
                        tabItem(tabName = "life_expectancy",
                        fluidRow(align = "center",
                                 column(width = 6, align= "center", background = "blue",
                                        box(width = NULL, solidHeader = TRUE, background = "green",            
                                            
                                            selectInput("year_input",
                                                        label = "Year Group",
                                                        choices = sort(unique(life_expectancy_data_2$date_code)),
                                                        selected = "2017-2019"),
                                            
                                            
                                            radioButtons("gender_input",
                                                         label = "Gender",
                                                         choices = c(sort(unique(life_expectancy_data_2$gender))),
                                                         selected = "Male")
                                        )
                                        
                                 )
                        ),
                        
                        
                        
                        fluidRow(
                          column(width = 6,
                                 tabsetPanel(
                                   
                                   tabPanel("Map",
                                            leafletOutput("life_exp_map")),
                                   
                                   tabPanel("Graph",
                                            plotlyOutput("life_expectancy_plot", height = 600))
                                 )
                          )
                        )
                      )
                    )
))
