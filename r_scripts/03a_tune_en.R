# Define and fit elastic net with kitchen sink recipe

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
en_a_model <- linear_reg(penalty = tune(), 
                         mixture = tune()) |>
  set_engine("glmnet")

extract_parameter_set_dials(en_a_model)
penalty()
mixture()

# hyperparameter tuning values ----
# update the parameters
en_a_params <- extract_parameter_set_dials(en_a_model) |> 
  # just an example of how to update
  update(penalty = penalty(range = c(-10, 0)) )

# grid
en_a_grid <- grid_regular(en_a_params, levels = 5)

# define workflows ----
en_a_wflow <- 
  workflow() |> 
  add_model(en_a_model) |> 
  add_recipe(recipe1_kitchen_sink)

# fit workflows/models ----
tuned_en_a <- tune_grid(en_a_wflow,
                        allies_folds,
                        grid = en_a_grid,
                        control = control_grid(save_workflow = TRUE))

# write out results (fitted/trained workflows) ----
save(tuned_en_a, file = here("results/tuned_en_a.rda"))
load(here("results/tuned_en_a.rda"))

# VISUAL INSPECTION OF TUNING RESULTS
autoplot(tuned_en_a)

# SELECTING BEST RMSE
select_best(tuned_en_a, metric = "rmse")

en_a_model_result <- as_workflow_set(
  en_a = tuned_en_a)

best_en_a <- en_a_model_result |> 
  collect_metrics() |> 
  filter(.metric == "rmse") |> 
  slice_min(mean, by = wflow_id) |> 
  arrange(mean) |> 
  select(`Model Type` = wflow_id, 
         `RMSE` = mean, 
         `Std Error` = std_err, 
         `Num Models` = n) |> 
  knitr::kable(digits = c(NA, 3, 4, 0))

best_en_a
save(en_a_params, en_a_grid, en_a_model_result, best_en_a, file = here("results/best_en_a.rda"))
load(here("results/best_en_a.rda"))

