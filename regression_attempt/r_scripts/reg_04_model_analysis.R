# Final Project 2 ----
# Analysis of tuned and trained models (comparisons)

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
load(here("results/tuned_en_b.rda"))
load(here("results/tuned_knn_a.rda"))
load(here("results/tuned_knn_b.rda"))
load(here("results/tuned_rf_a.rda"))
load(here("results/tuned_rf_b.rda"))
load(here("results/tuned_bt_a.rda"))
load(here("results/tuned_bt_b.rda"))


set.seed(301)



# VISUAL INSPECTION OF TUNING RESULTS ----
autoplot(tuned_en_a)
autoplot(tuned_en_b)
autoplot(tuned_knn_a)
autoplot(tuned_knn_b)
autoplot(tuned_rf_a)
autoplot(tuned_rf_b)
autoplot(tuned_bt_a)
autoplot(tuned_bt_b)

# SELECTING BEST RMSE ----
select_best(tuned_en_a, metric = "rmse")
select_best(tuned_en_b, metric = "rmse")
select_best(tuned_knn_a, metric = "rmse")
select_best(tuned_knn_b, metric = "rmse")
select_best(tuned_rf_a, metric = "rmse")
select_best(tuned_rf_b, metric = "rmse")
select_best(tuned_bt_a, metric = "rmse")
select_best(tuned_bt_b, metric = "rmse")


# FINDING BEST RMSE FOR EACH MODEL ----
model_results <- as_workflow_set(
  null = null_fit_a,
  lm_a = lm_fit_a,
  lm_b = lm_fit_b,
  en_a = tuned_en_a,
  en_b = tuned_en_b,
  knn_a = tuned_knn_a,
  knn_b = tuned_knn_b,
  rf_a = tuned_rf_a,
  rf_b = tuned_rf_b,
  bt_a = tuned_bt_a,
  bt_b = tuned_bt_b)

tbl_result <- model_results |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  distinct(wflow_id, .keep_all = TRUE) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id, 
         `RMSE` = mean, 
         `Std Error` = std_err, 
         `Num Models` = n) |> 
  knitr::kable(digits = c(NA, 3, 4, 0))

tbl_result

model_results <- as_workflow_set(
  null = null_fit_a,
  lm_a = lm_fit_a,
  lm_b = lm_fit_b,
  en_a = tuned_en_a,
  en_b = tuned_en_b,
  knn_a = tuned_knn_a,
  knn_b = tuned_knn_b,
  rf_a = tuned_rf_a,
  rf_b = tuned_rf_b,
  bt_a = tuned_bt_a,
  bt_b = tuned_bt_b)

tbl_result <- model_results |> 
  collect_metrics() |> 
  filter(.metric == "r") |> 
  slice_min(mean, by = wflow_id) |> 
  distinct(wflow_id, .keep_all = TRUE) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id, 
         `RMSE` = mean, 
         `Std Error` = std_err, 
         `Num Models` = n) |> 
  knitr::kable(digits = c(NA, 3, 4, 0))

tbl_result