library(tidyverse)

summary_statistics <- function(data){
  summary_data <- data %>% 
    group_by(Species) %>% 
    summarise_all(mean)
  
  return(summary_data)
}

plot_histogram <- function(data){
  
  data_long <- data %>%
    pivot_longer(cols = -Species, names_to = "Variable", values_to = "Value")
  
  ggplot(data_long, aes(x = Value, fill = Species)) +
    geom_histogram(bins = 30, position = "identity", alpha = 0.7, color = "black") +
    facet_wrap(~ Variable, scales = "free") +
    labs(title = "Histograms of Iris Dataset Variables Colored by Species",
         x = "Value",
         y = "Count") +
    theme_minimal() +
    theme(legend.position = "top")
  
}
