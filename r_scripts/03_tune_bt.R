# Define and fit bt

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
load(here("recipes/recipe4_transformed_trees.rda"))

# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

set.seed(301)

# model specifications ----
bt_model <- boost_tree(mode = "regression", 
                       min_n = tune(),
                       mtry = tune(), 
                       learn_rate = tune()) |> 
  set_engine("xgboost")


# define workflows ----
bt_wflow <- 
  workflow() |> 
  add_model(bt_model) |> 
  add_recipe(recipe2_kitchen_sink_trees)

# hyperparameter tuning values ----
bt_params <- extract_parameter_set_dials(bt_model) |> 
  update(mtry = mtry(range = c(1, 14)),
         learn_rate = learn_rate(range = c(-5, -0.2)))

bt_grid <- grid_regular(bt_params, levels = 5)

# fit workflows/models ----
tuned_bt <- tune_grid(bt_wflow,
                      allies_folds,
                      grid = bt_grid,
                      control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_bt, file = here("results/tuned_bt.rda"))


### hyperparameter tuning values --------------------------------------------------------


# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(bt_model)

# change hyperparameter ranges
bt_params <- extract_parameter_set_dials(bt_model) |> 
  update(mtry = mtry(range = c(1, 14)),
         learn_rate = learn_rate(range = c(-5, -0.2)))

# build tuning grid
bt_grid <- grid_regular(bt_params, levels = 5)


# VISUAL INSPECTION OF TUNING RESULTS
autoplot(tuned_bt, metric = "rmse")

# SELECTING BEST RMSE
select_best(tuned_bt, "rmse")

bt_model_result <- as_workflow_set(
  bt = tuned_bt)

tbl_result <- bt_model_result |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id, 
         `RMSE` = mean, 
         `Std Error` = std_err, 
         `Num Models` = n) |> 
  knitr::kable(digits = c(NA, 3, 4, 0))

tbl_result