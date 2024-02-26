# Final Project 2 ----
# Define and fit baseline model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# load training data
load(here("results/allies_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("results/kitchen_sink_recipe.rda"))
load(here("results/kitchen_sink_recipe_trees.rda"))
load(here("results/allies_recipe2.rda"))

# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

# model specifications ----
null_spec <- null_model() |> 
  set_engine("parsnip") |> 
  set_mode("regression") 

# define workflows ----
null_workflow <- workflow() |>  
  add_model(null_spec) |> 
  add_recipe(kitchen_sink_recipe)

# fit workflows/models ----
null_fit_kitchen_sink <- null_workflow |> 
  fit_resamples(
    resamples = allies_folds, 
    control = control_resamples(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(null_fit_kitchen_sink, file = here("results/null_fit_kitchen_sink.rda"))








