#######################
## This code is written with a lot of checks for exists
## reason is if you run it multiple time, you want to
## save time loading and shaping data that has already
## been loaded and shaped.
#######################

#If plyr is not installed, install
if (!is.element("plyr",installed.packages()[,1])) {
  install.packages("plyr")
}
#load plyr
library(plyr)
#If reshape2 is not installed, install
if (!is.element("reshape2",installed.packages()[,1])) {
  install.packages("reshape2")
}
library(reshape2)

#If we do not have data, then download
if (!file.exists("HAR.zip")) {
  print("Downloading")
  download.file("https://d396qusza40orc.cloudfront.net/getdata/projectfiles/UCI HAR Dataset.zip","HAR.zip")
}

#If we did not unzip, then unzip
if (!file.exists(".\\UCI HAR Dataset")) {
  print("Unzipping")
  unzip("HAR.zip")
}

#Load the features data
if (!exists("features")) {
  print("Loading features")
  features<-read.table(".\\UCI HAR Dataset\\features.txt")
}

#Load activity labels
if (!exists("activityLabels")) {
  print("Loading activity labels")
  activityLabels<-read.table(".\\UCI HAR Dataset\\activity_labels.txt")
}

##########################################
## Here is where we load the main tables
##########################################

##########################################
## train
##########################################
#if we have not loaded training data, then load
if (!exists("train")) {
  print("Loading train")
  train<-read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
  #Set the column names to the label names from feature labels file
  colnames(train)<-as.vector(features[[2]])
  #load the activity data
  trainLabels<-read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
  #add activitylabels to the activity data
  trainLabels<-join(trainLabels,activityLabels)
  #Identify the columns in the train labels
  colnames(trainLabels)<-c("activityID","activity")
  #add the activity data to the train data
  train<-cbind(train,trainLabels)
}

#add the train subjects
if (!exists("trainSubjects")) {
  print("Loading train subjects")
  trainSubjects<-read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")
  #Identify the Subject column
  colnames(trainSubjects)[1]<-"Subject"
  #Add subjects to the train data
  train<-cbind(train,trainSubjects)
}

##########################################
## test
##########################################
#if we have not loaded test data, then load
if (!exists("test")) {
  print("Loading test")
  test<-read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
  #Set the column names to the label names from feature labels file
  colnames(test)<-as.vector(features[[2]])
  #load the activity data
  testLabels<-read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
  #add activitylabels to the activity data
  testLabels<-join(testLabels,activityLabels)
  #Identify the columns in the test labels
  colnames(testLabels)<-c("activityID","activity")
  #add the activity data to the test data
  test<-cbind(test,testLabels)
}

#add the test subjects
if (!exists("testSubjects")) {
  print("Loading test subjects")
  testSubjects<-read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
  #Identify the Subject column
  colnames(testSubjects)[1]<-"Subject"
  #Add subjects to the test data
  test<-cbind(test,testSubjects)
}

#############################################
## Now we finally do step 1 of the assignment.
## To combine the train and test data,
## all we need to do is rbind()
#############################################
if (!exists("fullData")) {
  print("Building data")
  fullData<-rbind(test,train)
}

#############################################
## Now we do step 3 of the assignment.
## We  shrink the data columns to only the 
## those required in step 2
#############################################
print("Shrinking data")
fullData<-cbind(
            fullData[grep("mean",names(fullData))],
            fullData[grep("std",names(fullData))],
            fullData[grep("Subject",names(fullData))],
            fullData[grep("activity",names(fullData))]
)

#############################################
## Step 5 is the creation of a tidy data set
## to calculate mean grouped by subject, activity
#############################################
tidydata<-aggregate(fullData[,1:79],by=list(fullData[,'Subject'],fullData[,'activity']),FUN=mean)
#set the column names for the tidy data
names(tidydata)[1:2]<-c("Subject","Activity")

print("Saving tidy data")
write.table(tidydata, "tidydata.txt", row.name=F)
print("Tidy data saved")

