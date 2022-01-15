# load necessary libraries
library(dplyr)

# [[IMPORT REQUIRED DATA]]
dataPath <- "./specdata/UCI_HAR_Dataset/"

### features and activity labels
featureLabels <- read.table(paste0(dataPath, "features.txt"), col.names = c("id", "features"))
activityLabels <- read.table(paste0(dataPath, "activity_labels.txt"), col.names = c("id", "activity"))

### test data
testX <- read.table(paste0(dataPath, "test/X_test.txt"), col.names = featureLabels$features)
testY <- read.table(paste0(dataPath, "test/y_test.txt"), col.names = "activity")
testSubject <- read.table(paste0(dataPath, "test/subject_test.txt"), col.names = "subject")

### train data
trainX <- read.table(paste0(dataPath, "train/X_train.txt"), col.names = featureLabels$features)
trainY <- read.table(paste0(dataPath, "train/y_train.txt"), col.names = "activity")
trainSubject <- read.table(paste0(dataPath, "train/subject_train.txt"), col.names="subject")


# [[MERGE DATA SETS]]
### column bind each test and train observations 
### then row bind to merge all observations
test <- cbind(testSubject, testY, testX)
train <- cbind(trainSubject, trainY, trainX)
uci_data <- rbind(test, train)

# [[EXTRACT MEAN AND STANDARD DEVIATION]]
### from uci_data, use select() to filter columns that contains mean and std
### this extract mean and standard deviation
### -contains("meanFrequency") removes the meanFrequency columns
### since it is not the ean of the variable
filtered_uci_data <- uci_data %>% 
  select("subject", "activity", contains("mean") | contains("std"), -contains("meanFreq"))

# [[NAME ACTIVITIES IN THE DATASET]]
### using activity labels instead of activity id
filtered_uci_data$activity <- activityLabels[filtered_uci_data$activity, 2]

# [[LABEL DATASET WITH DESCRIPTIVE VARIABLE NAMES]]
### renaming columns
names(filtered_uci_data) <- sub("^t", "Time", names(filtered_uci_data))
names(filtered_uci_data) <- sub("^f", "Frequency", names(filtered_uci_data))
names(filtered_uci_data) <- sub("Acc", "Accelerometer", names(filtered_uci_data))
names(filtered_uci_data) <- sub("angle", "Angle", names(filtered_uci_data))
names(filtered_uci_data) <- sub("gravity", "Gravity", names(filtered_uci_data))
names(filtered_uci_data) <- sub("Gyro", "Gyroscope", names(filtered_uci_data))
names(filtered_uci_data) <- sub("Mag", "Magnitude", names(filtered_uci_data))
names(filtered_uci_data)<-gsub("-mean..", "Mean", names(filtered_uci_data))
names(filtered_uci_data)<-gsub("-std..", "STD", names(filtered_uci_data))
names(filtered_uci_data)<-gsub("X", "Xaxis", names(filtered_uci_data))
names(filtered_uci_data)<-gsub("Y", "Yaxis", names(filtered_uci_data))
names(filtered_uci_data)<-gsub("Z", "Zaxis", names(filtered_uci_data))

# [[TIDY DATA SET]]
tidy_uci_data <- filtered_uci_data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)
### export text file
write.table(tidy_uci_data, "tidy_uci_data.txt", row.name=FALSE)
### clean environment
rm(dataPath, featureLabels, activityLabels, testX, testY, testSubject, 
   trainX, trainY, trainSubject, test, train, uci_data, filtered_uci_data)
