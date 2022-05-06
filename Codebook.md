---
title: "Codebook for the Project"
author: "F. Pierpaoli"
date: "`r Sys.Date()`"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Introduction

The R script run_analysis.R in the Repo performs the operations described in the Coursera site for the project and explicitly reported in the README file. This Codebook comments on the operations by describing the trasformations and the variables employed in the script. The dataset we worked on was the UCI HAR Dataset.

## 1. Merges the training and the test sets to create one data set. 

We download the files

```{r}
filename <- "Coureproject.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
```

We import all the meaningful files for the dataset with function `read.table`. Also, we rename columns if needed.

```{r}
test <- read.table('UCI HAR Dataset/test/X_test.txt', sep= '')
test_labels <- read.table('UCI HAR Dataset/test/y_test.txt', sep ='', col.names = 'activity')
train <- read.table('UCI HAR Dataset/train/X_train.txt', sep = '')
train_labels <- read.table('UCI HAR Dataset/train/y_train.txt', sep = '', col.names = 'activity')
conversion <- read.table('UCI HAR Dataset/activity_labels.txt', sep = '')
features <- read.table('UCI HAR Dataset/features.txt', sep = '')
subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt', sep ='', col.names = 'subject')
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt', sep ='', col.names = 'subject')
```

We merge the datasets with `rbind` and `cbind`into the dataset `mer_data.`

```{r}

test <- cbind(test,test_labels,subject_test)
train <- cbind(train,train_labels,subject_train)

mer_data <- rbind(test,train)
```

The final dataset `mer_data` has 10299 obs. for 563 variables, of which 561 are features and the last two columns indicate activities and subjects' IDs.

## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

First of all, as some features' names are equal, we make unique names with function `make.names.`

```{r}
#making unique features' names
features_names <- make.names(features[,2], unique = T)
```

Then, we initialize a new dataset `mean_std_dataset` with only the measurements on the mean and standard deviation: to do that we look for strings 'mean()' and 'std()' with `grepl`.

```{r}
mean_std_dataset <- mer_data[,grepl('mean()', features_names) | grepl('std()', features_names)]
```

The dataset `mean_std_dataset` has 10299 observations and 81 variables, corresponding to the mean and standard deviation of each measurement.

## 3.Uses descriptive activity names to name the activities in the data set

We exploit the file 'activity_labels.txt' which provides a conversion between numerical labels from 0 to 6 and descriptive activity names. The file was imported in data frame `conversion`.

```{r}
mer_data$activity <- conversion[mer_data$activity,2]
```

## 4. Appropriately labels the data set with descriptive variable names.

We give to the features descriptive names as indicated in file 'features_info.txt' in the UCI HAR dataset, by exploiting the text-editor function `gsub`.

```{r}
features_names <- gsub('^f', 'Frequency', features_names)
features_names <- gsub('^t', 'Time', features_names)
features_names <- gsub('Acc', 'Accelerometer', features_names)
features_names <- gsub('Mag', 'Magnitude', features_names)
features_names <- gsub('Gyro', 'Gyroscope', features_names)

names(mer_data) <- c(features_names, 'activity', 'subject')   
```

## 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Finally we create the dataset `tidy_data` which summarizes the average of each feature variable grouped by activity and subject.

```{r}
library(dplyr)
tidy_data <- summarize_all(group_by(mer_data, activity, subject), mean)
```

## 

## 

