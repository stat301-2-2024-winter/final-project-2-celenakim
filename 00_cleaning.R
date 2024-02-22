# Final Project 2
# Cleaning raw data

# load packages ----
library(tidyverse)
library(dplyr)
library(here)

# Github link ----
# https://github.com/stat301-2-2024-winter/final-project-2-celenakim

# load data ----
allies_data <- read_csv(here::here("data/raw/allies_video_data.csv"))



allies <- allies_data |> 
  # 1. rename columns A-P to correct variable names, 
  #    rename LIWC variable names to make more sense
  rename(
    comment_id = A,
    video_id = B,
    video_title = C,
    channel_title = D,
    subscribers = E,
    username = F,
    comment = G,
    likes = H,
    comment_published_at = I,
    replies = J,
    view_count = K,
    like_count = L,
    comment_count = M,
    video_published_at = N,
    comment_type = O,
    parent_comment_id = P,
    word_count = WC,
    words_per_sentence = WPS,
    six_ltrs = Sixltr,
    pos_emo = posemo,
    neg_emo = negemo,
    cog_proc = cogproc,
    focus_past = focuspast,
    focus_present = focuspresent,
    focus_future = focusfuture) |> 
  janitor::clean_names() |> 
  # 2. get rid of irrelevant variables/variables with missingness:
  select(-video_id,
         -video_title,
         -channel_title,
         -subscribers,
         -comment_published_at,
         -view_count,
         -like_count,
         -comment_count,
         -video_published_at,
         -comment_type) |>
  # 3. move parent_comment_id to be behind comment_id
  select(comment_id, 
         parent_comment_id, 
         everything()) |> 
  # 4. mutate the "comment_length" categorical variable
  mutate(
    comment_length = case_when(
      word_count <= 15 ~ "Short",
      word_count <= 25 ~ "Medium",
      TRUE ~ "Long"),
    comment_length = as.factor(comment_length)) |> 
  # 5. move comment_length to be behind comment
  relocate(comment_length, 
           .after = word_count) 

write_csv(allies, "data/allies.csv")