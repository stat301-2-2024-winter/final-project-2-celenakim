# Final Project 2 ----
# Define and fit ordinary linear regression a with kitchen sink recipe 1

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
lm_spec <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow <-
  workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(recipe1_kitchen_sink)

# fit workflows/models ----
lm_fit_a <- fit_resamples(lm_wflow, 
                        resamples = allies_folds,
                        control = control_resamples(
                          save_workflow = TRUE,
                          parallel_over = "everything"
                        ))

# write out results (fitted/trained workflows) ----
save(lm_fit_a, file = here("results/lm_fit_a.rda"))