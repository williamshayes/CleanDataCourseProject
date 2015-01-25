## Getting and Cleaning Data - Course Project
##
## This R script will take data supplied by the UCI Machine Learning Repository
## describing people engaged in various activities with a smartphone wearable
## monitoring system.
##
## This script will take the following steps.
## 0. a) Loads requisite libraries data.table and reshape2
##    b) Retrieve the data from the remote source and 
##    c) load the data pieces into specific R data objects for later use 
## 1. Merge the training and the test sets to create one data set.
## 2. Extract only the measurements on the mean and standard deviation for each 
##    measurement. 
## 3. Uses descriptive activity names to name the activities in the data set.
## 4. Appropriately label the data set with descriptive variable names. 
## 5. From the data set in step 4, create a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.

## Final output written to current working directory .txt file called:
## UCI_HAR_Dataset_tidy_data.txt with no row names.

## Assumes 
## 1. Working directory has been set to directory final results should be
##    written too.


## 0(a). Install packages which will be used below are available and installed.
packages <- c("data.table", "reshape2")
if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
    install.packages(setdiff(packages, rownames(installed.packages())))  
}
library(data.table)
library(reshape2)

## 0(b). Download and stage the data supplied.
fileURL<-paste("https://d396qusza40orc.cloudfront.net/",
               "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
               sep="")
download.file(fileURL, "UCI_HAR_Dataset.zip")
unzip("UCI_HAR_Dataset.zip")
files <- list.files("UCI HAR Dataset", full.names=TRUE, recursive=TRUE)
UCI_HAR_Dataset.download.date <- Sys.time()
UCI_HAR_Dataset.download.date

## 0(c). Load data from needed files into data frames for later use.
## Get the full file names for all needed tables
activityFile     <- grep("activity",      files, value=TRUE)
xTestFile        <- grep("/X_test",       files, value=TRUE)
yTestFile        <- grep("/y_test",       files, value=TRUE)
xTrainFile       <- grep("/X_train",      files, value=TRUE)
yTrainFile       <- grep("/y_train",      files, value=TRUE)
featuresFile     <- grep("features\\.",   files, value=TRUE)
subjectTestFile  <- grep("subject_test",  files, value=TRUE)
subjectTrainFile <- grep("subject_train", files, value=TRUE)

# Read the data into data objects for use later
activityLabels <- read.table(activityFile)[,2]
xTest          <- read.table(xTestFile)
yTest          <- read.table(yTestFile)
xTrain         <- read.table(xTrainFile)
yTrain         <- read.table(yTrainFile)
features       <- read.table(featuresFile)[,2]
subjectTest    <- read.table(subjectTestFile)
subjectTrain   <- read.table(subjectTrainFile)

## 1. Merge the training and test sets into one data set.
xTestTrain <- rbind(xTest, xTrain)
yTestTrain <- rbind(yTest, yTrain)
subjectTestTrain <- rbind(subjectTest, subjectTrain)

## 2. Extract measurements on the mean and standard deviation
##    Subset xTestTrain by finding the column names which contain 
##    either (mean) or standard deviation (std) in the names (grep'd) and then 
##    including only those columns back into the data set.
names(xTestTrain) <- features
xTestTrain <- xTestTrain[ , grepl("mean|std", features)]

## 3. Define activity names
yTestTrain[ , 2] = activityLabels[yTestTrain[ , 1]]

## 4. Label the data set
names(yTestTrain) = c("ActivityID", "ActivityName")
names(subjectTestTrain) = "SubjectID"

## 5. Create the tidy data set
## First, column bind everything into one big table.
allData <- cbind(as.data.table(subjectTestTrain), yTestTrain, xTestTrain)

## Second, melt the data into tall and skinny with all vars in columns
idColNames <- c("SubjectID", "ActivityID", "ActivityName")
measureColNames <- colnames(allData)
measureColNames <-  measureColNames[!(colnames(allData) %in% idColNames)]
meltedAllData = melt(allData, id = idColNames, measure.vars = measureColNames)

# Finally, summarize the data using the dcast function to give the mean for each
# variable for each combination of Subject ID and Activity Name
tidyData <- dcast(meltedAllData, SubjectID+ActivityName ~ variable, mean)

# Write out to storage with no row names into text file as specified.
write.table(tidyData, file="UCI_HAR_Dataset_tidy_data.txt", row.name=FALSE)