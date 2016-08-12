---
title: "run_analysis"
author: "Benny96"
date: "6 de agosto de 2016"
output: html_document
---



## 0.- Prelims 

### 0.1.- data.table package must be installed to reproduce this script correctly. Checks if it's installed to use it; otherwise, R will install & use it.
```
if(!("data.table" %in% rownames(installed.packages())))
{
  install.packages("data.table", dependencies = TRUE)
  library(data.table)
}else
{
  library(data.table)
}
```
### 0.2.- Download & Unzip the file
```
data <- getwd()
data
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
file <- "UCI HAR Dataset.zip"
if (!file.exists(data))
  {
  dir.create(data)
  }
download.file(fileURL, destfile=file, mode="wb")
unzip(file, exdir="./data")
```
## 1.- Merge the training & test sets to create a dataset

### 1.1.- Read the activity labels from the activity_labels.txt:
```
activity_label<-read.table("./data/UCI HAR Dataset/activity_labels.txt",stringsAsFactors=FALSE)
```
### 1.2.- Obtain the subjects from the testing & training sets:
```
testing_subjects<-read.table("./data/UCI HAR Dataset/test/subject_test.txt")
training_subjects<-read.table("./data/UCI HAR Dataset/train/subject_train.txt")
```
### 1.3.- Add the subjects from the testing & training set to a new dataset (tidy_dataset):
```
tidy_dataset<-testing_subjects
tidy_dataset<-rbind(tidy_dataset,training_subjects)
```
### 1.4.- Change the column name to "Subjects": 
```
colnames(tidy_dataset)[1]<-"Subjects"  
```
### 1.5.- Read & append the activities of the subjects from both the testing & training sets to a new data frame (subject_activity):
```
test_activity<-read.table("./data/UCI HAR Dataset/test/Y_test.txt")
train_activity<-read.table("./data/UCI HAR Dataset/train/Y_train.txt")

subject_activity<-test_activity 
subject_activity<-rbind(subject_activity,train_activity)
```
### 1.6.- Classify the activities by their name using the activity_label data frame:
```
for(i in 1:nrow(tidy_dataset))
{
  index<-which(activity_label[,1] == subject_activity[i,1])
  tidy_dataset$Activity[i]<-activity_label[index,2]
}
```
### 1.7.- Read every feature from "features.txt":
```
features<-read.table("./data/UCI HAR Dataset/features.txt",stringsAsFactors=FALSE)
```
### 1.8.- Read & append the feature readings of the subjects from both the testing & training sets to a new data frame (feature_readings):
```
test_feature_readings<-read.table("./data/UCI HAR Dataset/test/X_test.txt")
train_feature_readings<-read.table("./data/UCI HAR Dataset/train/X_train.txt")

feature_readings<-test_feature_readings
feature_readings<-rbind(feature_readings,train_feature_readings)
```
### 1.9.- Update the names of the columns with feature readings in the tidy_dataset:
```
for(i in 1:ncol(feature_readings))
{
  tidy_dataset<-cbind(tidy_dataset,feature_readings[,i])
  names(tidy_dataset)[ncol(tidy_dataset)]<-features[i,2]
}
```
##2.- Extract the measurements on the mean and standard deviation

### 2.1.- Extract the columns showing the measurements on the mean and standard deviation:
```
extract<-grep("(.*)(mean|std)[Freq]?(.*)[/(/)]$|(.*)(mean|std)(.*)()-[X|Y|Z]$",colnames(tidy_dataset),value=TRUE)
```
### 2.2.- Sort the tidy_dataset with the extracted columns:
```
tidy_dataset<-tidy_dataset[,c("Subjects","Activity",extract)]
```
##3.- Give descriptive names to the activity labels

### 3.1.- Remove the underscores and lowercase some of the characters.
```
tidy_dataset$Activity<-gsub("WALKING_UPSTAIRS","Walking Upstairs",tidy_dataset$Activity)
tidy_dataset$Activity<-gsub("WALKING_DOWNSTAIRS","Walking Downstairs",tidy_dataset$Activity)
tidy_dataset$Activity<-gsub("WALKING","Walking",tidy_dataset$Activity)
tidy_dataset$Activity<-gsub("SITTING","Sitting",tidy_dataset$Activity)
tidy_dataset$Activity<-gsub("STANDING","Standing",tidy_dataset$Activity)
tidy_dataset$Activity<-gsub("LAYING","Laying",tidy_dataset$Activity)
```
##4.- Give descriptive names to the columns

### 4.1.- Remove parenthesis & hyphens from the column names, also replacing them with underscores:
```
colnames(tidy_dataset)<-gsub("[/(/)]","",colnames(tidy_dataset))
colnames(tidy_dataset)<-gsub("-","_",colnames(tidy_dataset))
```
##5.- Create an independent tidy dataset containing the average of the variables for each activity and subject

### 5.1.- Data type change of the tidy_dataset: data.frame <- data.table.
```
tidy_dataset = data.table(tidy_dataset)
```
### 5.2.- Group the data of "Subjects" and "Activities" performed by each of the subjects, obtaining the mean of the needed variables:
```
tidy_dataset<-tidy_dataset[,lapply(.SD,mean),by='Subjects,Activity']
tidy_dataset<-tidy_dataset[order(tidy_dataset$Subjects),]
```
### 5.3.- Create the tidy dataset (.txt format).
```
write.table(tidy_dataset, "Tidy_Dataset.txt", row.names = FALSE)
```
##6.- Generate codebook of the obtained data set
```
knit("createCodebook.Rmd", output="codebook.md", encoding="ISO8859-1")
markdownToHTML("codebook.md", "codebook.html")
```
