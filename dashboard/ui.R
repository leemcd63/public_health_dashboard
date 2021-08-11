
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
                        tabItem(tabName = "overview"),
                        tabItem(tabName = "drug_deaths"),
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
