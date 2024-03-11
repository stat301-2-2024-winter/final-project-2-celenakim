## Psychological Analysis of Comments Under Jubilee Video "Are We Allies? Black Americans vs Asian Americans"

This repository contains a regression analysis is to predict the number of likes on a comment under the Jubilee Video 'Are We Allies? Black Americans vs. Asian Americans".

# What you can find in this repo:

## Folders

-   `data/`: Here you can find the data set I will be working with throughout this EDA: "allies". You can also find the R scripts that contain the process for reading in and cleaning the raw data set, as well as the codebook.

    -   `allies.csv`
    -   `allies.rds`
    -   `allies_codebook.csv`

    <!-- -->

    -   `00_cleaning.R`: Here, the process of cleaning the raw allies_data data set is shown.

    -   `codebook_creation.R`: In this R file, I create the codebook for my variables.

        -   Inside the `raw/` folder, you can find the original allies data set in its raw form.

-   `data_splits/`: can find the allies testing, training, and folds

-   `memos/`: contains Progress Memos 1 & 2

    -   `Kim_Celena_progress_memo_1.qmd`: This memo is the first step in my project, in which I identified my data set and anticipated potential issues/next steps.

    -   `Kim_Celena_progress_memo_2_qmd`: This next memo demonstrates a start on my model fits.

-   `r_scripts/`: contains the r scripts outlining the processes of EDAs, data splitting, recipes creations, fitting, tuning, and training the final model.

    -   `1_initial_setup.R`: Initial data checks, data splitting, & data folding

    -   `02_recipes.R`: Setup pre-processing/recipes: recipe1_kitchen_sink, recipe2_kitchen_sink_trees, recipe3_transformed_interactions, and recipe4_transformed_trees

    -   `03a_fit_baseline.R`: Define and fit null/baseline model a, with kitchen sink recipe 1

    -   `03a_fit_lm.R`: Define and fit ordinary linear regression a, with kitchen sink recipe 1

    -   `03b_fit_lm.R`: Define and fit ordinary linear regression b, with complex recipe 3

    -   `03a_tune_en.R`: Define and fit elastic net a, with kitchen sink recipe 1

    -   `03b_tune_en.R`: Define and fit elastic net b, with complex recipe 3

    -   `03a_tune_knn.R`: Define and fit knn a, with kitchen sink recipe 1

    -   `03b_tune_knn.R`: Define and fit knn b, with complex recipe 3

    -   `03a_tune_bt.R`: Define and fit bt a, with kitchen sink tree recipe 2

    -   `03b_tune_bt.R`: Define and fit bt b, with complex trees recipe 4

    -   `03a_tune_rf.R`: Define and fit rf a, with kitchen sink trees recipe 2

    -   `03b_tune_rf.R`: Define and fit rf b, with complex trees recipe 4

    -   `04_model_analysis.R`: Analysis of tuned and trained models (comparisons)

    -   `05_train_final_model.R`: Train final model

    -   `06_assess_final_model.R`: Assess final model

-   `recipes/`: contains the 4 recipes used in my model fits.

    -   `recipe1_kitchen_sink.rda`: my basic kitchen sink recipe

    -   `recipe2_kitchen_sink_trees.rda`: my basic kitchen sink recipe with one hot

    -   `recipe3_transformed_interactions.rda`: my complex recipe with yeo johnson transformations and interactions terms

    -   `recipe4_transformed_trees.rda`: my complex recipe with yeo johnson transformations and one hot

-   `results/`: contains my model fits and final winning model fit

    -   `final_fit.rda`: the final fit of winning model tuned_rf_a
    -   `lm_fit_a.rda`: fit for linear model a
    -   `lm_fit_b.rda`: fit for linear model b
    -   `null_fit_a.rda`: fit for null/baseline model a
    -   `tuned_bt_a.rda`: fit for bt model a
    -   `tuned_bt_b.rda`: fit for bt model b
    -   `tuned_en_a.rda`: fit for en model a
    -   `tuned_en_b.rda`: fit for en model b
    -   `tuned_knn_a.rda`: fit for knn model a
    -   `tuned_knn_b.rda`: fit for knn model b
    -   `tuned_rf_a.rda`: fit for rf model a
    -   `tuned_rf_b.rda`: fit for rf model b
