# FUNCTION DESCRIPTION:
# Run_analysis requires the user to have the package DPLYR installed
# It reads data from files (see assumptions), combines and cleans the data, and 
# outputs it to tidyData.csv, which the activity, the subject, and the averages
# of the observations of mean and standard deviation
# ASSUMPTIONS: 
# The files are downloaded from the below URL to the working directory,
# and extracted as they are (i.e. creating a sub-folder called "/UCI HAR Dataset/")
# URL: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# OUTPUT: 
# "tidyMeasurements.csv" to current working directory

run_analysis <- function(){
     # Task 1: Merges the training and the test sets to create one data set
     
     # Reading files into dataframes
     yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", sep = "", 
                          na.strings = "N/A")
     xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt", na.strings = "N/A")
     yTest <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = "", 
                          na.strings = "N/A")
     xTest <- read.table("./UCI HAR Dataset/test/X_test.txt", na.strings = "N/A")
     
     trainSub <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = "")
     testSub <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = "")
     
     features <- read.table("./UCI HAR Dataset/features.txt", na.strings = "N/A")
     actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
     
     # Combining the test- and training dataframes by columns and rows
     dfTrain <- cbind(yTrain, xTrain)
     dfTest <- cbind(yTest, xTest)
     dfData <- rbind(dfTrain, dfTest)
     
     # Adding column names; activity id and features variables
     colnames(dfData) <- c("activityid", as.character(features[,2]))
     
     # Adding subject to table and labelling
     subjectDF <- rbind(trainSub, testSub)
     dfData <- cbind(subjectDF, dfData)
     colnames(dfData)[1] <- "subjectid"
     
     # Merging activity labels to complete the data set, adding label for activity name
     completeDF <- merge(actLabels, dfData, by.x = "V1", by.y = "activityid")
     colnames(completeDF)[2] <- "activity"
     

     # 2. Subsetting dataframe to only include measurements of "mean" and "std"
     # (standard deviation) in addition to the activity label and subject
     # 3 & 4: Descriptive activities and variable names already exist
     
     library(dplyr)
     firstDF <- select(completeDF, 2:3, contains("mean"), contains("std"))
     
     # 5. From the data set, creating a second, independent data set with the average
     # of each variable for each activity and each subject
     
     # Creating data frame with average of mean and average of stdev
     avgData <- mutate(firstDF, avgmean = rowMeans(select(firstDF, contains("mean"))),
                       avgstdeviation = rowMeans(select(firstDF, contains("std"))))
     
     # Creating the tidy data frame grouped by activity and subject, summarised with 
     # the average of the mean and the average of the stdev
     tidyMeasurements <- avgData %>%
          select(activity, subjectid, avgmean, avgstdeviation) %>%
          group_by(activity, subjectid) %>%
          summarize(avgmean = mean(avgmean),
                    avgstdeviation = mean(avgstdeviation)) %>%
          arrange(activity)
     
     # Exporting the tidy dataframe as csv
     write.table(tidyMeasurements,"tidyMeasurements.csv",sep=",",row.names=FALSE)
     
}