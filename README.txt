
#------------------------------------------------------------------------------------------------------------
# Getting and Cleaning Data Course Project
# James Pitcher, November 2018
#------------------------------------------------------------------------------------------------------------

#------------------------------------------------------------------------------------------------------------
# The dataset includes the following files:
#------------------------------------------------------------------------------------------------------------
- 'README.txt': This file.
- 'tidy_data.txt': Tidied data set.
- 'CodeBook.txt': Shows information about the variables in 'tidy_data.txt'.
- 'run_analysis.R': R script used to produce 'tidy_data.txt'.

#------------------------------------------------------------------------------------------------------------
# The 'run_analysis.R' R script does the following:
#------------------------------------------------------------------------------------------------------------
- Downloads and unzips the source data if it does not already exist in the working directory.
- Reads in the data.
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set.
- Appropriately labels the data set with descriptive variable names.
- Creates a second, independent tidy set with the average of each variable for each activity and each subject.
- Writes out the second tidy data set to 'tidy_data.txt'.