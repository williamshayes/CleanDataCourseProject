## Getting and Cleaning Data - Course Project
##
## This R script will take data supplied by the UCI Machine Learning Repository
## describing people engaged in various activities with a smartphone wearable
## monitoring system.
##
## This script will take the following steps.
## 0. Retrieve the data from the remote source and load the data pieces into
##    specific R data objects for later use by the script.
## 1. Merge the training and the test sets to create one data set.
## 2. Extract only the measurements on the mean and standard deviation for each 
##    measurement. 
## 3. Uses descriptive activity names to name the activities in the data set.
## 4. Appropriately label the data set with descriptive variable names. 
## 5. From the data set in step 4, create a second, independent tidy data set 
##    with the average of each variable for each activity and each subject.


## 0(a). Download and stage the data supplied.
fileURL<-paste("https://d396qusza40orc.cloudfront.net/",
               "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
               sep="")
download.file(fileURL, "UCI_HAR_Dataset.zip")
unzip("UCI_HAR_Dataset.zip")
files <- list.files("UCI HAR Dataset", full.names=TRUE, recursive=TRUE)
UCI_HAR_Dataset.download.date <- Sys.time()
UCI_HAR_Dataset.download.date

## 0(b). Load data from needed files into data frames for later use.
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
names(xTest) <- features
names(yTest) <- features
names(xTrain) <- features
names(yTrain) <- features

## 2. Extract measurements on the mean and standard deviation

## 3. Define activity names

## 4. Label the data set

## 5. Create the tidy data set



