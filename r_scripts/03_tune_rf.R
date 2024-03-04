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
load(here("recipes/recipe4_transformed_trees.rda"))


# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

set.seed(301)
# model specifications ----
rf_model <- rand_forest(mode = "regression",
                        trees = 500,
                        min_n = tune(),  # what is the min num of observations needed in final node
                        mtry = tune()) |> 
  set_engine("ranger")

# define workflows ----
rf_wflow <- 
  workflow() |> 
  add_model(rf_model) |> 
  add_recipe(carseats_recipe)

# hyperparameter tuning values ----
rf_params <- extract_parameter_set_dials(rf_model) |> 
  update(mtry = mtry(range = c(1, 14)))

rf_grid <- grid_regular(rf_params, levels = 5)

# grid_random(rf_params, size = 20)
# grid_latin_hypercube(rf_params, size = 20), good for many parameters

# fit workflows/models ----
tuned_rf <- tune_grid(rf_wflow,
                      carseats_folds,
                      grid = rf_grid,
                      control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_rf, file = here("results/tuned_rf.rda"))
