### Getting and Cleaning Data ####

### Download, Unzip and Import Data ###

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dest <- paste0(getwd(), "/dataset.zip")
download.file(url, dest)
unzip("dataset.zip")

setwd("~/Desktop/00. Date Science/3.  Getting and Cleaning Data/UCI HAR Dataset")

features <- read.table("features.txt", col.names = c("n","functions"))
activities <- read.table("activity_labels.txt", col.names = c("code", "activity"))

subject_test <- read.table("test/subject_test.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")

subject_train <- read.table("train/subject_train.txt",col.names = "subject")
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

### Merge Datasets ###

subject <- rbind(subject_test,subject_train)
x <- rbind(x_test, x_train)
y <- rbind(y_test, y_train)
merged_data <- cbind(subject,x, y)

View(merged_data)

### Mean and Standard Deviation ###
library(dplyr)

measurements <- merged_data %>% select(subject, code, contains("mean"), contains("std") )
measurements$code <- activities[measurements$code,2]

### Rename Labels ###

names(measurements)[2] = "activity"
names(measurements)<-gsub("Acc", "Accelerometer", names(measurements))
names(measurements)<-gsub("Gyro", "Gyroscope", names(measurements))
names(measurements)<-gsub("BodyBody", "Body", names(measurements))
names(measurements)<-gsub("Mag", "Magnitude", names(measurements))
names(measurements)<-gsub("^t", "Time", names(measurements))
names(measurements)<-gsub("^f", "Frequency", names(measurements))
names(measurements)<-gsub("tBody", "TimeBody", names(measurements))
names(measurements)<-gsub("-mean()", "Mean", names(measurements), ignore.case = TRUE)
names(measurements)<-gsub("-std()", "STD", names(measurements), ignore.case = TRUE)
names(measurements)<-gsub("-freq()", "Frequency", names(measurements), ignore.case = TRUE)
names(measurements)<-gsub("angle", "Angle", names(measurements))
names(measurements)<-gsub("gravity", "Gravity", names(measurements))

### final dataset ###
dataframe<- measurements %>%
    group_by(subject, activity) %>%
    summarise_all(funs(mean))
write.table(dataframe, "dataframe.txt")

