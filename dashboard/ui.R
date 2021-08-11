  
  ui <- dashboardPage(skin = "black",
  
                    # ShinyDashboard tabs
                    dashboardHeader(title = "Health in Scotland - The Drug Crisis"),
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
                                          
                                        )
                                )
                        )
                    )
  
  
                       
