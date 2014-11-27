run_analysis <- function() {
  # get activity names
  activity_labels <- read.table("activity_labels.txt")
  
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
  
  # make descriptive names for subject and activities
  # features.txt doesn't give us these descriptions
  names(test_subject) <- c("subject_id")
  names(test_activity) <- c("activity_id", "activity")
  names(train_subject) <- c("subject_id")
  names(train_activity) <- c("activity_id", "activity")
  
  # read in and cleanse featurs files (the descriptive names for the
  # rest of the columns)
  features <- read.table("features.txt")
  features[,2] <- gsub("\\(", "", features[,2])
  features[,2] <- gsub(")", "", features[,2])
  features[,2] <- gsub(",", "-", features[,2])
  
  # Add these names to the test data
  names(test_X) <- features[,2]
  names(train_X) <- features[,2]
  
  # merge all the datas
  final <- rbind(cbind(test_subject, test_activity, test_X), cbind(train_subject, train_activity, train_X))

  # extract the subject, activity, std and mean activity and write to final.txt
  final <- final[,c(1, 3, sort(c(grep("mean", names(final)), grep("std", names(final)))))]
  write.table(final, "final.txt", row.names=FALSE)
  
  # get the mean of all values and write to final_aggregate.txt
  final_aggregate <- aggregate(final[3:79], by=list(subject_id=final$subject_id, activity=final$activity), FUN=mean)
  write.table(final_aggregate, "final_aggregate.txt", row.names=FALSE)
}
