

library(dplyr)
library(lubridate)
setwd("/Users/viniciusroratto/Desktop/datasciencecoursera/Cleaning")
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
zipfilename <- "./data/dataset.zip"

#basic file downloading.
if(!file.exists("data")){
        print("Creating ./data folder.")
        dir.create("data")
        if(!file.exists(zipfilename)){
                print("Downloading files.")
                download.file(url = fileurl, destfile = zipfilename, method = "curl")
                print("Extracting files.")
                unzip(zipfilename, exdir = "./data" )
        }
}else{
        print("The data file was downloaded previously")
}

#preparing vector of features
features_dataset <- read.table(file = "./data/UCI HAR Dataset/features.txt")
features <- features_dataset[,2]

#preparing activity labels dataset
activity_label_dataset <- read.table(file = "./data/UCI HAR Dataset/activity_labels.txt",
                                     col.names = c("activity_number", "activity_label"))

#getting and managing tests sets.
x_test <- read.table(file = "./data/UCI HAR Dataset/test/X_test.txt", col.names = features)
write.csv(x_test, file = "./data/UCI HAR Dataset/test/X_test2.csv")
y_test <- read.table(file = "./data/UCI HAR Dataset/test/Y_test.txt",
                     col.names = "activity_number")
subject_tests <- read.table(file = "./data/UCI HAR Dataset/test/subject_test.txt", 
                            col.names = "subject" )

if(dim(x_test)[1] == dim(y_test)[1] & dim(y_test)[1] == dim(subject_tests)[1]){
        test_set <- cbind(subject_tests, y_test, x_test)
        write.csv(test_set, file = "./data/UCI HAR Dataset/test/test_set2.csv")
        rm(subject_tests, y_test, x_test)
        }

#getting and managing training sets.  
x_train <- read.table(file = "./data/UCI HAR Dataset/train/X_train.txt", col.names = features)
y_train <- read.table(file = "./data/UCI HAR Dataset/train/Y_train.txt",
                      col.names = "activity_number")
subject_train <- read.table(file = "./data/UCI HAR Dataset/train/subject_train.txt", 
                            col.names = "subject" )
        
if(dim(x_train)[1] == dim(y_train)[1] & dim(y_train)[1] == dim(subject_train)[1]){
        train_set <- cbind(subject_train, y_train, x_train)
        rm(subject_train, y_train, x_train)
        }
        
#Merging training and tests sets in one data set.
dataset <- rbind(test_set,train_set)
rm(test_set,train_set)

#Removing columns that are not standard deviations or means.
selected_ds <- dataset[,grep(".std.|.mean.|subject|activity_number", names(dataset))]

#Using descriptive activity names to name the activities in the data set
merged_data <- merge(selected_ds, activity_label_dataset)

merged_data$activity_number <- NULL

#create a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_dataset <- aggregate(. ~subject + activity_label, merged_data, mean)
tidy_dataset <- arrange(tidy_dataset, tidy_dataset$subject, tidy_dataset$activity_label)
write.csv(tidy_dataset, file = "./data/UCI HAR Dataset/tidy.csv")
