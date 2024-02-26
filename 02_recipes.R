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

# KITCHEN SINK RECIPE
kitchen_sink_recipe <- recipe(likes ~ .,
                          data = allies_train) |> 
  step_rm(comment_id, parent_comment_id, username, comment) |> 
  step_YeoJohnson(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors()) 

prep_kitchen_sink_rec <- prep(kitchen_sink_recipe) |> 
  bake(new_data = NULL)

view(prep_kitchen_sink_rec)
save(kitchen_sink_recipe, file = here("results/kitchen_sink_recipe.rda"))

# KITCHEN SINK RECIPE-- TREES
kitchen_sink_recipe_trees <- recipe(likes ~ .,
                              data = allies_train) |> 
  step_rm(comment_id, parent_comment_id, username, comment) |> 
  step_dummy(all_nominal_predictors(),
             one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors()) 

prep_kitchen_sink_rec_trees <- prep(kitchen_sink_recipe_trees) |> 
  bake(new_data = NULL)

view(prep_kitchen_sink_rec_trees)
save(kitchen_sink_recipe_trees, file = here("results/kitchen_sink_recipe_trees.rda"))


# RECIPE 2-- INTERACTION TERMS
allies_recipe2 <- recipe(likes ~ .,
                              data = allies_train) |> 
  step_rm(comment_id, parent_comment_id, username, comment) |> 
  step_YeoJohnson(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors()) |> 
  step_interact(terms = ~neg_emo:sad) |> 
  step_interact(terms = ~neg_emo:anger) |> 
  step_interact(terms = ~pos_emo:sad) |> 
  step_interact(terms = ~informal:swear)

prep_allies_recipe2 <- prep(allies_recipe2) |> 
  bake(new_data = NULL)

view(prep_allies_recipe2)
save(allies_recipe2, file = here("results/allies_recipe2.rda"))




