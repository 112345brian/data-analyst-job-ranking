# Data Analyst Job Ranking

An R-based tool for scoring, ranking, and filtering job opportunities.  
It reads a sample job dataset, applies weighting functions (chance, wage, value, location), and produces priority rankings to help focus applications.

## Features
- **Custom weighting functions**: scale job attributes into a comparable priority score.
- **Baseline normalization**: jobs scored relative to a neutral reference case.
- **Ordered views**: sort applications by completion status, priority, and due date.
- **This week’s deadlines**: filter open, incomplete applications due within 7 days.

## Input
- Tab-delimited file at `data/sample_jobs_list.csv` with columns like:
  - `job__title`, `organization`, `due_date`, `min_wages`, `max_wages`,  
    `location`, `description`, `value`, `chance`, `completed`.

## Output
- `ordered_jobs`: full job list, sorted by status, priority, and deadline.  
- `due_soon`: subset of incomplete applications due within the next 7 days.

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