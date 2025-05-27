library(shiny)
library(shinythemes)
library(shinycssloaders)

# Load pre-trained models
lm_model <- readRDS("model1.rds")
rf_model <- readRDS("model2.rds")

# Function to get AQI category
aqi_category <- function(aqi){
  if (aqi <= 50) return(list(Category = "Good", Message = "Air quality is satisfactory, and air pollution poses little or no risk."))
  else if (aqi <= 100) return(list(Category = "Satisfactory", Message = "Air quality is acceptable; some pollutants may be a concern for sensitive individuals."))
  else if (aqi <= 200) return(list(Category = "Moderate", Message = "Members of sensitive groups may experience health effects."))
  else if (aqi <= 300) return(list(Category = "Poor", Message = "Everyone may begin to experience health effects; sensitive groups may experience more serious effects."))
  else if (aqi <= 400) return(list(Category = "Very Poor", Message = "Health warnings of emergency conditions."))
  else return(list(Category = "Severe", Message = "Health alert: everyone may experience more serious health effects."))
}

# UI
ui <- fluidPage(
  theme = shinytheme("united"),
  headerPanel("Air Quality Insights"),
  
  sidebarPanel(
    HTML("<h3>INPUT PARAMETERS</h3>"),
    
    sliderInput("pm25", "PM2.5", min = 0, max = 500, value = 150),
    sliderInput("co", "CO", min = 0, max = 49, value = 20),
    sliderInput("no2", "NO2", min = 0, max = 91, value = 40),
    sliderInput("ozone", "OZONE", min = 0, max = 235, value = 100),
    
    selectInput("modelChoice", "Choose Model:",
                choices = c("linear_regression_model", "random_forest_model"),
                selected = "linear_regression_model"),
    
    actionButton("Submitbutton", "Submit", class = "btn btn-primary")
  ),
  
  mainPanel(
    tags$label(h2('STATUS')),
    verbatimTextOutput('Contents'),
    
    #Show selected contents
    tableOutput('tabledata'),
    
    # Forecast 
    withSpinner(uiOutput('forecast'), color="#0dc5c1"),
    
    # Error message
    div(textOutput('error_msg'),style = "color: red; margin-top: 10px;")
  )
)

# Server
server <- function(input, output, session) {
  
  output$Contents <- renderText({
    if (input$Submitbutton > 0) "Calculation completed..." 
    else "Server is ready for calculation."
  })
  
  observeEvent(input$Submitbutton, {
    
      # Use tryCatch to catch any errors during prediction
      tryCatch({
        df <- data.frame(
          PM2.5.AQI.Value = input$pm25,
          CO.AQI.Value    = input$co,
          NO2.AQI.Value   = input$no2,
          Ozone.AQI.Value = input$ozone
        )
        
        # Choose model based on user input
        chosen_model <- if (input$modelChoice == "linear_regression_model") lm_model else rf_model
        pred_val <- predict(chosen_model, newdata = df)
        
        # Get AQI category info
        category_info <- aqi_category(pred_val)
        
        # Forecast rendering with predictions
        output$forecast <- renderUI({
          HTML(paste("<strong>Predicted AQI:</strong> ", round(pred_val, 1), "<br><br>",
                     "<strong>Category:</strong> ", category_info$Category, "<br><br>",
                     "<strong>Health Message:</strong> ", category_info$Message))
        })
        
        # Display table of inputs and results
        output$tabledata <- renderTable({
          data.frame(
            PM2.5 = input$pm25,
            CO = input$co,
            NO2 = input$no2,
            Ozone = input$ozone,
            Predicted_AQI = round(pred_val, 1),
            Air_Quality = category_info$Category
          )
        })
        
      }, error = function(e) {
        # Display error in case something goes wrong during prediction
        output$error_msg <- renderText(paste("Error in prediction: ", e$message))
      })#End of tryCatch box
  })
}

# Run the app
shinyApp(ui = ui, server = server)
