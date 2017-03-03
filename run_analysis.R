# Getting and cleaning data - assignment
# Set working directory 
setwd("~./My Project Final")
library(dplyr)
if (!file.exists("./data")) {
    dir.create("./data")
}
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
f1 <- file.path(getwd(), "./data/Dataset.zip")
download.file(fileURL, f1, mode = "wb")
unzip("./data/Dataset.zip", exdir = "./data")

# reading data description
variable_names <- read.table("./data/UCI HAR Dataset/features.txt")

# reading activity labels
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# reading test data
X_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
Y_test <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
Sub_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# reading train data
X_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Y_train <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
Sub_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# 1. Merging the 'training' and the 'test' sets to create one data sets
X_total <- rbind(X_train, X_test)
Y_total <- rbind(Y_train, Y_test)
Sub_total <- rbind(Sub_train, Sub_test)

# 2. Extracts only the measurements on the 'mean' and 'standard deviation' for each 'measurement'
selected_var <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
X_total <- X_total[,selected_var[,1]]

# 3. Uses descriptive 'activity names' to name the 'activities' in the data set
colnames(Y_total) <- "activity"
Y_total$activitylabel <- factor(Y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- Y_total[,-1]

# 4. Appropriately labels the data set with descriptive variable names
colnames(X_total) <- variable_names[selected_var[,1],2]

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject
colnames(Sub_total) <- "subject"
total <- cbind(X_total, activitylabel, Sub_total)
total_avg <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_avg, "tidydata.txt", row.names = FALSE, col.names = TRUE)
