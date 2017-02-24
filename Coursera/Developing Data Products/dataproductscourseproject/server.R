library(shiny)
shinyServer(function(input, output) 
        {
        model1 <- lm(stations ~ mag, data = quakes)
        reactivemodel <- reactive({
                brushed_data <- brushedPoints(quakes, input$brush1,
                                              xvar = "mag", yvar = "stations")
                if(nrow(brushed_data) < 2){
                        return(NULL)
                }
                lm(stations ~ mag, data = brushed_data)
        })
        model1pred <- reactive({
                magInput <- input$sliderQuake
                predict(model1, newdata = data.frame(mag = magInput))
        })
        reactivemodelpred <- reactive({
                magInput <- input$sliderQuake
                if(!is.null(reactivemodel())){
                        predict(reactivemodel(), newdata = data.frame(mag = magInput))   
                }
        })
        output$plot1 <- renderPlot({
                magInput <- input$sliderQuake
                plot(quakes$mag, quakes$stations, xlab = "Intensity", 
                     ylab = "No. of Stations", bty = "n", pch = 16,
                     xlim = c(4, 6.5), ylim = c(0, 140))
                if(input$showModel1)
                {
                        abline(model1, col = "red", lwd = 2)
                }
                if(input$showModel2 & !is.null(reactivemodel())){
                        abline(reactivemodel(), col = "blue", lwd = 2)
                        points(magInput, reactivemodelpred(), col = "blue", pch = 16, cex = 2)
                }
                legend(25, 250, c("Model 1 Prediction", "Model 2 Prediction"), pch = 16, 
                       col = c("red", "blue"), bty = "n", cex = 1.2)
                points(magInput, model1pred(), col = "red", pch = 16, cex = 2)
        })
        output$pred1 <- renderText({
                model1pred()
        })
        output$pred2 <- renderText({
                if(!is.null(reactivemodelpred())){
                        reactivemodelpred()
                }
                else
                {
                        "Data hasn't been selected yet to be displayed."
                }
        })
        output$plot2 <- renderPlot({
                boxplot(stations~mag, data = quakes, main = "Clusters",
                        xlab = "Magnitude of quakes", ylab = "Number of
                        stations reporting")
        })
})
