# Define and fit bt b with complex trees recipe 4

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
bt_b_model <- boost_tree(mode = "classification", 
                         min_n = tune(),
                         mtry = tune(), 
                         learn_rate = tune()) |> 
  set_engine("xgboost")

# define workflows ----
bt_b_wflow <- 
  workflow() |> 
  add_model(bt_b_model) |> 
  add_recipe(recipe4_transformed_trees)

# hyperparameter tuning values ----
bt_b_params <- extract_parameter_set_dials(bt_b_model) |> 
  update(mtry = mtry(range = c(1, 30)),
         learn_rate = learn_rate(range = c(-5, -0.2)))

# build tuning grid ----
bt_b_grid <- grid_regular(bt_b_params, levels = 5)

# fit workflows/models ----
tuned_bt_b <- tune_grid(bt_b_wflow,
                        allies_folds,
                        grid = bt_b_grid,
                        control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_bt_b, file = here("results/tuned_bt_b.rda"))