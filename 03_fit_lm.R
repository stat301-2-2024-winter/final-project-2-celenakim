# Final Project 2 ----
# Define and fit ordinary linear regression

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
lm_spec <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow <-
  workflow() |> 
  add_model(lm_spec) |> 
  add_recipe(allies_recipe2)

# fit workflows/models ----
fit_lm_recipe2 <- fit_resamples(lm_wflow, 
                        resamples = allies_folds,
                        control = control_resamples(
                          save_workflow = TRUE,
                          parallel_over = "everything"
                        ))

# write out results (fitted/trained workflows) ----
save(fit_lm_recipe2, file = here("results/fit_lm_recipe2.rda"))


