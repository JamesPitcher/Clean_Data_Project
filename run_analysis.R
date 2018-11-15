
# Load packages.
library(dplyr)


# Set the file name.
filename <- "getdata_dataset.zip"


# Download the data if it doesn't exist.
if (!file.exists(filename)){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileUrl, filename)
} 


# Unzip the data if it doesn't already exist.
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}


# Read in the data.
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")


#------------------------------------------------------------------------------------------------------------
# 1. Merges the training and the test sets to create one data set.
#------------------------------------------------------------------------------------------------------------

# Combine all the training data.
Training_Data <- cbind(subject_train, x_train, y_train)

# Combine all the test data.
Test_Data <- cbind(subject_test, x_test, y_test)

# Combine the training and test data.
Combined_Data <- rbind(Training_Data, Test_Data)


# Delete old data frames to save memory
rm(subject_train, x_train, y_train, subject_test, x_test, y_test, Training_Data, Test_Data)


#------------------------------------------------------------------------------------------------------------
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
#------------------------------------------------------------------------------------------------------------

# Create a vector with the variable names for the features.
Variable_Names <- as.character(features[ , 2])

# Add variable names for subject and activity.
Variable_Names <- c("Subject", Variable_Names, "Activity")

# Apply the names to the data frame.
colnames(Combined_Data) <- Variable_Names

# Create a vector that stores the postions of the columns of the variable we want to keep.
My_Vars <- c(grep("Subject", names(Combined_Data)),
             grep("Activity", names(Combined_Data)),
             grep("mean", names(Combined_Data)),
             grep("std", names(Combined_Data)))

# Use the vector to subset the data.
Activity_Data <- Combined_Data[, My_Vars]


#------------------------------------------------------------------------------------------------------------
# 3. Uses descriptive activity names to name the activities in the data set.
#------------------------------------------------------------------------------------------------------------

# Concert the Activity variable to a factor.
Activity_Data$Activity <- as.factor(Activity_Data$Activity)

# Apply the activity names to the levels of the Activity variable.
levels(Activity_Data$Activity) <- activity_labels[ , 2]


#------------------------------------------------------------------------------------------------------------
# 4. Appropriately labels the data set with descriptive variable names.
#------------------------------------------------------------------------------------------------------------

# Extract the current column names into a vector.
Activity_Names <- colnames(Activity_Data)

# Clean up the names.
Activity_Names <- gsub("\\()", "", Activity_Names)
Activity_Names <- gsub("-", "_", Activity_Names)
Activity_Names <- gsub("^t", "TimeDomain", Activity_Names)
Activity_Names <- gsub("^f", "FrequencyDomain", Activity_Names)
Activity_Names <- gsub("meanFreq", "MeanFrequency", Activity_Names)
Activity_Names <- gsub("mean", "Mean", Activity_Names)
Activity_Names <- gsub("std", "StandardDeviation", Activity_Names)
Activity_Names <- gsub("Acc", "Accelerometer", Activity_Names)
Activity_Names <- gsub("Gyro", "Gyroscope", Activity_Names)
Activity_Names <- gsub("Mag", "Magnitude", Activity_Names)
Activity_Names <- gsub("BodyBody", "Body", Activity_Names)

# Apply the cleaned names to the data frame.
colnames(Activity_Data) <- Activity_Names


#------------------------------------------------------------------------------------------------------------
# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
#------------------------------------------------------------------------------------------------------------

# Group the data by subject and activity.
Activity_Summary <- group_by(Activity_Data, Subject, Activity)

# Extract the summary of means.
Results_Summary <- summarise_all(Activity_Summary, funs(mean))
   
# Write out the tidy data to a text file.      
write.table(Results_Summary, file = "tidy_data.txt", row.names = FALSE) 

