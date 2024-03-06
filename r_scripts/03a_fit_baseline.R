# Final Project 2 ----
# Define and fit baseline model a with kitchen sink recipe 1

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


# NULL MODEL
# model specifications ----
null_spec_a <- null_model() |> 
  set_engine("parsnip") |> 
  set_mode("regression") 

# define workflows ----
null_workflow_a <- workflow() |>  
  add_model(null_spec_a) |> 
  add_recipe(recipe1_kitchen_sink)

# fit workflows/models ----
null_fit_a <- null_workflow_a |> 
  fit_resamples(
    resamples = allies_folds, 
    control = control_resamples(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(null_fit_a, file = here("results/null_fit_a.rda"))








