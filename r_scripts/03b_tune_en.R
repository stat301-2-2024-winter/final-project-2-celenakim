# Define and fit elastic net b with complex recipe 3

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
en_b_model <- logistic_reg(penalty = tune(), 
                         mixture = tune()) |>
  set_engine("glmnet") |> 
  set_mode("classification") 

# hyperparameter tuning values ----
# update the parameters
en_b_params <- extract_parameter_set_dials(en_b_model) |> 
  update(penalty = penalty(range = c(-10, 0)) )

# build tuning grid ----
en_b_grid <- grid_regular(en_b_params, levels = 5)

# define workflows ----
en_b_wflow <- 
  workflow() |> 
  add_model(en_b_model) |> 
  add_recipe(recipe3_transformed_interactions)

# fit workflows/models ----
tuned_en_b <- tune_grid(en_b_wflow,
                        allies_folds,
                        grid = en_b_grid,
                        control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_en_b, file = here("results/tuned_en_b.rda"))