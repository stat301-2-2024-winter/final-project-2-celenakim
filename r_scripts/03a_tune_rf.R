# Define and fit rf with kitchen sink recipe

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
load(here("recipes/recipe2_kitchen_sink_trees.rda"))


# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

set.seed(301)
# model specifications ----
rf_a_model <- rand_forest(mode = "regression",
                        trees = 1000,
                        min_n = tune(),  # what is the min num of observations needed in final node
                        mtry = tune()) |> 
  set_engine("ranger")

# define workflows ----
rf_a_wflow <- 
  workflow() |> 
  add_model(rf_a_model) |> 
  add_recipe(recipe2_kitchen_sink_trees)

# hyperparameter tuning values ----
rf_a_params <- extract_parameter_set_dials(rf_a_model) |> 
  update(mtry = mtry(range = c(1, 37)))

rf_a_grid <- grid_regular(rf_a_params, levels = 5)


# fit workflows/models ----
tuned_rf_a <- tune_grid(rf_a_wflow,
                      allies_folds,
                      grid = rf_a_grid,
                      control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_rf_a, file = here("results/tuned_rf_a.rda"))


# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(rf_a_model)

# change hyperparameter ranges
rf_a_params <- extract_parameter_set_dials(rf_a_model) |> 
  update(mtry = mtry(range = c(1, 37)),
         learn_rate = learn_rate(range = c(-5, -0.2)))



load(here("results/tuned_rf_a.rda"))
# build tuning grid
rf_a_grid <- grid_regular(rf_a_params, levels = 5)


# VISUAL INSPECTION OF TUNING RESULTS
autoplot(tuned_rf_a, metric = "rmse")

# SELECTING BEST RMSE
select_best(tuned_rf_a, "rmse")

rf_a_model_result <- as_workflow_set(
  rf = tuned_rf_a)

best_rf_a <- rf_a_model_result |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id, 
         `RMSE` = mean, 
         `Std Error` = std_err, 
         `Num Models` = n) |> 
  knitr::kable(digits = c(NA, 3, 4, 0))

best_rf_a
save(rf_a_params, rf_a_grid, rf_a_model_result, best_rf_a, file = here("results/best_rf_a.rda"))