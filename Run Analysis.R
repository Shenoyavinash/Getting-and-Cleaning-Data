library(reshape2)  
2   
3  filename <- "getdata_dataset.zip"  
4   
5   ## Download and unzip the dataset:  
6  if (!file.exists(filename)){  
7    fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "  
8    download.file(fileURL, filename, method="curl")  
9  }    
10  if (!file.exists("UCI HAR Dataset")) {   
11    unzip(filename)   
12  }  
13   
14  # Load activity labels + features  
15  activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")  
16  activityLabels[,2] <- as.character(activityLabels[,2])  
17  features <- read.table("UCI HAR Dataset/features.txt")  
18  features[,2] <- as.character(features[,2])  
19   
20  # Extract only the data on mean and standard deviation  
21  featuresWanted <- grep(".*mean.*|.*std.*", features[,2])  
22  featuresWanted.names <- features[featuresWanted,2]  
23  featuresWanted.names = gsub('-mean', 'Mean', featuresWanted.names)  
24  featuresWanted.names = gsub('-std', 'Std', featuresWanted.names)  
25  featuresWanted.names <- gsub('[-()]', '', featuresWanted.names)  
26   
27   
28  # Load the datasets  
29  train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresWanted]  
30  trainActivities <- read.table("UCI HAR Dataset/train/Y_train.txt")  
31  trainSubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")  
32  train <- cbind(trainSubjects, trainActivities, train)  
33   
34  test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresWanted]  
35  testActivities <- read.table("UCI HAR Dataset/test/Y_test.txt")  
36  testSubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")  
37  test <- cbind(testSubjects, testActivities, test)  
38   
39  # merge datasets and add labels  
40  allData <- rbind(train, test)  
41  colnames(allData) <- c("subject", "activity", featuresWanted.names)  
42   
43  # turn activities & subjects into factors  
44  allData$activity <- factor(allData$activity, levels = activityLabels[,1], labels = activityLabels[,2])  
45  allData$subject <- as.factor(allData$subject)  
46   
47  allData.melted <- melt(allData, id = c("subject", "activity"))  
48  allData.mean <- dcast(allData.melted, subject + activity ~ variable, mean)  
49   
50  write.table(allData.mean, "tidy.txt", row.names = FALSE, quote = FALSE)   
