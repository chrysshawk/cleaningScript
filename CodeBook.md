# CodeBook

## Input
The original data files are found at below URL. The assumption is that the user downloads and extracts this in the working directory.
* URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* Dataset description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

With the zip archive extracted, the script reads data from these files:
* "/UCI HAR Dataset/train/y_train.txt"
* "/UCI HAR Dataset/train/X_train.txt"
* "/UCI HAR Dataset/test/y_test.txt"
* "/UCI HAR Dataset/test/X_test.txt"
* "/UCI HAR Dataset/train/subject_train.txt"
* "/UCI HAR Dataset/test/subject_test.txt"
* "/UCI HAR Dataset/features.txt"
* "/UCI HAR Dataset/activity_labels.txt"

## Transformation
1. Files are combined into one table
--1. y_train is added as column to X_train
--2. y_test is added as column to X_test
--3. these rows are combined
--4. subject_train and subject_test are added as columns
--5. activity_labels are merged with table (based on activity ID)

2. Operations are executed on combined table
--1. Columns on subject, activity, and all columns containing the words "mean" and "std" (standard deviation) are extracted to new table
--2. 2 new calculated variables are added per row, row average of the "mean" variables, and row average of the "std" variables
--3. A new table is created, containing only the activity (name), the subject id, and the average of the means and the average of the std (standard deviation) variables. These are grouped by activity and subject id, and sorted by activity.

3. This resulting table is exported to file "tidyData.csv".

## Output
The output is "tidyData.csv":
* Columns: "activity" "subjectid" "avgmean" "avgstd"
* Dimensions: 4 columns, 180 rows
* str(tidyData)
* Classes ‘grouped_df’, ‘tbl_df’, ‘tbl’ and 'data.frame':	180 obs. of  4 variables:
** $ activity : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
** $ subjectid: int  1 2 3 4 5 6 7 8 9 10 ...
** $ avgmean  : num  -0.287 -0.282 -0.294 -0.304 -0.289 ...
** $ avgstd   : num  -0.897 -0.98 -0.974 -0.961 -0.973 ...
