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

predict_rf <- allies_test |> 
  select(comment_length) |> 
  bind_cols(predict(final_fit, allies_test))


## ACCURACY
accuracy_rf <- accuracy(predict_rf, 
                               truth = comment_length, 
                               estimate = .pred_class)

accuracy_rf |> 
  knitr::kable()


## CONFUSION MATRIX
conf_mat_rf<- conf_mat(predict_rf, 
                              truth = comment_length, 
                              estimate = .pred_class) 

conf_mat_rf_df <- as.data.frame.matrix(conf_mat_rf$table)

knitr::kable(conf_mat_rf_df, caption = "Confusion Matrix for Random Forest a Model")


## ROC CURVE
allies_predicted_prob_rf <- allies_test |> 
  select(comment_length) |> 
  bind_cols(predict(final_fit, 
                    allies_test, 
                    type = "prob"))

allies_rf_curve <- roc_curve(allies_predicted_prob_rf, 
                             comment_length, 
                                   .pred_long)

autoplot(allies_rf_curve)


## ROC AUC
roc_auc(allies_predicted_prob_rf, 
        comment_length, 
        .pred_long)

