# Final Project 2 ----
# Analysis of tuned and trained models (comparisons)
# Select final model
# Fit & analyze final model

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# load training data/fits
load(here("data_splits/allies_split.rda"))
load(here("results/lm_fit_recipe3.rda"))
load(here("results/null_fit_recipe1.rda"))


# load pre-processing/feature engineering/recipe
load(here("recipes/recipe1_kitchen_sink.rda"))
load(here("recipes/recipe2_kitchen_sink_trees.rda"))
load(here("recipes/recipe3_transformed_interactions.rda"))
load(here("recipes/recipe4_transformed_trees.rda"))
set.seed(301)



lm_fit_recipe3 |> 
  collect_metrics() |> 
  mutate(model = "lm") |> 
  bind_rows(null_fit_recipe1 |> 
              collect_metrics() |>  
              mutate(model = "null")) |> 
  knitr::kable(digits = c(NA, NA, 3, 0, 5, NA))






