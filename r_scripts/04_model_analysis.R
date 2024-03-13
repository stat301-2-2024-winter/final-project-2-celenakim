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
load(here("results/log_reg_fit_a.rda"))
load(here("results/log_reg_fit_b.rda"))
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

# SELECTING BEST ACCURACY ----
select_best(tuned_en_a, metric = "accuracy") 
select_best(tuned_en_b, metric = "accuracy")
select_best(tuned_knn_a, metric = "accuracy")
select_best(tuned_knn_b, metric = "accuracy")
select_best(tuned_rf_a, metric = "accuracy")
select_best(tuned_rf_b, metric = "accuracy")
select_best(tuned_bt_a, metric = "accuracy")
select_best(tuned_bt_b, metric = "accuracy")


# FINDING BEST ACCURACY FOR EACH MODEL ----
model_results <- as_workflow_set(
  null = null_fit_a,
  log_reg_a = log_reg_fit_a,
  log_reg_b = log_reg_fit_b,
  en_a = tuned_en_a,
  en_b = tuned_en_b,
  knn_a = tuned_knn_a,
  knn_b = tuned_knn_b,
  rf_a = tuned_rf_a,
  rf_b = tuned_rf_b,
  bt_a = tuned_bt_a,
  bt_b = tuned_bt_b)

tbl_result_accuracy <- model_results |> 
  collect_metrics() |> 
  filter(.metric == "accuracy") |> 
  slice_min(mean, by = wflow_id) |> 
  distinct(wflow_id, .keep_all = TRUE) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id, 
         `Accuracy` = mean, 
         `Std Error` = std_err, 
         `Num Models` = n) |> 
  knitr::kable(digits = c(NA, 3, 6, 0))

tbl_result_accuracy


tbl_result_roc_auc <- model_results |> 
  collect_metrics() |> 
  filter(.metric == "roc_auc") |> 
  slice_min(mean, by = wflow_id) |> 
  distinct(wflow_id, .keep_all = TRUE) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id, 
         `ROC AUC` = mean, 
         `Std Error` = std_err, 
         `Num Models` = n) |> 
  knitr::kable(digits = c(NA, 3, 6, 0))

tbl_result_roc_auc



cor_set <- allies_train |> 
  select(comment_length, where(is.numeric))

correlation <- cor(cor_set[, -which(names(cor_set) == "comment_length")], 
                   as.numeric(cor_set$comment_length), 
                   use = "pairwise.complete.obs")

correlation_tbl <- correlation |> 
  enframe() |> 
  arrange(value) |> 
  knitr::kable()

