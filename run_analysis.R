test <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
train <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
combined_data <- rbind(test, train)
rm(test, train)

test_activity <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
train_activity <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
combined_activity <- rbind(test_activity, train_activity)
rm(test_activity, train_activity)

test_subjects <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)
train_subjects <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)
combined_subjects <- rbind(test_subjects, train_subjects)
rm(test_subjects, train_subjects)

column_labels <- read.table("UCI HAR Dataset/features.txt", header = FALSE)
new_names <- make.unique(as.character(column_labels$V2), sep = ".")
colnames(combined_data) <- new_names
colnames(combined_subjects) <- "subject"
colnames(combined_activity) <- "activity"
rm(column_labels, new_names)

sel_mean <- dplyr::select(combined_data, contains("mean()"))
sel_std <- dplyr::select(combined_data, contains("std()"))
selected_data <- cbind(sel_mean, sel_std)
data <- cbind(combined_subjects, combined_activity, selected_data)
rm(selected_data, sel_std, sel_mean, combined_subjects, combined_activity, combined_data)

activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header = FALSE, stringsAsFactors = FALSE)
data$activity <- plyr::mapvalues(data$activity, activity_labels$V1, activity_labels$V2)

n <- names(data)
n <- sub("tBody", "timeBody", n, fixed = TRUE)
n <- sub("fBody", "frequencyBody", n, fixed = TRUE)
n <- sub("tGravity", "timeGravity", n, fixed = TRUE)
n <- gsub("mean", "Mean", n, fixed = TRUE)
n <- gsub("std", "Std", n, fixed = TRUE)
n <- gsub("()", "", n, fixed = TRUE)
n <- gsub("-", "", n, fixed = TRUE)
names(data) <- n

library(dplyr)
result <- summarize_each(group_by(data, activity, subject), funs(mean))
write.table(result, "result.txt", row.names = FALSE)