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
load(here("results/null_fit_a.rda"))
load(here("results/lm_fit_a.rda"))
load(here("results/lm_fit_b.rda"))
load(here("results/tuned_en_a.rda"))
load(here("results/tuned_knn_a.rda"))
load(here("results/tuned_rf_a.rda"))
load(here("results/tuned_bt_a.rda"))


# load pre-processing/feature engineering/recipe
load(here("recipes/recipe1_kitchen_sink.rda"))
load(here("recipes/recipe2_kitchen_sink_trees.rda"))
load(here("recipes/recipe3_transformed_interactions.rda"))
load(here("recipes/recipe4_transformed_trees.rda"))
set.seed(301)


allies_metrics <- null_fit_a |> 
  collect_metrics() |> 
  mutate(model = "null_a") |> 
  bind_rows(lm_fit_a |> 
              collect_metrics() |>  
              mutate(model = "lm_a")) |> 
  bind_rows(lm_fit_b |> 
              collect_metrics() |>  
              mutate(model = "lm_b")) |> 
  bind_rows(tuned_en_a |> 
              collect_metrics() |>  
              mutate(model = "en_a")) |> 
  bind_rows(tuned_knn_a |> 
              collect_metrics() |>  
              mutate(model = "knn_a")) |> 
  bind_rows(tuned_rf_a |> 
              collect_metrics() |>  
              mutate(model = "rf_a"))
  bind_rows(tuned_bt_a |> 
              collect_metrics() |>  
              mutate(model = "bt_a")) |> 
  filter(.metric == "rmse") |> 
  select(.metric, mean, std_err, model) 


model_results <- as_workflow_set(
    null = null_fit_a,
    lm_a = lm_fit_a,
    lm_b = lm_fit_b,
    en_a = tuned_en_a,
    knn_a = tuned_knn_a,
    rf_a = tuned_rf_a,
    bt_a = tuned_bt_a)
  
tbl_result <- model_results |> 
    collect_metrics() |> 
    filter(.metric == "rmse") |> 
    slice_min(mean, by = wflow_id) |> 
    arrange(mean) |> 
    select(`Model Type` = wflow_id, 
           `RMSE` = mean, 
           `Std Error` = std_err, 
           `Num Models` = n) |> 
    knitr::kable(digits = c(NA, 2, 4, 0))
  
tbl_result



