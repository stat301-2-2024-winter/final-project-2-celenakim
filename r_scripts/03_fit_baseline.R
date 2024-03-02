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
load(here("data_splits/allies_split.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/recipe1_kitchen_sink.rda"))
load(here("recipes/recipe2_kitchen_sink_trees.rda"))
load(here("recipes/recipe3_transformed_interactions.rda"))
load(here("recipes/recipe4_transformed_trees.rda"))

# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)


# NULL MODEL
# model specifications ----
null_spec <- null_model() |> 
  set_engine("parsnip") |> 
  set_mode("regression") 

# define workflows ----
null_workflow <- workflow() |>  
  add_model(null_spec) |> 
  add_recipe(recipe1_kitchen_sink)

# fit workflows/models ----
null_fit_recipe1 <- null_workflow |> 
  fit_resamples(
    resamples = allies_folds, 
    control = control_resamples(save_workflow = TRUE)
  )

# write out results (fitted/trained workflows) ----
save(null_fit_recipe1, file = here("results/null_fit_recipe1.rda"))








