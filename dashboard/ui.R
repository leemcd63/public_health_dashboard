
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
                                    h1("Scotland Health Overview "),
                                    p("Our country has an escalating problem with drugs deaths. 
                                            In this dashboard we take a look at recent trends in drug
                                            and alcohol deaths across the country.",
                                      style = "font-family: 'arial'; font-si16pt")                                ),
                                  
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
                                  ))
                                
                        ),
                        
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
                        
                        # ALCOHOL PANEL -------------------------------------------------------------
                        
                        tabItem(tabName = "alcohol_deaths",
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



