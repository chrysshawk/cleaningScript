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
     tidyDF <- cbind(dfData[1], obsmean, obsssdev)
     
     # 3. Use descriptive activity names to name the activities in the data set
     actLabels <- read.table("./UCI HAR Dataset/activity_labels.txt")
     colnames(actLabels) <- c("actid", "actlabel")
     
     # Merging activity labels into dfData
     tidyDF <- merge(actLabels, tidyDF, by.x = "actid", by.y = "V1")
     # Dropping the activity id
     tidyDF <- tidyDF[-1]
     
     # 4. Appropriately label the data set with descriptive variable names

     # 5. From (4), create a second, independent data set with the average
     # of each variable for each activity and each subject
     
     
     
}