# Final Project 2 ----
# Setup pre-processing/recipes

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

set.seed(301)
load(here("results/allies_split.rda"))

# Github link ----
# https://github.com/stat301-2-2024-winter/final-project-2-celenakim



# RECIPE 1: BASIC KITCHEN SINK ----------------------------------------------------------------------
recipe1_kitchen_sink <- recipe(likes_yj ~ .,
                          data = allies_train) |> 
  step_rm(likes, comment_id, parent_comment_id, username, comment) |> 
  step_YeoJohnson(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors()) 

prep_recipe1_kitchen_sink <- prep(recipe1_kitchen_sink) |> 
  bake(new_data = NULL)

view(prep_recipe1_kitchen_sink)
save(recipe1_kitchen_sink, file = here("results/recipe1_kitchen_sink.rda"))


# RECIPE 2: BASIC KITCHEN SINK WITH ONE HOT --------------------------------------------------------------------
recipe2_kitchen_sink_trees <- recipe(likes_yj ~ .,
                              data = allies_train) |> 
  step_rm(likes, comment_id, parent_comment_id, username, comment) |> 
  step_dummy(all_nominal_predictors(),
             one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors()) 

prep_recipe2_kitchen_sink_trees <- prep(recipe2_kitchen_sink_trees) |> 
  bake(new_data = NULL)

view(prep_recipe2_kitchen_sink_trees)
save(recipe2_kitchen_sink_trees, file = here("results/recipe2_kitchen_sink_trees.rda"))


# RECIPE 3: RECIPE WITH YEO JOHNSON TRANSFORMATIONS AND INTERACTION TERMS ----------------------------------------------------------------------
recipe3_transformed_interactions <- recipe(likes_yj ~ .,
                              data = allies_train) |> 
  step_rm(likes, comment_id, parent_comment_id, username, comment) |> 
  step_YeoJohnson(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors()) |> 
  step_interact(terms = ~neg_emo:sad) |> 
  step_interact(terms = ~neg_emo:anger) |> 
  step_interact(terms = ~pos_emo:achieve) |> 
  step_interact(terms = ~informal:swear) |> 
  step_interact(terms = ~cog_proc:insight)

prep_recipe3_transformed_interactions <- prep(recipe3_transformed_interactions) |> 
  bake(new_data = NULL)

view(prep_recipe3_transformed_interactions)
save(recipe3_transformed_interactions, file = here("results/recipe3_transformed_interactions.rda"))

likes_transformed <- recipe(likes ~ informal,
       data = allies_train) |>
  step_YeoJohnson(likes) |> 
  prep() |> 
  bake(new_data = NULL) |> 
  select(likes)


# RECIPE 4: RECIPE WITH YEO JOHNSON TRANSFORMATIONS AND ONE HOT -------------------------------------------------------
recipe4_transformed_trees <- recipe(likes_yj ~ .,
                              data = allies_train) |> 
  step_rm(likes, comment_id, parent_comment_id, username, comment) |> 
  step_YeoJohnson(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors(),
             one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors()) 

prep_recipe4_transformed_trees <- prep(recipe4_transformed_trees) |> 
  bake(new_data = NULL)

view(prep_recipe4_transformed_trees)
save(recipe4_transformed_trees, file = here("results/recipe4_transformed_trees.rda"))





