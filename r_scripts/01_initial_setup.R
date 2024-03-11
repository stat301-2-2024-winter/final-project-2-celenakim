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
allies <- read_rds("data/allies.rds")

# Github link ----
# https://github.com/stat301-2-2024-winter/final-project-2-celenakim


#### Task 1: TARGET VARIABLE ANALYSIS -------------------------------------------
ggplot(allies, aes(x = comment_length)) +
  geom_bar() +
  labs(x = "Comment Length",
       y = "Count",
       title = "Distribution of the Length of Comments") +
  theme_minimal()
# almost balanced, but not terribly inbalanced to where it will cause problems

#### Task 2: DATA INSPECTION -------------------------------------------
colSums(is.na(allies))

library(knitr)

# Calculate the count of missing values for each column
missing_counts <- colSums(is.na(allies))

# Convert the result to a data frame
missing_counts_df <- data.frame(Missing_Count = missing_counts)

# Create a neat table using kable
kable(missing_counts_df)
# there only seems to be missingness in the ID of a comment’s parent comment. However, this does not seem to pose a significant issue, as this variable is not going to be important for my analysis.

#### Task 3: CATEGORICAL VAR INSPECTION -------------------------------------------
ggplot(allies, aes(x = pos_emo)) +
  geom_bar() +
  labs(x = "Presence of Positive Emotion or Not",
       y = "Count",
       title = "Distribution of the Presence of Positive Emotion Within Comments") +
  theme_minimal()
# balanced

# DATA SPLITTING ------------------------------------------------------------------------------------------

allies_split <- allies |> 
  initial_split(prop = 0.80, 
                strata = comment_length,
                breaks = 4)

allies_train <- training(allies_split)

allies_test <- testing(allies_split)

allies_folds <- vfold_cv(allies_train, v = 10, repeats = 5,
                           strata = comment_length)

save(allies_split, allies_train, allies_test, allies_folds, file = here("data_splits/allies_split.rda"))

# EXPLORING REST OF DATA --------------------------------------------------------------------
# get a portion of training data set
allies_train_portion <- allies_train |> 
  slice_sample(prop = 0.8)


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
plot_numeric_distribution(allies_train_portion)


plot_lognumeric_distribution <- function(data) {
  numeric_vars <- select(data, 
                         where(is.numeric))
  
  for (var in colnames(numeric_vars)) {
    ggplot(data, 
           aes(x = log10(!!sym(var)))) +
      geom_density() +
      labs(title = paste("Distribution of", var))
    print(last_plot())
  }
}
plot_lognumeric_distribution(allies_train_portion)



# CORRELATION PLOT
corr <- allies_train_portion |> 
  select(where(is.numeric)) |> 
  cor()

allies_cor <- ggcorrplot::ggcorrplot(corr) +
  labs(title = "Correlations Among Predictor Variables") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, size = 4),
        axis.text.y = element_text(size = 4))


# RELATIONSHIPS-- SCATTERPLOTS
allies_train_portion |>
  ggplot(aes(x = neg_emo,
             y = sad)) +
  geom_point()
# positive relationship

allies_train_portion |>
  ggplot(aes(x = neg_emo,
             y = anger)) +
  geom_point()
# positive relationship

allies_train_portion |>
  ggplot(aes(x = cog_proc,
             y = insight)) +
  geom_point()
# positive relationship

allies_train_portion |>
  ggplot(aes(x = affiliation,
             y = drives)) +
  geom_point()
# positive relationship

allies_train_portion |>
  ggplot(aes(x = netspeak,
             y = informal)) +
  geom_point()
# positive relationship

allies_train_portion |>
  ggplot(aes(x = netspeak,
             y = swear)) +
  geom_point()
# positive relationship

allies_train_portion |>
  ggplot(aes(x = family,
             y = affiliation)) +
  geom_point()
# weak correlation

allies_train_portion |>
  ggplot(aes(x = friend,
             y = affiliation)) +
  geom_point()
# weak correlation

allies_train_portion |>
  ggplot(aes(x = tentat,
             y = nonflu)) +
  geom_point()
# weak correlation