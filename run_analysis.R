setwd("C:\\Users\\mihaldma\\Documents\\R\\UCI HAR Dataset\\")

library(dplyr)

## STEP_1: Merges the training and the test sets to create one data set.

# Get_data_if_not_exists

if(!file.exists("UCI HAR Dataset")){
  download.file("http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile = "data.zip")  
  unzip("data.zip")
  file.remove("data.zip")
}

# load_activity_labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activity_labels) <- c("id","name")

# load_description_of_feature vector
features <- read.table("UCI HAR Dataset/features.txt")
names(features) <- c("id","name")

# load_train_activities_subjects_measures
train.activities <- read.table("UCI HAR Dataset/train/y_train.txt")
train.subjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train.measures <- read.table("UCI HAR Dataset/train/X_train.txt")

# load_test_activities_subjects_measures
test.activities <- read.table("UCI HAR Dataset/test/y_test.txt")
test.subjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test.measures <- read.table("UCI HAR Dataset/test/X_test.txt")

# bind_train&test_activities_set_name_for_activity_variable
activities <- bind_rows(train.activities,test.activities)
rm("train.activities","test.activities")
names(activities) <- c("activity")

# bind_train&test_subjects_set_name_for_subject_variable
subjects <- bind_rows(train.subjects,test.subjects)
rm("train.subjects","test.subjects")
names(subjects) <- c("subject")

# bind_train&test measures
measures <- bind_rows(train.measures,test.measures)
rm("train.measures","test.measures")



## STEP 2:Extracts only the measurements on the mean and standard deviation for each measurement.

# find_positions_of_mean&standard deviation_variables_in_feature_vector
features.reduced.logical <- grepl(pattern = "mean|std", features$name)

# select_subset_of_variables&add_names_to_variables
measures.reduced <- select(measures,which(features.reduced.logical))




## STEP 3: Uses descriptive activity names to name the activities in the data set.

activities$activity <- factor(activities$activity, levels = activity_labels$id, labels = activity_labels$name)



## STEP 4:  Appropriately labels the data set with descriptive variable names => "tidy" format. 


# get_names_of_mean&standard_deviation_related_variables
features.reduced.names <- grep(pattern = "mean|std", features$name, value = TRUE)

# convert_official_names_to_something_more_"tidy"
features.reduced.names <- gsub("\\(\\)", "", features.reduced.names)
features.reduced.names <- gsub("^t", "time", features.reduced.names)
features.reduced.names <- gsub("^f", "freq", features.reduced.names)
features.reduced.names <- gsub("-", ".", features.reduced.names)
features.reduced.names <- tolower(features.reduced.names)

names(measures.reduced) <- features.reduced.names



## STEP 5: From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject

# bind_activity_subjects&reduces_measures_into_one_set
dataset <- bind_cols(activities, subjects, measures.reduced)

# group_by_activity&subject
dataset.group <- group_by(dataset, activity, subject)

# calculate_average_values_for_each_activity&subject
dataset.group.summary <- summarise_all(dataset.group,funs(mean))

# write_to_file
write.table(dataset.group.summary,file="uci_har_dataset.txt",row.names = FALSE)
