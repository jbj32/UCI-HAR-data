CodeBook for Tidy UCI HAR Dataset
=================================

## What is it?

This CodeBook describes the data contained in the output of the `run_analysis.R` script.

```R
tidy_data <- data.table("tidy_data.txt")
```

The script generates a combined subset of the original data by extracting the mean and standard deviation features for each of the 33 processed signals, for a total of 66 features (out of the 561 available features from the original feature vector). This combined subset contains 10299 observations of 68 variables, with activity and subject appended to the 66 features.

The combined subset is further reduced by calculating the mean of the observations by activity and subject pair to generate 180 observations (6 activities * 30 subjects) of the same 68 variables. This dataset is tidied to generate a narrow and lean dataset containing 11880 observations with 4 variables each and is saved as a text file in the current working directory with the name `tidy_data.txt`

## Variable name cleanup

As part of the tidying process the variable names are cleaned up using the following transformations.

- Variables are collected using `gather(key, value, -subject_ID, -label)`
- The variable fields are split using `separate(key, c("input", "aggregate", "axis"))`
- The measurement field names are separated into three variables: the domain (time or frequency), the source (e.g. Body) and the metric itself (e.g. Acceleration). This is done using: `mutate(input = str_replace(input, input_pattern, "\\1-\\2-\\3")) %>%
              separate(input, c("domain", "source", "metric")) %>%
              mutate(domain = str_replace(domain, "t", "time")) %>%
              mutate(domain = str_replace(domain, "f", "freq"))`
- Lastly, the states ('WALKING', etc.) are attached to the data set: `right_join(tbl_df(label_factors), by="label")`

## Description of the UCI HAR variables

The Tidy dataset consists of 11880 observations summarized by subject, state, domain, source, metric, aggregation (mean/std) and axis (X, Y, Z).

### subject

A numeric identifier (1-30) of the subject who carried out the experiment.

### activity

The activity name with the following possible values.
- 'LAYING',
- 'SITTING',
- 'STANDING',
- 'WALKING',
- 'WALKING_DOWNSTAIRS'
- 'WALKING_UPSTAIRS'

### domain

Indicates whether the measurement is for either the time or frequency domain.

### source

Indicates the source of the data, either body or gravity.

### metric

Indicated which metric is measured:
- Acc
- AccJerk
- AccMag
- BodyAccJerkMag
- BodyGyroJerkMag
- BodyGyroMag
- Gyro
- AccJerkMag
- GyroJerk
- GyroJerkMag
- GyroMag

### aggregate

Indicates whether the mean of standard deviation (std) measurements are the ones being aggregated

### axis

Indicates the X, Y, or Z axis.


### value

The mean of the measurments grouped by the preceding seven fields.