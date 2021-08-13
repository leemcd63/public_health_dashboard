
ui <- dashboardPage(skin = "black",
                    # ShinyDashboard tabs
                    dashboardHeader(title = "Health in Scotland"),
                    dashboardSidebar(
                      sidebarMenu(
                        
                        menuItem("Scotland Health Overview", tabName = "overview"),
                        menuItem("Life Expectancy", tabName = "life_expectancy"),
                        menuItem("Drug Deaths", tabName = "drug_deaths"),
                        menuItem("Alcohol Deaths", tabName = "alcohol_deaths")
                      )
                    ),
                    
                    dashboardBody(
                      tabItems(
                        # OVERVIEW PANEL ---------------------------------------
                        tabItem("overview",
                                fluidPage(
                                  fluidRow(
                                    column(width = 10, offset = 1, align = "center",
                                           tags$b("Health in Scotland Overview", style = "font-size: 40px"),
                                           br(), br(),
                                           p("Over recent years, Scotland has seen a continuous increase in deaths attributed 
                                             to substance abuse.", 
                                             br(), br(), 
                                             "This dashboard is designed to give an at-a-glance view of KPIs regarding life expectancy,
                                             drug related deaths and alcohol related deaths. The aim is to provide insights of how 
                                             these differ over Time, Location and demographics such as Age and Gender.", 
                                             br(), br(), 
                                             tags$b("Please use the navigation panel on the left side of the page to view different pages of the dashboard."),
                                             br(), br(), 
                                             "All data is from 2009 to 2019, which has been sourced from the ", 
                                             tags$a(tags$b(href="https://statistics.gov.scot/home", "Scottish Government Statistics Website")),
                                             " and the ", 
                                             tags$a(tags$b(href="https://www.nrscotland.gov.uk", "National Records of Scotland Website. ")),
                                             br(), br(),
                                             style = "font-family: 'arial'; font-size: 12pt;")
                                    )
                                  ),
                                  fluidRow(
                                    column(width = 4, offset = 4, align = "center",
                                           br(),
                                           box(width = NULL, solidHeader = TRUE, status = "warning",
                                               title = tags$b("Health in Scotland 2019", style = "font-size: 30px"),
                                               tags$b("Key Performance Indicators", style = "font-size: 20px")
                                           )
                                    )
                                  ),
                                  
                                  fluidRow(
                                    valueBoxOutput("avg_m"),
                                    valueBoxOutput("avg_f"),
                                    valueBoxOutput("life_exp_area")
                                  ),
                                  fluidRow(
                                    valueBoxOutput("most_drug_death"),
                                    valueBoxOutput("total_drug_death"),
                                    valueBoxOutput("worst_drug_area")
                                  ),
                                  
                                  fluidRow(
                                    valueBoxOutput("alcohol_age"),
                                    valueBoxOutput("total_alc_death"),
                                    valueBoxOutput("worst_alcohol_area")
                                  ),
                                  
                                  fluidRow(
                                    column(width = 10, offset = 1, align = "center",
                                           p(br(), br(),
                                             "This dashboard has been built using ",
                                             tags$a(tags$b(href="https://shiny.rstudio.com", "Shiny for RStudio ")),
                                             "by ", tags$b("Tom Davie, Melanie Jayasinghe and Lee McDonald of CodeClan Cohort DE9"))
                                    )
                                    
                                  )
                                  
                                )
                        ),
                        # LIFE EXPECTANCY PANEL ---------------------------------------
                        tabItem(tabName = "life_expectancy",
                                
                                fluidRow(
                                  column(width = 12,
                                         tags$b("Life Expectancy in Scotland", style = "font-size: 30px"),
                                         
                                  )
                                ),
                                
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
                                  
                                  
                                  tabPanel("Overview",
                                           
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
                        ),
                        
                        
                        # DRUGS PANEL -------------------------------------------------------------
                        tabItem(tabName = "drug_deaths",
                                
                                fluidRow(
                                  column(width = 10,
                                         tags$b("Drug-related Deaths in Scotland", style = "font-size: 30px"),
                                         br(), br(), 
                                  )
                                ),
                                
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
                        
                        # ALCOHOL PANEL -------------------------------------------------------------
                        
                        tabItem(tabName = "alcohol_deaths",
                                fluidRow(
                                  column(width = 10,
                                         tags$b("Alcohol-specific Deaths in Scotland", style = "font-size: 30px"),
                                         br(), br(), 
                                  )
                                ),
                                fluidRow(
                                  column(width = 6,
                                         box(width = NULL, solidHeader = TRUE, background = "green",
                                             column(width = 12, align = "center",
                                                    selectInput("alc_year_input",
                                                                label = "Year:",
                                                                choices = c("All",
                                                                            sort(unique(alcohol_area$year_of_death))),
                                                                selected = "All",
                                                                width = "50%"))),
                                         
                                         
                                         
                                         leafletOutput("alcohol_map", height = 600)
                                         
                                         
                                  ),
                                  
                                  
                                  column(width = 6, align = "center",
                                         fluidRow(
                                           box(width = 12, solidHeader = TRUE, background = "green",
                                               column(width = 6,
                                                      selectInput("alc_gender_input",
                                                                  label = "Gender:",
                                                                  choices = c("All",
                                                                              unique(alcohol_deaths$gender)),
                                                                  selected = "All")),
                                               column(width = 6,
                                                      selectInput("age_input",
                                                                  label = "Age Group:",
                                                                  choices = c("All",
                                                                              unique(alcohol_deaths$age_group)),
                                                                  selected = "All")))),
                                         fluidRow(
                                           plotlyOutput("alcohol_plot",  height = 600)
                                         )
                                  )
                                )
                        )
                      )
                    )
)



