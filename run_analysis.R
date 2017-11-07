# Run_analysis is a function requiring the user to have installed the packages DPLYR
# It reads data from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>, 
# combines and cleans the data, and outputs it to tidyData.csv,
# which contains the variables activity, subjectid, avgmean, and avgsdev

run_analysis <- function(){
     # 1. Merging the training and the test data sets
     
     # Reading Train - and Test files
     yTrain <- read.table("./UCI HAR Dataset/train/y_train.txt", sep = "", 
                          na.strings = "N/A")
     xTrain <- read.table("./UCI HAR Dataset/train/X_train.txt", na.strings = "N/A")
     yTest <- read.table("./UCI HAR Dataset/test/y_test.txt", sep = "", 
                          na.strings = "N/A")
     xTest <- read.table("./UCI HAR Dataset/test/X_test.txt", na.strings = "N/A")
     
     # Adding the Y columns to tables, and merging the tables into dfData
     dfTrain <- cbind(yTrain, xTrain)
     dfTest <- cbind(yTest, xTest)
     dfData <- rbind(dfTrain, dfTest)

     # 2. Extracting measurements on the mean and standard deviation
     obsmean <- apply(dfData[,2:ncol(dfData)], 1, mean)
     obssdev <- apply(dfData[,2:ncol(dfData)], 1, sd)
     
     # Creating new data frame with activity, obsmean, and obssdev
     obsDF <- cbind(dfData[1], obsmean, obssdev)
     
     # 3. Use descriptive activity names to name the activities in the data set
     actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
     colnames(actLabels) <- c("actid", "activity")
     
     # Merging activity labels into obsDF & dropping the activity id
     obsDF <- merge(obsDF, actLabels, by.x = "V1", by.y = "actid", sort = FALSE)
     obsDF <- obsDF[-1]
     
     # 4. Data set is already labeled with appropriate variable names

     # 5. From (4), creating a second, independent data set with the average
     # of each variable for each activity and each subject
     
     # Reading and including the subject data into the data frame and formatting
     trainSub <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = "")
     testSub <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = "")
     subDF <- rbind(trainSub, testSub)
     completeDF <- cbind(subDF, obsDF)
     colnames(completeDF)[1] <- "subjectid"
     
     # Loading DPLYR for subsequent operations
     library(dplyr)
     
     # Grouping activity and subjectid to calculate mean of observation mean and mean of
     # standard deviation mean
     tidyData <- completeDF %>%
          group_by(activity, subjectid) %>%
          summarize(avgmean = mean(obsmean),
                    avgsdev = mean(obssdev)) %>%
          arrange(activity)
     
     # Exporting table as csv
     write.table(tidyData,"tidyData.csv",sep=",",row.names=FALSE)     
}
