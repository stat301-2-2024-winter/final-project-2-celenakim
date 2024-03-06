# Final Project 2 ----
# Define and fit knn b with complex recipe 3

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
load(here("recipes/recipe3_transformed_interactions.rda"))


# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

set.seed(301)
# model specifications ----
knn_b_spec <- 
  nearest_neighbor(mode = "regression",
                   neighbors = tune()) |> 
  set_engine("kknn")

# define workflows ----
knn_b_wflow <-
  workflow() |> 
  add_model(knn_b_spec) |> 
  add_recipe(recipe3_transformed_interactions)

# hyperparameter tuning values ----

# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(knn_b_spec)

# change hyperparameter ranges
knn_b_params <- extract_parameter_set_dials(knn_b_spec) |> 
  # N:= maximum number of random predictor columns we want to try 
  # should be less than the number of available columns
  update(neighbors = neighbors(c(1, 10))) 

# build tuning grid
knn_b_grid <- grid_regular(knn_b_params, levels = 5)

# fit workflows/models ----
tuned_knn_b <- tune_grid(knn_b_wflow,
                       allies_folds,
                       grid = knn_b_grid,
                       control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(knn_b_spec, knn_b_wflow, knn_b_params, knn_b_grid, tuned_knn_b, file = here("results/tuned_knn_b.rda"))
load(here("results/tuned_knn_b.rda"))

### hyperparameter tuning values --------------------------------------------------------

# build tuning grid
knn_b_grid <- grid_regular(knn_b_params, levels = 5)


# VISUAL INSPECTION OF TUNING RESULTS
autoplot(tuned_knn_b, metric = "rmse")

# SELECTING BEST RMSE
select_best(tuned_knn_b, "rmse")

knn_b_model_result <- as_workflow_set(
  knn = tuned_knn_b)

best_knn_b <- knn_b_model_result |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id, 
         `RMSE` = mean, 
         `Std Error` = std_err, 
         `Num Models` = n) |> 
  knitr::kable(digits = c(NA, 3, 4, 0))

best_knn_b
save(knn_b_model_result, best_knn_b, file = here("results/best_knn_b.rda"))


load(here("results/best_knn_b.rda"))

