

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
                        tabItem(tabName = "overview"),
                        tabItem(tabName = "drug_deaths"),
                              tabItem(tabName = "alcohol_deaths",
                                fluidRow(
                                  column(width = 2, align = "center",
                                         box(width = NULL, solidHeader = TRUE, background = "blue",
                                             selectInput("gender_input",
                                                         label = "Gender:",
                                                         choices = c("All", 
                                                                     sort(unique(alcohol_deaths$gender))),
                                                         selected = "All"),
                                             
                                             selectInput("age_input",
                                                         label = "Age Group:",
                                                         choices = c("All", 
                                                                     sort(unique(alcohol_deaths$age_group))),
                                                         selected = "All"),
                                             
                                             selectInput("year_input",
                                                         label = "Year:",
                                                         choices = c("All",
                                                                     sort(unique(alcohol_area$year_of_death))))
                                             
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