# Final Project 2 ----
# Initial data checks, data splitting, & data folding

# load packages ----
library(tidyverse)
library(tidymodels)
library(here)

# handle common conflicts
tidymodels_prefer()

set.seed(301)
load(here("data/allies.csv"))




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
plot_numeric_distribution(allies)

# a majority of variables seem to be skewed right

# dic is skewed left
# clout has 3 peaks, mostly normal
# analytic has 2 peaks, left is higher


# categorical:
ggplot(allies, aes(x = comment_length)) +
  geom_bar() +
  labs(x = "Comment Length",
       y = "Count",
       title = "Distribution of Comment Length")


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
plot_numeric_distribution(allies)



# SQUARE ROOT TRANSFORM-- NO
plot_numeric_distribution <- function(data) {
  numeric_vars <- select(data, where(is.numeric))
  
  numeric_vars <- sqrt(numeric_vars)
  
  for (var in colnames(numeric_vars)) {
    ggplot(data.frame(x = numeric_vars[[var]]), aes(x = x)) +
      geom_density() +
      labs(title = paste("Distribution of", var))
    print(last_plot())
  }
}
plot_numeric_distribution(allies)


# SQUARE TRANSFORM--- NO 
plot_numeric_distribution <- function(data) {
  numeric_vars <- select(data, where(is.numeric))
  
  numeric_vars <- (numeric_vars)^2
  
  for (var in colnames(numeric_vars)) {
    ggplot(data.frame(x = numeric_vars[[var]]), aes(x = x)) +
      geom_density() +
      labs(title = paste("Distribution of", var))
    print(last_plot())
  }
}
plot_numeric_distribution(allies)


# SPLINES





# CUBIC ROOT TRANSFORM
plot_numeric_distribution <- function(data) {
  numeric_vars <- select(data, where(is.numeric))
  
  numeric_vars <- (numeric_vars)^(1/3)
  
  for (var in colnames(numeric_vars)) {
    ggplot(data.frame(x = numeric_vars[[var]]), aes(x = x)) +
      geom_density() +
      labs(title = paste("Distribution of", var))
    print(last_plot())
  }
}
plot_numeric_distribution(allies)



