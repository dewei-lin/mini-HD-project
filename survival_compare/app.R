library(shiny)
library(plotly)

# Define the first function (Langbehn 2004)
func1 <- function(age, CAG) {
  numerator <- pi * (-21.54 - exp(9.56 - 0.146 * CAG) + age)
  denominator <- sqrt(3) * sqrt(35.55 + exp(17.72 - 0.327 * CAG))
  exp_term <- numerator / denominator
  result <- (1 + exp(exp_term))^(-1)
  return(result)
}

# Define the second function (CAP)
func2 <- function(Age, Age0, CAG) {
  t <- Age - Age0  # Adjusted condition
  if (t < 1) return(NA)  # Return NA if t < 1
  CAP <- Age0 * (CAG - 33.66)
  numerator <- log(t) - (4.4196 - 0.0065 * CAP)
  denominator <- exp(-0.8451)
  exp_term <- numerator / denominator
  result <- (1 + exp(exp_term))^(-1)
  if (result == 0) return(NA)  # Exclude zero values
  return(result)
}

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      .legend-container {
        margin-left: 20px;
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 5px;
        background: #f9f9f9;
        display: inline-block;
      }
      .legend-item {
        display: flex;
        align-items: center;
        margin-bottom: 5px;
      }
      .legend-item span {
        width: 20px;
        height: 20px;
        display: inline-block;
        margin-right: 10px;
      }
    "))
  ),
  fluidRow(
    column(3,
           h3("Display Options"),
           fluidRow(
             column(6, checkboxInput("show_func1", "Show Langbehn 2004", value = TRUE)),
             column(6, checkboxInput("show_func2", "Show CAP", value = TRUE))
           ),
           fluidRow(
             column(12,
                    radioButtons(
                      "cag_scale",
                      "CAG Scale:",
                      choices = list("Integer" = "integer", "Continuous" = "continuous"),
                      selected = "continuous",
                      inline = TRUE
                    )
             )
           ),
           fluidRow(
             column(12, sliderInput("Age0", "Age at Study Entry:", min = 18, max = 71, value = 30, step = 1)),
             
           ),
           actionButton("update", "Update Plot"),
           hr(),
           h4("Click Details"),
           verbatimTextOutput("click_info"),
           hr(),
           h4("Langbehn 2004 Formula"),
           withMathJax("
        $$ 
        S(Age, CAG) = \\left(1 + \\exp\\left(\\frac{
          \\pi \\cdot \\left[-21.54 - \\exp(9.56 - 0.146 \\cdot CAG) + Age \\right]
        }{
          \\sqrt{3} \\cdot \\sqrt{35.55 + \\exp(17.72 - 0.327 \\cdot CAG)}
        }\\right)\\right)^{-1}
        $$
      "),
           h4("CAP Formula"),
           withMathJax("
        $$ 
        S(Age, CAG, Age_0) = \\left(1 + \\exp\\left(\\frac{
          \\log(t) - \\left(4.4196 - 0.0065 \\cdot CAP\\right)
        }{
          \\exp(-0.8451)
        }\\right)\\right)^{-1} 
        $$

        where:

        $$ t = Age - Age_0 $$

        $$ CAP = Age_0 \\cdot (CAG - 33.66) $$
      "),
           hr(),
           h4("Information"),
           HTML("
        <div style='text-align: center;'>
          <table style='border: 1px solid black; border-collapse: collapse; margin: auto; width: 100%;'>
            <thead>
              <tr>
                <th style='border: 1px solid black; padding: 8px;'> </th>
                <th style='border: 1px solid black; padding: 8px;'>Langbehn 2004</th>
                <th style='border: 1px solid black; padding: 8px;'>CAP</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td style='border: 1px solid black; padding: 8px;'><b>CAG</b></td>
                <td style='border: 1px solid black; padding: 8px;'>41-56</td>
                <td style='border: 1px solid black; padding: 8px;'>36-61</td>
              </tr>
              <tr>
                <td style='border: 1px solid black; padding: 8px;'><b>AGE</b></td>
                <td style='border: 1px solid black; padding: 8px;'>36-61</td>
                <td style='border: 1px solid black; padding: 8px;'>&ge;19</td>
              </tr>
              <tr>
                <td style='border: 1px solid black; padding: 8px;'><b>AGE0</b></td>
                <td style='border: 1px solid black; padding: 8px;'> </td>
                <td style='border: 1px solid black; padding: 8px;'>&ge;18</td>
              </tr>
              <tr>
                <td style='border: 1px solid black; padding: 8px;'><b>t</b></td>
                <td style='border: 1px solid black; padding: 8px;'> </td>
                <td style='border: 1px solid black; padding: 8px;'>1-7</td>
              </tr>
            </tbody>
          </table>
        </div>
      "),
           hr()
    ),
    column(8.5,
           div(
             style = "margin-top: 100px; float:right",
             plotlyOutput("plot3d", height = "750px", width = "750px")
           )
    )
  )
)

server <- function(input, output) {
  
  # Reactive value for Age0
  Age0 <- reactiveVal(30)
  
  # Update Age0 when button is clicked
  observeEvent(input$update, {
    Age0(input$Age0)
  })
  
  # Generate 3D plot
  output$plot3d <- renderPlotly({
    # Define sequences dynamically based on user input
    if (input$cag_scale == "integer") {
      CAG_seq_func1 <- 41:56  # Integer values for Langbehn 2004
      CAG_seq_func2 <- 36:61  # Integer values for CAP
    } else {
      CAG_seq_func1 <- seq(41, 56, length.out = 320)  # Continuous values for Langbehn 2004
      CAG_seq_func2 <- seq(36, 61, length.out = 320)  # Continuous values for CAP
    }
    
    # Age sequences remain the same
    age_seq_func1 <- seq(7, 71, length.out = 320)
    age_seq_func2 <- seq(19, 78, length.out = 320)
    Age0_val <- Age0()
    
    # Compute Z values for Langbehn 2004
    grid_func1 <- expand.grid(Age = age_seq_func1, CAG = CAG_seq_func1)
    grid_func1$Z <- mapply(func1, grid_func1$Age, grid_func1$CAG)
    
    # Compute Z values for CAP
    grid_func2 <- expand.grid(Age = age_seq_func2, CAG = CAG_seq_func2)
    grid_func2$Z <- mapply(function(Age, CAG) func2(Age, Age0_val, CAG), grid_func2$Age, grid_func2$CAG)
    
    # Create the plot
    p <- plot_ly()
    
    if (input$show_func1) {
      p <- p %>%
        add_markers(
          x = grid_func1$Age, 
          y = grid_func1$CAG, 
          z = grid_func1$Z,
          name = "Langbehn 2004",  # Name for trace 0
          marker = list(size = 4, color = "#0072B2"),
          hovertemplate = "AGE: %{x}<br>CAG: %{y}<br>Survival Probability: %{z:.4f}<extra>Langbehn 2004</extra>"
        )
    }
    
    if (input$show_func2) {
      p <- p %>%
        add_markers(
          x = grid_func2$Age, 
          y = grid_func2$CAG, 
          z = grid_func2$Z,
          name = "CAP",  # Name for trace 1
          marker = list(size = 4, color = "#E69F00"),
          hovertemplate = "AGE: %{x}<br>CAG: %{y}<br>Survival Probability: %{z:.4f}<extra>CAP</extra>"
        )
    }
    
    
    p %>% layout(
      title = "Langbehn 2004 vs CAP",
      scene = list(
        xaxis = list(title = "Age"),
        yaxis = list(title = "CAG"),
        zaxis = list(title = "Survival Probability")
      )
    )
  })
  
  output$click_info <- renderText({
    click_data <- event_data("plotly_click")
    
    # Return instructions if no data is clicked
    if (is.null(click_data)) {
      return("Click on the plot to compare the two models.")
    }
    
    # Extract clicked data
    age <- click_data$x
    cag <- click_data$y
    Age0_val <- Age0()
    
    # Check if CAG is in valid ranges
    survival_prob_func1 <- if (cag >= 41 & cag <= 56 & age >= 7 & age <=71) {
      func1(age, cag)
    } else {
      NA
    }
    
    survival_prob_func2 <- if (cag >= 36 & cag <= 61 & age-Age0_val >= 0 & age-Age0_val <= 7) {
      func2(age, Age0_val, cag)
    } else {
      NA
    }
    
    # Format the output message
    paste0(
      "AGE = ", round(age, 2), "\n",
      "CAG = ", round(cag, 2), "\n",
      "AGE0 = ", Age0_val, "\n",
      "Langbehn 2004 = ", ifelse(is.na(survival_prob_func1), "NA", round(survival_prob_func1, 4)), "\n",
      "CAP = ", ifelse(is.na(survival_prob_func2), "NA", round(survival_prob_func2, 4))
    )
  })
}

shinyApp(ui = ui, server = server)
