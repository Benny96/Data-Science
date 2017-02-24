library(shiny)
shinyUI(fluidPage(
        titlePanel("Study about the 'quakes' library (Fiji Earthquakes)"),
        sidebarLayout(
                sidebarPanel(
                        sliderInput("sliderQuake", "Select the quake magnitude", 4, 6.5, value = 5),
                        checkboxInput("showModel1", "Show/Hide Fitted Model", value = TRUE),
                        checkboxInput("showModel2", "Show/Hide Selection Fitted Model", value = TRUE),
                        submitButton("Submit")
                ),
                mainPanel(
                        tabsetPanel(type = "tabs", 
                                    tabPanel("Documentation", br(), 
                                             h5("On this small shiny app, we will analyse briefly the
                                                            'quakes' dataset, which comes by default when installing R 
                                                            and which was gathered by the Dept. of Geophysics of Harvard University."),
                                             h5("Basically, we will see the data in boxplots, so we can recognize 
                                                            few event clusters."),
                                             h5("Then, we will fit a linear model to extract how 
                                                            many stations would report a quake considering that a determined 
                                                            intensity quake happened. This sidebar will be handy to observe
                                                            the values' evolution."),
                                             h5("The sidebar has 2 options to check:"),
                                             h5("The first one makes the red linear model visible, which displays the linear model considering every observation."), 
                                             h5("However, the second one displays a blue linear model which is formed depending on our selection. To
                                                select the data, drag an area on the plot and then click on 'Submit'.")),
                                    tabPanel("Boxplot", br(), plotOutput("plot2"),
                                             h5("As we would logically expect, there is a high correlation between the magnitude
                                                of quakes and the number of stations reporting them."),
                                             h5("However, we can also assert that intermediate 
                                                magnitude values (such as 5, 5.1 or even 5.4) have a bigger variance than the rest of the
                                                clusters, since sometimes, few stations reported them (approx. 20) and some others, quite
                                                a lot of them (almost 100!).")
                                             ),
                                    tabPanel("Prediction", br(), plotOutput("plot1", brush = brushOpts(id = "brush1")),
                                                            h3("Predicted no. of stations (Default Model):"),
                                                            textOutput("pred1"),
                                                            h3("Predicted no. of stations (Custom Model):"),
                                                            textOutput("pred2"))
                                                )
            
        )
)))

