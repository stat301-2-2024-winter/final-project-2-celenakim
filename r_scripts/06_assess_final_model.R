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

# TRANFORMING LIKES TO YEO JOHNSON SCALE
pred_rf <- bind_cols(allies_test, predict(final_fit, allies_test)) |> 
  select(.pred, likes) 

likes_trans <- bestNormalize::yeojohnson(pred_rf$likes, lambda = -0.656, inverse = FALSE, standardize = FALSE)
likes_tran <- likes_trans[[1]]

likes_tib <- tibble(likes_yj = likes_trans[[1]], pred_yj = pred_rf$.pred) 

ggplot(pred_rf, aes(x = likes_trans[[1]], y = .pred)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Likes", x = "Likes") +
  coord_obs_pred() 

pred_rf <- pred_rf |> 
  mutate(.pred_orig = ((.pred*-0.656) + 1)^(1/-0.656) -1,
         likes_yj = ((likes + 1)^-0.656 - 1)/-0.656)

pred_rf |> 
  allies_metrics(likes, .pred_orig)
pred_rf |> 
  allies_metrics(likes_yj, .pred)

ggplot(pred_rf, aes(x = likes, y = .pred_orig)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Likes", x = "Likes") +
  coord_obs_pred()

ggplot(pred_rf, aes(x = likes_yj, y = .pred)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Likes (yeo johnson scale)", x = "Likes (yeo johnson scale)") +
  coord_obs_pred()




# TRANFORMING PREDICTIONS BACK TO NORMAL SCALE
transformed_preds <- VGAM::yeo.johnson(pred_rf$.pred, lambda = -0.656, inverse = TRUE)
preds_reg <- transformed_preds[[1]]

likes_tib <- tibble(likes = allies_test$likes, preds = transformed_preds) 

ggplot(pred_rf, aes(x = likes, y = transformed_preds)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Likes", x = "Likes") +
  coord_obs_pred()















transformed <- VGAM::yeo.johnson(pred_rf$.pred, lambda = -0.656, inverse = TRUE)


likes_tib <- tibble(likes = pred_rf$likes, pred = transformed) 


final_pred_results <- pred_rf |> 
  allies_metrics(likes, estimate = .pred) |> 
  knitr::kable()

ggplot(pred_rf, aes(x = likes, y = transformed)) + 
  geom_abline(lty = 2) + 
  geom_point(alpha = 0.5) + 
  labs(y = "Predicted Likes", x = "Likes") +
  coord_obs_pred()

