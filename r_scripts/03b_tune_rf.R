# Define and fit rf b with complex trees recipe 4

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
load(here("recipes/recipe4_transformed_trees.rda"))


# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

set.seed(301)
# model specifications ----
rf_b_model <- rand_forest(mode = "regression",
                          trees = 1000,
                          min_n = tune(),  # what is the min num of observations needed in final node
                          mtry = tune()) |> 
  set_engine("ranger")

# define workflows ----
rf_b_wflow <- 
  workflow() |> 
  add_model(rf_b_model) |> 
  add_recipe(recipe4_transformed_trees)

# hyperparameter tuning values ----
rf_b_params <- extract_parameter_set_dials(rf_b_model) |> 
  update(mtry = mtry(range = c(1, 30)))

rf_b_grid <- grid_regular(rf_b_params, levels = 5)


# fit workflows/models ----
tuned_rf_b <- tune_grid(rf_b_wflow,
                        allies_folds,
                        grid = rf_b_grid,
                        control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(rf_b_params, rf_b_grid, tuned_rf_b, file = here("results/tuned_rf_b.rda"))
load(here("results/tuned_rf_b.rda"))


# VISUAL INSPECTION OF TUNING RESULTS
autoplot(tuned_rf_b, metric = "rmse")

# SELECTING BEST RMSE
select_best(tuned_rf_b, "rmse")

rf_b_model_result <- as_workflow_set(
  rf_b = tuned_rf_b)

best_rf_b <- rf_b_model_result |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id, 
         `RMSE` = mean, 
         `Std Error` = std_err, 
         `Num Models` = n) |> 
  knitr::kable(digits = c(NA, 3, 4, 0))

best_rf_b
save(rf_b_model_result, best_rf_b, file = here("results/best_rf_b.rda"))
load(here("results/best_rf_b.rda"))