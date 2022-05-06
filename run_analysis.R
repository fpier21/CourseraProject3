
# libraries

library(dplyr)

# importing files 

test <- read.table('X_test.txt', sep= '')
test_labels <- read.table('y_test.txt', sep ='', col.names = 'activity')
train <- read.table('X_train.txt', sep = '')
train_labels <- read.table('y_train.txt', sep = '', col.names = 'activity')
conversion <- read.table('activity_labels.txt', sep = '')
features <- read.table('features.txt', sep = '')
subject_train <- read.table('subject_train.txt', sep ='', col.names = 'subject')
subject_test <- read.table('subject_test.txt', sep ='', col.names = 'subject')

# merging the data sets

test <- cbind(test,test_labels,subject_test)
train <- cbind(train,train_labels,subject_train)

mer_data <- rbind(test,train)

# extracting only columns relating to mean and and standard deviation in a new data frame

#making unique features' names
features_names <- make.names(features[,2], unique = T)

mean_std_dataset <- mer_data[,grepl('mean()', features_names) | grepl('std()', features_names)]

# descriptive activity names

mer_data$activity <- conversion[mer_data$activity,2]

#descriptive variable names

features_names <- gsub('^f', 'Frequency', features_names)
features_names <- gsub('^t', 'Time', features_names)
features_names <- gsub('Acc', 'Accelerometer', features_names)
features_names <- gsub('Mag', 'Magnitude', features_names)
features_names <- gsub('Gyro', 'Gyroscope', features_names)

names(mer_data) <- c(features_names, 'activity', 'subject')   

# new tidy data set

tidy_data <- summarize_all(group_by(mer_data, activity, subject), mean)



