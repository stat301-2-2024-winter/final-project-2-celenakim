# Final Project 2 ----
# Define and fit logistic regression a with kitchen sink recipe 1

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
log_reg_a_spec <- 
  logistic_reg() |> 
  set_engine("glm") |> 
  set_mode("classification") 

# define workflows ----
log_reg_a_wflow <-
  workflow() |> 
  add_model(log_reg_a_spec) |> 
  add_recipe(recipe1_kitchen_sink)

# fit workflows/models ----
log_reg_fit_a <- fit_resamples(log_reg_a_wflow, 
                               resamples = allies_folds,
                               control = control_resamples(
                                 save_workflow = TRUE,
                                 parallel_over = "everything"))

# write out results (fitted/trained workflows) ----
save(log_reg_fit_a, file = here("results/log_reg_fit_a.rda"))