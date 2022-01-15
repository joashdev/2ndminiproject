# Intro to Data Science

## Getting and Cleaning Data - 2nd Mini project

# Problem 1:

### Step 1. Imports dataset

Dataset URL: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

- extract data to `specdata/UCI_HAR_Dataset`
- import using `read.table()`

```r
# example:
activityLabels <- read.table(paste0(dataPath, "activity_labels.txt"), col.names = c("id", "activity"))

```

### Step 2. Merge datasets

- merge `x`, `y`, and `subject` data of `test` and `train` datasets using `cbind()`
- merge `train` and `test` datasets using `rbind()`

```r
test <- cbind(testSubject, testY, testX)
train <- cbind(trainSubject, trainY, trainX)
uci_data <- rbind(test, train)
```

### Step 3. Rename activities

- based on `id` on `filtered_uci_data` then get corresponding `activitylabel` on `activityLabels`

```r
filtered_uci_data$activity <- activityLabels[filtered_uci_data$activity, 2]

```

### Step 4. Rename columns

- use `sub()` to rename columns by pattern

```r
# example:
names(filtered_uci_data) <- sub("^t", "Time", names(filtered_uci_data))

```

### Step 5. Tidy datasets and export text file

- `group()` to organize data
- then `write.table()` to export to text file

```r
tidy_uci_data <- filtered_uci_data %>%
  group_by(subject, activity) %>%
  summarise_all(mean)
### export text file
write.table(tidy_uci_data, "tidy_uci_data.txt", row.name=FALSE)
### clean environment
rm(dataPath, featureLabels, activityLabels, testX, testY, testSubject,
   trainX, trainY, trainSubject, test, train, uci_data, filtered_uci_data)

```
