# Getting and Cleaning Data 
## Course Project
## CodeBook.md

The code for the analysis can be found in run_analysis.R.  For the most part, the code should be relatively well documented.  In this document, I will attempt to further explain the transformation processes.

The analysis start off by reading in the activity labels:
```r
run_analysis <- function() {
  # get activity names
  activity_labels <- read.table("activity_labels.txt")
```

For both the test and training data, this is imported with a simple read.table command.  I was actually surprised to see the data import so cleanly with no need to coerce any types.  The merge command join the activity IDs to the actual activity labels defined in activity_label.txt:
```r
  # read in test data
  test_subject <- read.table("test/subject_test.txt")
  test_X <- read.table("test/X_test.txt")
  test_Y <- read.table("test/Y_test.txt")
  test_activity <- merge(test_Y, activity_labels, by="V1")
  
  # read in training data
  train_subject <- read.table("train/subject_train.txt")
  train_X <- read.table("train/X_train.txt")
  train_Y <- read.table("train/y_train.txt")
  train_activity <- merge(train_Y, activity_labels, by="V1")
```

Because activity_labels.txt doesn't necessarily defined a descriptive field for the subject or activity, I define the descriptive names for these fields here:
```r
  # make descriptive names for subject and activities
  # features.txt doesn't give us these descriptions
  names(test_subject) <- c("subject_id")
  names(test_activity) <- c("activity_id", "activity")
  names(train_subject) <- c("subject_id")
  names(train_activity) <- c("activity_id", "activity")
```

features.txt contains the descriptive names for the fields defined in test_X and train_X.  With some cleansing of these field(removal and substituion of parentheses, commas, etc), these will eventually become the descriptive names for our data in test_X and train_X:
```r
  # read in and cleanse featurs files (the descriptive names for the
  # rest of the columns)
  features <- read.table("features.txt")
  features[,2] <- gsub("\\(", "", features[,2])
  features[,2] <- gsub(")", "", features[,2])
  features[,2] <- gsub(",", "-", features[,2])
  
  # Add these names to the test data
  names(test_X) <- features[,2]
  names(train_X) <- features[,2]
```

The rbind commands merges all of the testing and training data together in a variable called final:
```r
  # merge all the datas
  final <- rbind(cbind(test_subject, test_activity, test_X), cbind(train_subject, train_activity, train_X))
```

These grep commands extract all standard deviation and mean columns, along with the subject and activity (which will be used for grouping in the final step).  These results of this dataset are written to final.txt:
```r
  # extract the subject, activity, std and mean activity and write to final.txt
  final <- final[,c(1, 3, sort(c(grep("mean", names(final)), grep("std", names(final)))))]
  write.table(final, "final.txt", row.names=FALSE)
```

The final aggregate command will take the mean of all columns ([3:79]) and group them by the first two fields: subject_id and activity).  The resulting dataset is eventually written to final_aggregate.txt:
```r
  # get the mean of all values and write to final_aggregate.txt
  final_aggregate <- aggregate(final[3:79], by=list(subject_id=final$subject_id, activity=final$activity), FUN=mean)
  write.table(final_aggregate, "final_aggregate.txt", row.names=FALSE)
}
```:w

