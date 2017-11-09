# CodeBook

## Input
The original data files are found at below URL. The assumption is that the user downloads and extracts this in the working directory.
* URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
* Dataset description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The raw data required is separated in multiple files, therefore the first task is to combine this in a sensible manner. From the Readme.txt, we can s

- 'features_info.txt': Shows information about the variables used on the feature vector.
- 'features.txt': List of all features.
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

## Transformation

With the zip archive extracted, the script reads data from these files:
* "/UCI HAR Dataset/train/y_train.txt"
* "/UCI HAR Dataset/train/X_train.txt"
* "/UCI HAR Dataset/test/y_test.txt"
* "/UCI HAR Dataset/test/X_test.txt"
* "/UCI HAR Dataset/train/subject_train.txt"
* "/UCI HAR Dataset/test/subject_test.txt"
* "/UCI HAR Dataset/features.txt"
* "/UCI HAR Dataset/activity_labels.txt"

1. Files are combined into one data set
* y_train is added as column to X_train
* y_test is added as column to X_test
* these rows are combined
* subject_train and subject_test are added as columns
* activity_labels are merged with table (based on activity ID) so each activity is given a meaningful name
* Additionally, the features data are assigned to the respective column names for the observations in the table

2. Operations are performed on data
* Columns of subject, activity, and all columns containing the words "mean" and "std" (standard deviation) are extracted to new table
* 2 new calculated variables are added per row, row average of the "mean" variables, and row average of the "std" variables
* A new table is created, containing only the activity (name), the subject id, and the average of the means and the average of the std (standard deviation) variables. These are grouped by activity and subject id, and sorted by activity.

3. This resulting table is exported to file "tidyData.csv".

## Output
The output is "tidyData.csv".
* Dimensions: 4 columns, 180 rows
..* Columns: "activity" "subjectid" "avgmean" "avgstd"
..* activity : Factor w/ 6 levels.
..* subjectid: int  1 2 3 4 5 6 7 8 9 10 ...
..* avgmean  : num  -0.287 -0.282 -0.294 -0.304 -0.289 ...
..* avgstd   : num  -0.897 -0.98 -0.974 -0.961 -0.973 ...
