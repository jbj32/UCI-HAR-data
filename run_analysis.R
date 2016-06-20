library(dplyr)
library(tidyr)
library(stringr)

base_directory = "UCI HAR Dataset/"

# Two helper functions for reading the data from files
read_har_data <- function(filename, ...) {
  paste(base_directory, filename, sep = "") %>%
  read.table(...) %>%
  tbl_df() 
}

read_features_and_labels <- function(data_set_type) {
  get_filename <- function(prefix) {
    paste(data_set_type,"/",prefix,"_",data_set_type,".txt",sep="")
  }
  
  feature_filename <- get_filename(prefix = "X")
  label_filename <- get_filename(prefix = "y")
  subject_filename <- get_filename(prefix = "subject")
  
  cbind(read_har_data(subject_filename, colClasses = "integer"),
        read_har_data(label_filename, colClasses = "integer"),
        read_har_data(feature_filename, colClasses = "numeric")
  )
}

# Auxiliary data sets used for tidying
feature_names <- read_har_data("features.txt", col.names = c("n", "name"), colClasses = "character")
label_factors <- read_har_data("activity_labels.txt", col.names = c("label", "state"), colClasses = c("integer", "character"))

# Read the raw data into a plyr table, extracting just the mean() and std() variables
raw_data <- tbl_df(rbind(read_features_and_labels("test"), read_features_and_labels("train")))
names(raw_data) <- append(c("subject_ID", "label"), feature_names$name)
raw_data <- raw_data[!duplicated(names(raw_data))]
raw_data <- select(raw_data, matches("subject_ID|label|-mean\\(\\)|-std\\(\\)"))

# Tidy the data, separating variables and renaming for clarity
input_pattern <- "(^[t|f])([A-Z][a-z]+)([A-Z][a-z]+)"
tidy_data <-  raw_data %>%
              gather(key, value, -subject_ID, -label) %>%
              separate(key, c("input", "aggregate", "axis")) %>%
              mutate(input = str_replace(input, input_pattern, "\\1-\\2-\\3")) %>%
              separate(input, c("domain", "source", "metric")) %>%
              mutate(domain = str_replace(domain, "t", "time")) %>%
              mutate(domain = str_replace(domain, "f", "freq")) %>%
              right_join(tbl_df(label_factors), by="label") %>%
              select(-label)