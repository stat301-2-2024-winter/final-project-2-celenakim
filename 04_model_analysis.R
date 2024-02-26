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
load(here("results/allies_split.rda"))
load(here("results/fit_lm_recipe2.rda"))
load(here("results/null_fit_kitchen_sink.rda"))


# load pre-processing/feature engineering/recipe
load(here("results/kitchen_sink_recipe.rda"))
load(here("results/kitchen_sink_recipe_trees.rda"))
load(here("results/allies_recipe2.rda"))

set.seed(301)


# lm model with allies_recipe2
bind_rows(fit_lm_recipe2 |> 
            collect_metrics() |>  
            mutate(model = "lm")) |> 
  select(.metric, mean, std_err, model)

fit_lm_recipe2 |> 
  collect_metrics() |> 
  mutate(model = "lm") |> 
  bind_rows(null_fit_kitchen_sink |> 
              collect_metrics() |>  
              mutate(model = "null"))


allies |> 
  select(likes) |> 
  summarize(mean = mean(likes))

allies |> 
  ggplot(aes(x = likes)) +
  geom_density()