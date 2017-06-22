
library(tidyverse)

# create x,y and subject data sets
X_test <- read.table( "./test/X_test.txt",  sep = "", quote = "\"'",  skip = 0, stringsAsFactors = FALSE) 
y_test <- read.table( "./test/y_test.txt",  sep = "", quote = "\"'",  skip = 0, stringsAsFactors = FALSE) 
subject_test <- read.table( "./test/subject_test.txt",  sep = "", quote = "\"'",  skip = 0, stringsAsFactors = FALSE) 

X_train <- read.table( "./train/X_train.txt",  sep = "", quote = "\"'",  skip = 0, stringsAsFactors = FALSE) 
y_train <- read.table( "./train/y_train.txt",  sep = "", quote = "\"'",  skip = 0, stringsAsFactors = FALSE) 
subject_train <- read.table( "./train/subject_train.txt",  sep = "", quote = "\"'",  skip = 0, stringsAsFactors = FALSE) 

y_data <- rbind(y_train, y_test)
x_data <- rbind(X_train, X_test)

subject_data <- rbind(subject_train, subject_test)


# get only columns with mean or std
features <- read.table( "./features.txt",  sep = "", quote = "\"'",  skip = 0, stringsAsFactors = FALSE) 
mean_std_features <- grep("-(mean|std)\\(\\)", features[, 2])

# subset the mean- and std-columns and create column names
x_data <- x_data[, mean_std_features]
names(x_data) <- features[mean_std_features, 2]

names(subject_data) <- "subject"

# update activity names
activities <- read.table( "./activity_labels.txt",  sep = "", quote = "\"'",  skip = 0, stringsAsFactors = FALSE)
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"

# create a data set with all datas
total <- cbind(x_data, y_data, subject_data)

# Create a second, independent tidy data set with the average of each variable
# for each activity and each subject
averages_data <- total %>% group_by(subject, activity) %>% summarise_each(funs(mean))
write.table(averages_data, "averages_data.txt", row.name = FALSE)