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
  nearest_neighbor(mode = "classification",
                   neighbors = tune()) |> 
  set_engine("kknn") |> 
  set_mode("classification") 

# define workflows ----
knn_b_wflow <-
  workflow() |> 
  add_model(knn_b_spec) |> 
  add_recipe(recipe3_transformed_interactions)

# hyperparameter tuning values ----
# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(knn_b_spec)

# change hyperparameter ranges ----
knn_b_params <- extract_parameter_set_dials(knn_b_spec) |> 
  # N:= maximum number of random predictor columns we want to try 
  # should be less than the number of available columns
  update(neighbors = neighbors(c(1, 45))) 

# build tuning grid ----
knn_b_grid <- grid_regular(knn_b_params, levels = 5)

# fit workflows/models ----
tuned_knn_b <- tune_grid(knn_b_wflow,
                       allies_folds,
                       grid = knn_b_grid,
                       control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_knn_b, file = here("results/tuned_knn_b.rda"))