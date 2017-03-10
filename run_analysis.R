

****Download the work file****
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "./R_DATA/projectData_getCleanData.zip")

****unzip the file****
 unzip("./R_DATA/projectData_getCleanData.zip", exdir = "./R_DATA")

 ****Load data ****
> XTrain <- read.table("./R_DATA/UCI HAR Dataset/train/X_train.txt")
> YTrain <- read.table("./R_DATA/UCI HAR Dataset/train/y_train.txt")
> SubTrain <- read.table("./R_DATA/UCI HAR Dataset/train/subject_train.txt")
> XTest <- read.table("./R_DATA/UCI HAR Dataset/test/X_test.txt")
> YTest <- read.table("./R_DATA/UCI HAR Dataset/test/y_test.txt")
> SubTest <- read.table("./R_DATA/UCI HAR Dataset/test/subject_test.txt")

1. Merges the training and the test sets to create one data set.
trainData <- cbind(SubTrain, YTrain, XTrain)
testData <- cbind(SubTest, YTest, XTest)
fullData <- rbind(trainData, testData)

2. Extracts only the measurements on the mean and standard deviation for each measurement.

featureName <- read.table("./R_DATA/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)[,2]
featureIndex <- grep(("mean\\(\\)|std\\(\\)"), featureName)
finalData <- fullData[, c(1, 2, featureIndex+2)]
colnames(finalData) <- c("subject", "activity", featureName[featureIndex])

3. Uses descriptive activity names to name the activities in the data set

activityName <- read.table("./R_DATA/UCI HAR Dataset/activity_labels.txt")
finalData$activity <- factor(finalData$activity, levels = activityName[,1], labels = activityName[,2])
finalData$Subject <- as.factor(finalData$Subject)


4.Appropriately labels the data set with descriptive variable names.

names(finalData) <- gsub("\\()", "", names(finalData))
names(finalData) <- gsub("subject", "Subject", names(finalData))
names(finalData) <- gsub("activity", "Activity", names(finalData))
names(finalData) <- gsub("^t", "Time", names(finalData))
names(finalData) <- gsub("^f", "Frequence", names(finalData))
names(finalData) <- gsub("-mean", "Mean", names(finalData))
names(finalData) <- gsub("-std", "Standard", names(finalData))
names(finalData) <- gsub("BodyBody", "Body", names(finalData))
names(finalData) <- gsub("-X", "_X", names(finalData))
names(finalData) <- gsub("-Y", "_Y", names(finalData))
names(finalData) <- gsub("-Z", "_Z", names(finalData))


5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

AllData <- finalData %>%
        group_by_("Subject", "Activity") %>%
        summarise_each(funs(mean))

write.table(AllData, "./R_DATA/TidyData.txt", row.names = FALSE)