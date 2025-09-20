# Data Analyst Job Ranking

An R-based tool for scoring, ranking, and filtering job opportunities.  
It reads a sample job dataset, applies weighting functions (chance, wage, value, location), and produces priority rankings to help focus applications.

## Features
- **Custom weighting functions**: scale job attributes into a comparable priority score.
- **Baseline normalization**: jobs scored relative to a neutral reference case.
- **Ordered views**: sort applications by completion status, priority, and due date.
- **This week’s deadlines**: filter open, incomplete applications due within 7 days.

## Weighting System
- **Chance** estimates are intuitive, based mostly on vibes, with a baseline centered around ~17%.
- **Wage weights** are calculated relative to your current pay, prioritizing roles that are comparable to or above your existing salary.
- **Value scale** ranges from 1 (resume filler) to 3 or more (serious contribution), with exceptionally valuable roles scoring up to around 15.
- **Location weights** reflect whether a move would be required: Washington DC is weighted highest, Southern California and Remote options are slightly positive, and other locations are treated as neutral.

## Input
- Tab-delimited file at `data/sample_jobs_list.csv` with columns like:
  - `job__title`, `organization`, `due_date`, `min_wages`, `max_wages`,  
    `location`, `description`, `value`, `chance`, `completed`.

## Output
- `ordered_jobs`: full job list, sorted by status, priority, and deadline.  
- `due_soon`: subset of incomplete applications due within the next 7 days.

## Example Output

```r
ordered_jobs %>% head(3)
```

```
# A tibble: 3 × 11
  job__title        organization         due_date   min_wages … priority
  <chr>             <chr>                <date>          <dbl> … <dbl>
1 Policy Intern     Economic Research…   2025-10-15       28.0 … 1.20
2 Research Analyst  Social Impact Group  2025-09-18       43.0 … 1.35
3 Consulting Intern Analytics Partners   2026-02-11       30.0 … 1.05
```

## Usage
```r
# install dependencies if not already installed
install.packages(c("dplyr", "readr"))

# load script
source("job_applications_table.r")

# see all jobs in order
ordered_jobs

# see only jobs due soon
due_soon
```