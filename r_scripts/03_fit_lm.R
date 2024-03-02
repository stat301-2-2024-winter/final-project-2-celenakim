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
load(here("results/recipe1_kitchen_sink.rda"))
load(here("results/recipe2_kitchen_sink_trees.rda"))
load(here("results/recipe3_transformed_interactions.rda"))
load(here("results/recipe4_transformed_trees.rda"))

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
  add_recipe(recipe3_transformed_interactions)

# fit workflows/models ----
lm_fit_recipe3 <- fit_resamples(lm_wflow, 
                        resamples = allies_folds,
                        control = control_resamples(
                          save_workflow = TRUE,
                          parallel_over = "everything"
                        ))

# write out results (fitted/trained workflows) ----
save(lm_fit_recipe3, file = here("results/lm_fit_recipe3.rda"))


