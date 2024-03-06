# Final Project 2 ----
# Define and fit ordinary linear regression b with complex recipe 3

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


# model specifications ----
lm_spec_b <- 
  linear_reg() |> 
  set_engine("lm") |> 
  set_mode("regression") 

# define workflows ----
lm_wflow_b <-
  workflow() |> 
  add_model(lm_spec_b) |> 
  add_recipe(recipe3_transformed_interactions)

# fit workflows/models ----
lm_fit_b <- fit_resamples(lm_wflow_b, 
                          resamples = allies_folds,
                          control = control_resamples(
                            save_workflow = TRUE,
                            parallel_over = "everything"
                          ))

# write out results (fitted/trained workflows) ----
save(lm_fit_b, file = here("results/lm_fit_b.rda"))
load(here("results/lm_fit_b.rda"))

bind_rows(lm_fit_b |> 
            collect_metrics() |>  
            mutate(model = "lm") |> 
            filter(.metric == "rmse")) |> 
  knitr::kable(digits = c(NA, NA, 3, 0, 5, NA))
