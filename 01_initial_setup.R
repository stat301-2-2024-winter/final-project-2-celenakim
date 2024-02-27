# Final Project 2 ----
# Initial data checks, data splitting, & data folding

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(MASS)

# handle common conflicts
tidymodels_prefer()

set.seed(301)
allies <- read_csv("data/allies.csv")

# Github link ----
# https://github.com/stat301-2-2024-winter/final-project-2-celenakim


#### Task 1: VARIABLE DISTRIBUTION TRANSFORMATIONS -------------------------------------------
# numerical:
plot_numeric_distribution <- function(data) {
  numeric_vars <- select(data, 
                         where(is.numeric))
  
  for (var in colnames(numeric_vars)) {
    ggplot(data, 
           aes(x = !!sym(var))) +
      geom_density() +
      labs(title = paste("Distribution of", var))
    print(last_plot())
  }
}
#plot_numeric_distribution(allies)

# a majority of variables seem to be skewed right

# dic is skewed left
# clout has 3 peaks, mostly normal
# analytic has 2 peaks, left is higher


# categorical:
# ggplot(allies, aes(x = comment_length)) +
#   geom_bar() +
#   labs(x = "Comment Length",
#        y = "Count",
#        title = "Distribution of Comment Length")
# 

# LOG10 TRANSFORM--- YES
plot_numeric_distribution <- function(data) {
  numeric_vars <- select(data, where(is.numeric))
  
  numeric_vars <- log10(numeric_vars)
  
  for (var in colnames(numeric_vars)) {
    ggplot(data.frame(x = numeric_vars[[var]]), aes(x = x)) +
      geom_density() +
      labs(title = paste("Distribution of", var))
    print(last_plot())
  }
}
#plot_numeric_distribution(allies)



# DATA SPLITTING ------------------------------------------------------------------------------------------

allies_split <- allies |> 
  initial_split(prop = 0.75, 
                strata = likes)

allies_train <- training(allies_split)

# Transforming likes with yeo johnson
likes_transformed <- recipe(likes ~ analytic,
                            data = allies_train) |>
  step_YeoJohnson(likes) |> 
  prep() |> 
  bake(new_data = NULL) |> 
  transmute(likes_yj = likes)

allies_train <- allies_train |> 
  bind_cols(likes_transformed)

allies_test <- testing(allies_split)

allies_folds <- vfold_cv(allies_train, v = 10, repeats = 5,
                           strata = likes)

save(allies_split, allies_train, allies_test, allies_folds, file = here("results/allies_split.rda"))



# EXPLORING DATA --------------------------------------------------------------------
# allies_train |> 
#   ggplot(aes(x = neg_emo,
#              y = anger)) +
#   geom_point()
# # positive relationship
# 
# allies_train |> 
#   ggplot(aes(x = neg_emo,
#              y = sad)) +
#   geom_point()
# # positive relationship
# 
# allies_train |> 
#   ggplot(aes(x = pos_emo,
#              y = affect)) +
#   geom_point()
# # positive relationship
# 
# allies_train |> 
#   ggplot(aes(x = informal,
#              y = swear)) +
#   geom_point()
# # positive relationship
# 
# allies_train |> 
#   ggplot(aes(x = netspeak,
#              y = informal)) +
#   geom_point()
# # positive relationship
# 
# allies_train |> 
#   ggplot(aes(x = cog_proc,
#              y = insight)) +
#   geom_point()
# # positive relationship
# 
# allies_train |> 
#   ggplot(aes(x = netspeak,
#              y = swear)) +
#   geom_point()
# # positive relationship
# 
# allies_train |> 
#   ggplot(aes(x = pos_emo,
#              y = focus_future)) +
#   geom_point()
# 
# allies_train |> 
#   ggplot(aes(x = family,
#              y = affiliation)) +
#   geom_point()
# 
# 
# allies_train |> 
#   ggplot(aes(x = friend,
#              y = affiliation)) +
#   geom_point()
# 
# 
# allies_train |> 
#   ggplot(aes(x = pos_emo,
#              y = affiliation)) +
#   geom_point()
# 
# allies_train |> 
#   ggplot(aes(x = tentat,
#              y = nonflu)) +
#   geom_point()
# 




