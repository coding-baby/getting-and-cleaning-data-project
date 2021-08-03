### load library ###

library(tidyr)
library(dplyr)

### download and store zip file ###

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

if(!file.exists("./data"))
        {dir.create("./data")}

download.file(fileUrl,destfile="./data/Dataset.zip")
unzip(zipfile="./data/Dataset.zip",exdir="./data")

### read texts ###

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./data/UCI HAR Dataset/features.txt")
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

### rename colnames ###

colnames(x_train) <- features$V2
colnames(x_test) <- features$V2

colnames(y_train) <- "activity.id"
colnames(y_test) <- "activity.id"

colnames(subject_train) <- "subject.id"
colnames(subject_test) <- "subject.id"

colnames(activity_labels) <- c("activity.id","activity.type")

### merge all data ###

mg_train <- cbind(subject_train,x_train,y_train)
mg_test <- cbind(subject_test, x_test, y_test)
full_df <- rbind(mg_train, mg_test)

### select only subject id, activity id, mean, std ###

select_df <- full_df %>% select(subject.id, activity.id, contains("mean"), contains("std"))

### match activity id to activity & rename activity.id in select_df ###

select_df$activity.id <- activity_labels[select_df$activity.id,2]
names(select_df)[2] = "activity"

### change abbreviated names to full names ###

names(select_df) <- gsub("Acc","Accelerometer", names(select_df))
names(select_df) <- gsub("Gyro","Gyroscope", names(select_df))
names(select_df) <- gsub("BodyBody","Body", names(select_df))
names(select_df) <- gsub("Mag","Magnitude", names(select_df))
names(select_df) <- gsub("^t","Time", names(select_df))
names(select_df) <- gsub("^f","Frequency", names(select_df))
names(select_df) <- gsub("tBody","TimeBody", names(select_df))
names(select_df)<-gsub("-mean()", "Mean", names(select_df), ignore.case = TRUE)
names(select_df)<-gsub("-std()", "STD", names(select_df), ignore.case = TRUE)
names(select_df)<-gsub("-freq()", "Frequency", names(select_df), ignore.case = TRUE)
names(select_df)<-gsub("angle", "Angle", names(select_df))
names(select_df)<-gsub("gravity", "Gravity", names(select_df))

### group by suject.id and activity & average them ###

final_data <- select_df %>%
        group_by(subject.id, activity) %>%
        summarize_all(list(mean))
write.table(final_data, "final_data.txt", row.names = F)

