# Define and fit elastic net b with complex recipe 3

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
load(here("recipes/recipe3_transformed_interactions.rda"))


# set up parallel processing
num_cores <- parallel::detectCores(logical = TRUE)
registerDoMC(cores = num_cores)

set.seed(301)

# model specifications ----
en_b_model <- linear_reg(penalty = tune(), 
                         mixture = tune()) |>
  set_engine("glmnet")

extract_parameter_set_dials(en_b_model)
penalty()
mixture()

# hyperparameter tuning values ----
# update the parameters
en_b_params <- extract_parameter_set_dials(en_b_model) |> 
  # just an example of how to update
  update(penalty = penalty(range = c(-10, 0)) )

# grid
en_b_grid <- grid_regular(en_b_params, levels = 5)

# define workflows ----
en_b_wflow <- 
  workflow() |> 
  add_model(en_b_model) |> 
  add_recipe(recipe3_transformed_interactions)

# fit workflows/models ----
tuned_en_b <- tune_grid(en_b_wflow,
                        allies_folds,
                        grid = en_b_grid,
                        control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_en_b, file = here("results/tuned_en_b.rda"))
load(here("results/tuned_en_b.rda"))

# VISUAL INSPECTION OF TUNING RESULTS
autoplot(tuned_en_b)

# SELECTING BEST RMSE
select_best(tuned_en_b, metric = "rmse")

en_b_model_result <- as_workflow_set(
  en_b = tuned_en_b)

best_en_b <- en_b_model_result |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id, 
         `RMSE` = mean, 
         `Std Error` = std_err, 
         `Num Models` = n) |> 
  knitr::kable(digits = c(NA, 3, 4, 0))

best_en_b
save(en_b_params, en_b_grid, en_b_model_result, best_en_b, file = here("results/best_en_b.rda"))
load(here("results/best_en_b.rda"))
