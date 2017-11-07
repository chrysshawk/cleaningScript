# setwd("F:/Work documents/R/GitHub/CleaningProject/")

run_analysis <- function(){
     # 1. Merge the training and the test data sets
     
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

     # 2. Extract only the measurements on the mean and standard deviation
     # for each measurement
     obsmean <- apply(dfData[,2:ncol(dfData)], 1, mean)
     obssdev <- apply(dfData[,2:ncol(dfData)], 1, sd)
     
     # Creating new tidy dataframe
     obsDF <- cbind(dfData[1], obsmean, obssdev)
     
     # 3. Use descriptive activity names to name the activities in the data set
     actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
     colnames(actLabels) <- c("actid", "activity")
     
     # Merging activity labels into dfData (avoiding sorting) & dropping the activity id
     obsDF <- merge(obsDF, actLabels, by.x = "V1", by.y = "actid", sort = FALSE)
     obsDF <- obsDF[-1]
     
     # 4. Appropriately label the data set with descriptive variable names
     # ...Already done

     # 5. From (4), create a second, independent data set with the average
     # of each variable for each activity and each subject
     
     # Loading the subject data into the data frame and formatting
     trainSub <- read.table("./UCI HAR Dataset/train/subject_train.txt", sep = "")
     testSub <- read.table("./UCI HAR Dataset/test/subject_test.txt", sep = "")
     subDF <- rbind(trainSub, testSub)
     completeDF <- cbind(subDF, obsDF)
     colnames(completeDF)[1] <- "subjectid"
     
     # Adding column with average
     tDF <- mutate(completeDF, mean(completeDF$obsmean+completeDF$obssdev))
     
     # Using DPLYR to create the new data set
     library(dplyr)
     
     # this is correct according to excel:
     # tidyData <- completeDF %>%
     #     group_by(activity, subjectid) %>%
     #     summarize(avg = mean((obsmean+obssdev)/2)) %>%
     #     arrange(activity)
     
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