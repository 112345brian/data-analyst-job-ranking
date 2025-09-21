rm(list = ls())

# dependencies
library(dplyr)
library(readr)
library(here)
here::i_am("job_applications_table.r")
jobs <- read_csv(here("data", "sample_jobs_list.csv"))


# create columns

## create med_chance
# jobs <- jobs %>%
#   rowwise() %>%
#   mutate(med_chance = median(c(min_chance, max_chance), na.rm = TRUE)) %>%
#   ungroup() %>%
#   relocate(med_chance, .after = max_chance)

chance_weight <- function(chance) {
  # p is probability in 0–1 (e.g., 0.30 for 30%)
  chance_percent <- chance / 100
  weight <- 0.66 + 0.64 / (1 + exp(-12.8 * (chance_percent - 0.17)))
  return(pmin(pmax(weight, .75), 1.4))
  
}

wage_weight <- function(wage = 0) {
  weight <- -0.00197 * wage^2 + 0.1636 * wage - 2.076
  
  # clamp between 0.4 and 1.4
  weight <- pmax(0.4, pmin(weight, 1.4))
  
  return(weight)
}

value_weight <- function(value) {
  1.87 / (1 + exp(-0.15 * (value - 1.84)))
}

location_weight <- function(location) {
  ifelse(location == "DC", 1.2,
         ifelse(location %in% c("SoCal", "Remote"), 1.1, 1.0))
}

baseline_values <- tibble(
  chance = 30,      # 30% chance
  value = 3,        # baseline value
  wage = 30,        # "neutral" wage
  location = "Other" # neutral location
)

baseline_priority <- with(baseline_values,
                          chance_weight(chance) *
                            value_weight(value) *
                            wage_weight(wage) *
                            location_weight(location)
)

jobs <- jobs %>%
  mutate(priority = round(
    (chance_weight(chance) *
       value_weight(value) *
       wage_weight(min_wages) *
       location_weight(location)) / baseline_priority,
    3
  ))

# ordered view as new dataframe
view_order <- function(df = jobs) {
  df %>%
    arrange(coalesce(completed, FALSE), desc(priority), due_date)
}

# jobs due this week as new dataframe
this_week <- function(df = jobs) {
  today <- Sys.Date()
  df %>%
    arrange(coalesce(completed, FALSE), desc(priority), due_date) %>%
    filter(!coalesce(completed, FALSE),
           !is.na(due_date),
           due_date >= today,
           due_date <= today + 7)
}

# create new dataframes
ordered_jobs <- view_order(jobs)
due_soon     <- this_week(jobs)

