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


#### Task 1: TARGET VARIABLE DISTRIBUTION TRANSFORMATIONS -------------------------------------------
ggplot(allies, aes(x = likes)) +
  geom_density() +
  labs(title = "Distribution of Likes",
       subtitle = "The variable is skewed right, with extreme outliers.",
       x = "Likes",
       y = "Density") +
  theme_minimal()
# the distribution of comment likes is heavily skewed to the right as there seems to be extreme high outliers. Thus, a transformation may be necessary to help normalize the distribution.

ggplot(allies, aes(x = log10(likes))) +
  geom_density() +
  labs(title = "Distribution of Likes with a Log Transformation",
       subtitle = "The variable is still skewed right, and many values were removed.",
       x = "Likes",
       y = "Density") +
  theme_minimal()
# a log transformation did seem to help to slightly normalize the likes distribution, but as there are numerous values of 0 within the observations, those values were removed

ggplot(allies, aes(x = sqrt(likes))) +
  geom_density() +
  labs(title = "Distribution of Likes with a Square Root Transformation",
       subtitle = "The variable is still skewed right, and many values were removed.",
       x = "Likes",
       y = "Density") +
  theme_minimal()
# sqrt transformation helped less than log


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
ggplot(allies, aes(x = factor(comment_length, 
                              levels = c("short", 
                                         "medium", "
                                         long")))) +
  geom_bar() +
  labs(x = "Comment Length",
       y = "Count",
       title = "Distribution of Comment Length",
       subtitle = "There are significantly more short comments than long or medium.") +
  theme_minimal()
# class imbalance, as there are significantly more short comments than long or medium

# DATA SPLITTING ------------------------------------------------------------------------------------------

allies_split <- allies |> 
  initial_split(prop = 0.80, 
                strata = likes)

allies_train <- training(allies_split)

# Transforming likes with yeo johnson
likes_transformed <- recipe(likes ~ i,
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


# RELATIONSHIPS
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
  ggplot(aes(x = pos_emo,
             y = achieve)) +
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

# Assuming allies_train_portion is your dataset
# Select only numerical variables
numeric_vars <- select_if(allies_train_portion, is.numeric)

# Calculate correlations between numerical variables
correlation_matrix <- cor(numeric_vars)

# Find pairs of variables with high correlations (absolute value greater than a threshold, e.g., 0.7)
high_correlation_pairs <- which(abs(correlation_matrix) > 0.7 & correlation_matrix != 1, arr.ind = TRUE)

# Print the pairs of variables with high correlations
print(high_correlation_pairs)




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
  ggplot(aes(x = pos_emo,
             y = focus_future)) +
  geom_point()
# weak correlation

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
  ggplot(aes(x = pos_emo,
             y = affiliation)) +
  geom_point()
# weak correlation

allies_train_portion |>
  ggplot(aes(x = tentat,
             y = nonflu)) +
  geom_point()
# weak correlation







