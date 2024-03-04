# Define and fit knn with kitchen sink recipe

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
knn_spec <- 
  nearest_neighbor(mode = "regression",
                   neighbors = tune()) |> 
  set_engine("kknn")

# define workflows ----
knn_wflow <-
  workflow() |> 
  add_model(knn_spec) |> 
  add_recipe(carseats_recipe)

# hyperparameter tuning values ----

# check ranges for hyperparameters
hardhat::extract_parameter_set_dials(knn_spec)

# change hyperparameter ranges
knn_params <- extract_parameter_set_dials(knn_spec) |> 
  # N:= maximum number of random predictor columns we want to try 
  # should be less than the number of available columns
  update(neighbors = neighbors(c(1, 10))) 

# build tuning grid
knn_grid <- grid_regular(knn_params, levels = 5)

# fit workflows/models ----
tuned_knn <- tune_grid(knn_wflow,
                       carseats_folds,
                       grid = knn_grid,
                       control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_knn, file = here("results/tuned_knn.rda"))