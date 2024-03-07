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

# change hyperparameter ranges ----
knn_a_params <- extract_parameter_set_dials(knn_a_spec) |> 
  # N:= maximum number of random predictor columns we want to try 
  # should be less than the number of available columns
  update(neighbors = neighbors(c(1, 45))) 

# build tuning grid ----
knn_a_grid <- grid_regular(knn_a_params, levels = 5)

# fit workflows/models ----
tuned_knn_a <- tune_grid(knn_a_wflow,
                       allies_folds,
                       grid = knn_a_grid,
                       control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_knn_a, file = here("results/tuned_knn_a.rda"))