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

# build tuning grid ----
rf_b_grid <- grid_regular(rf_b_params, levels = 5)

# fit workflows/models ----
tuned_rf_b <- tune_grid(rf_b_wflow,
                        allies_folds,
                        grid = rf_b_grid,
                        control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(rf_b_params, rf_b_grid, tuned_rf_b, file = here("results/tuned_rf_b.rda"))