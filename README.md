UCI HAR Data Cleaning
=====================

This repo contains scripts (in R) used to prepare the [UCI HAR Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) for analysis. They  convert it into a tidy data set.

## Requirements

Create an R script that:

- Merges the training and the test sets to a single data set;
- Extracts measurements for the mean and standard deviation for each metric;
- Uses descriptive activity names to name the activities in the data set;
- Appropriately labels the data set with descriptive variable names;
- From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## R code

The R code that is used for analysis is available as [run_analysis.R](run_analysis.R).

```R
source("run_analysis.R")
```

The tidy data set can be loaded back into R using the following command

```R
tidy_data <- read.table("tidy_data.txt")
```

## Data CodeBook

The [codebook](CodeBook.md) available in this repo describes the variables, the data, the transformations that are done and the clean up that was performed on the data.