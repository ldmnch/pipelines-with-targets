# Load packages required to define the pipeline:
library(targets)

tar_option_set(
  packages = c("tidyverse", "tidymodels") ,
  envir = suppressWarnings(suppressMessages(globalenv()))
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

# Replace the target list below with your own:
list(
  tar_target(
    name = data,
    command = iris
  ),
  tar_target(name = histogram, 
             command = plot_histogram(data)),
  tar_target(
    name = train_test_data,
    command = split_train_test_data(data)
  ),
  tar_target(
    name = fitted_model,
    command = build_and_fit_model(train_test_data[[1]])
  ),
  tar_target(
    name = predicted_data,
    command = predict_model_fit(fitted_model, train_test_data[[2]])
  ),
  tar_target(
    name = evaluation_metrics,
    command = model_eval_metrics(predicted_data))

  )
