
# libraries

library(dplyr)

#downloading files 

filename <- "Coureproject.zip"

# checking if the archieve already exists
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(fileURL, filename, method="curl")
}  

# checking if folder already exists
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}

# importing files

# making unique names for the features 

features <- read.table('UCI HAR Dataset/features.txt', sep = '')
features$V2 <- make.names(features$V2, unique = T) 

test <- read.table('UCI HAR Dataset/test/X_test.txt', sep= '', col.names = features$V2)
test_labels <- read.table('UCI HAR Dataset/test/y_test.txt', sep ='', col.names = 'activity')
train <- read.table('UCI HAR Dataset/train/X_train.txt', sep = '', col.names = features$V2)
train_labels <- read.table('UCI HAR Dataset/train/y_train.txt', sep = '', col.names = 'activity')

conversion <- read.table('UCI HAR Dataset/activity_labels.txt', sep = '')

subject_train <- read.table('UCI HAR Dataset/train/subject_train.txt', sep ='', col.names = 'subject')
subject_test <- read.table('UCI HAR Dataset/test/subject_test.txt', sep ='', col.names = 'subject')

# merging the data sets

test <- cbind(test,test_labels,subject_test)
train <- cbind(train,train_labels,subject_train)

mer_data <- rbind(test,train)

# extracting only columns relating to mean and and standard deviation

features_names <- features$V2[grepl('mean()', features$V2) | grepl('std()', features$V2)]
mer_data <- mer_data[,c(features_names, 'activity', 'subject')]


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
write.table(tidy_data, row.names = F, file = 'tidy_data_set.txt')
