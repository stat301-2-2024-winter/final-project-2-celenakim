# Define and fit bt a with kitchen sink tree recipe

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
bt_a_model <- boost_tree(mode = "regression", 
                       trees = 1000,
                       min_n = tune(),
                       mtry = tune(), 
                       learn_rate = tune()) |> 
  set_engine("xgboost")


# define workflows ----
bt_a_wflow <- 
  workflow() |> 
  add_model(bt_a_model) |> 
  add_recipe(recipe2_kitchen_sink_trees)

# hyperparameter tuning values ----
bt_a_params <- extract_parameter_set_dials(bt_a_model) |> 
  update(mtry = mtry(range = c(1, 30)),
         learn_rate = learn_rate(range = c(-5, -0.2)))

bt_a_grid <- grid_regular(bt_a_params, levels = 5)

# fit workflows/models ----
tuned_bt_a <- tune_grid(bt_a_wflow,
                      allies_folds,
                      grid = bt_a_grid,
                      control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_bt_a, file = here("results/tuned_bt_a.rda"))
load(here("results/tuned_bt_a.rda"))


# VISUAL INSPECTION OF TUNING RESULTS
autoplot(tuned_bt_a, metric = "rmse")

# SELECTING BEST RMSE
select_best(tuned_bt_a, "rmse")

bt_a_model_result <- as_workflow_set(
  bt = tuned_bt_a)

best_bt_a <- bt_a_model_result |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id, 
         `RMSE` = mean, 
         `Std Error` = std_err, 
         `Num Models` = n) |> 
  knitr::kable(digits = c(NA, 3, 4, 0))

best_bt_a
save(bt_a_params, bt_a_grid, bt_a_model_result, best_bt_a, file = here("results/best_bt_a.rda"))

load(here("results/best_bt_a.rda"))