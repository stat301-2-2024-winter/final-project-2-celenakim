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



# KITCHEN SINK RECIPE ----------------------------------------------------------------------
recipe1_kitchen_sink <- recipe(likes_yj ~ .,
                          data = allies_train) |> 
  step_rm(likes, comment_id, parent_comment_id, username, comment) |> 
  step_YeoJohnson(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors()) 

prep_kitchen_sink_rec <- prep(recipe1_kitchen_sink) |> 
  bake(new_data = NULL)

view(prep_kitchen_sink_rec)
save(recipe1_kitchen_sink, file = here("results/recipe1_kitchen_sink.rda"))



# KITCHEN SINK RECIPE 2-- TREES ----------------------------------------------------------------------
recipe2_kitchen_sink_trees <- recipe(likes_yj ~ .,
                              data = allies_train) |> 
  step_rm(likes, comment_id, parent_comment_id, username, comment) |> 
  step_dummy(all_nominal_predictors(),
             one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors()) 

prep_kitchen_sink_rec_trees <- prep(recipe2_kitchen_sink_trees) |> 
  bake(new_data = NULL)

view(prep_kitchen_sink_rec_trees)
save(recipe2_kitchen_sink_trees, file = here("results/recipe2_kitchen_sink_trees.rda"))


# RECIPE 3-- INTERACTION TERMS ----------------------------------------------------------------------
recipe3_interactions <- recipe(likes_yj ~ .,
                              data = allies_train) |> 
  step_rm(likes, comment_id, parent_comment_id, username, comment) |> 
  step_YeoJohnson(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors()) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors()) |> 
  step_interact(terms = ~neg_emo:sad) |> 
  step_interact(terms = ~neg_emo:anger) |> 
  step_interact(terms = ~pos_emo:affect) |> 
  step_interact(terms = ~informal:swear) |> 
  step_interact(terms = ~cog_proc:insight)

prep_allies_recipe2 <- prep(recipe3_interactions) |> 
  bake(new_data = NULL)

view(prep_allies_recipe2)
save(recipe3_interactions, file = here("results/recipe3_interactions.rda"))


likes_transformed <- recipe(likes ~ informal,
       data = allies_train) |>
  step_YeoJohnson(likes) |> 
  prep() |> 
  bake(new_data = NULL) |> 
  select(likes)



# RECIPE 4-- TRANSFORMATIONS/ TREES
recipe4_trasnformed_trees <- recipe(likes_yj ~ .,
                              data = allies_train) |> 
  step_rm(likes, comment_id, parent_comment_id, username, comment) |> 
  step_YeoJohnson(all_numeric_predictors()) |> 
  step_dummy(all_nominal_predictors(),
             one_hot = TRUE) |> 
  step_zv(all_predictors()) |> 
  step_normalize(all_predictors()) 

prep_kitchen_sink_rec <- prep(recipe4_trasnformed_trees) |> 
  bake(new_data = NULL)

view(prep_kitchen_sink_rec)
save(recipe4_trasnformed_trees, file = here("results/recipe4_trasnformed_trees.rda"))





