# Final Project 2 ----
# Train final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# load data/fits
load(here("data_splits/allies_split.rda"))
load(here("results/tuned_rf_a.rda"))

# load pre-processing/feature engineering/recipe
load(here("recipes/recipe1_kitchen_sink.rda"))
load(here("recipes/recipe2_kitchen_sink_trees.rda"))
load(here("recipes/recipe3_transformed_interactions.rda"))
load(here("recipes/recipe4_transformed_trees.rda"))
set.seed(301)


# Train the best model on the entire training dataset-------------------------------------------
# finalize workflow ----
final_wflow <- tuned_rf_a |> 
  extract_workflow(tuned_rf_a) |>  
  finalize_workflow(select_best(tuned_rf_a, metric = "rmse"))

# train final model ----
# set seed
set.seed(301)
final_fit <- fit(final_wflow, allies_train)
save(final_fit, file = here("results/final_fit.rda"))
