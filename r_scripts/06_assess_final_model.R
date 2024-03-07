# Final Project 2 ----
# Assess final model


# load packages ----
library(tidyverse)
library(tidymodels)
library(here)
library(doMC)

# handle common conflicts
tidymodels_prefer()

# load data/fits
load(here("results/final_fit.rda"))
load(here("data_splits/allies_split.rda"))
set.seed(301)


# Assess the model’s performance on the test set using RMSE, MAE, MAPE, and 
# Provide an interpretation for each. ----------------------------------------------------------

allies_metrics <- metric_set(rmse)

pred_rf <- bind_cols(allies_test, predict(final_fit, allies_test)) |> 
  mutate(.pred = VGAM::yeo.johnson(.pred, inverse = TRUE))

final_pred_results <- pred_rf |> 
  allies_metrics(likes, estimate = .pred) |> 
  knitr::kable()

ggplot(pred_rf, aes(x = likes, y = .pred)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Likes", x = "Likes") +
  coord_obs_pred()

