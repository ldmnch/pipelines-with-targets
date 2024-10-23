library(tidymodels)
library(tidyverse)
library(discrim)

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

split_train_test_data <- function(data){
  
  set.seed(123) 
  split <- initial_split(data, prop = 0.8, strata = Species)
  train <- training(split)
  test  <- testing(split)
  
  return(list(train = train, test = test))
  
}

build_and_fit_model <- function(data_train,
                                model = naive_Bayes() %>%
                                  set_engine("naivebayes") %>%
                                  set_mode("classification")){
  
  recipe <- recipe(Species ~ ., data = data_train)
  
  workflow <- workflow() %>%
    add_model(model) %>%
    add_recipe(recipe)
  
  fit <- workflow %>%
    fit(data = data_train)
  
  return(fit)
  
}

predict_model_fit <- function(model_fit, data_test){
  
  model_predictions <- predict(model_fit, data_test) %>%
    bind_cols(data_test)
  
  return(model_predictions)
  
}

model_eval_metrics <- function(model_predictions){
  metrics <- model_predictions %>%
    metrics(truth = Species, estimate = .pred_class)
  
  conf_mat <- model_predictions %>%
    conf_mat(truth = Species, estimate = .pred_class)
  
  return(list(metrics = metrics, conf_matrix = conf_mat))
  
}

