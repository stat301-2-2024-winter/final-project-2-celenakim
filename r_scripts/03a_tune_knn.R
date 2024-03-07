# Final Project 2 ----
# Define and fit knn a with kitchen sink recipe 1

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("data_splits/allies_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/recipe1_kitchen_sink.rda"))

# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

set.seed(301)
# model specifications ----
knn_a_spec <- 
  nearest_neighbor(mode = "regression",
                   neighbors = tune()) |> 
  set_engine("kknn")

# define workflows ----
knn_a_wflow <-
  workflow() |> 
  add_model(knn_a_spec) |> 
  add_recipe(recipe1_kitchen_sink)

# hyperparameter tuning values ----

# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(knn_a_spec)

# change hyperparameter ranges
knn_a_params <- extract_parameter_set_dials(knn_a_spec) |> 
  # N:= maximum number of random predictor columns we want to try 
  # should be less than the number of available columns
  update(neighbors = neighbors(c(1, 30))) 

# build tuning grid
knn_a_grid <- grid_regular(knn_a_params, levels = 5)

# fit workflows/models ----
tuned_knn_a <- tune_grid(knn_a_wflow,
                       allies_folds,
                       grid = knn_a_grid,
                       control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_knn_a, file = here("results/tuned_knn_a.rda"))
load(here("results/tuned_knn_a.rda"))

### hyperparameter tuning values --------------------------------------------------------

# build tuning grid
knn_a_grid <- grid_regular(knn_a_params, levels = 5)


# VISUAL INSPECTION OF TUNING RESULTS
autoplot(tuned_knn_a, metric = "rmse")

# SELECTING BEST RMSE
select_best(tuned_knn_a, "rmse")

knn_a_model_result <- as_workflow_set(
  knn = tuned_knn_a)

best_knn_a <- knn_a_model_result |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id, 
         `RMSE` = mean, 
         `Std Error` = std_err, 
         `Num Models` = n) |> 
  knitr::kable(digits = c(NA, 3, 4, 0))

best_knn_a
save(knn_a_params, knn_a_grid, knn_a_model_result, best_knn_a, file = here("results/best_knn_a.rda"))


load(here("results/best_knn_a.rda"))

