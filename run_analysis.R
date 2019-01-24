library(dplyr)

##Get URL, download data, unzip the folder
fileurl <- 'http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileurl, './datasetzipped.zip', method = 'curl')
unzip('./datasetzipped.zip')


##After taking a look at the files, read the test data
subjecttest<-read.table('./UCI HAR Dataset/test/subject_test.txt')
Xtest<-read.table('./UCI HAR Dataset/test/X_test.txt')
Ytest<-read.table('./UCI HAR Dataset/test/y_test.txt')

##Then, read the train data
subjecttrain<-read.table('./UCI HAR Dataset/train/subject_train.txt')
Xtrain<-read.table('./UCI HAR Dataset/train/X_train.txt')
Ytrain<-read.table('./UCI HAR Dataset/train/y_train.txt')

##Read the features and activities
features<-read.table('./UCI HAR Dataset/features.txt')
activitylabels<-read.table('./UCI HAR Dataset/activity_labels.txt')

##Assign proper names to the test variables
colnames(subjecttest)<-'subject_id'
colnames(Ytest)<-'activity_id'
colnames(Xtest)<-features[,2]

##Assign proper names to the train variables
colnames(subjecttrain)<-'subject_id'
colnames(Ytrain)<-'activity_id'
colnames(Xtrain)<-features[,2]

##Assign names to activity labels
colnames(activitylabels)<-c('activity_id','activity')

##Merge test data and add column to indicate they are test subjects
mergedtest<-cbind(subjecttest,Ytest,Xtest)
test_or_train<-rep('test',nrow(mergedtest))
mergedtest<-cbind(mergedtest,test_or_train)

##Merge train data and add column to indicate they are train subjects
mergedtrain<-cbind(subjecttrain,Ytrain,Xtrain)
test_or_train<-rep('train',nrow(mergedtrain))
mergedtrain<-cbind(mergedtrain,test_or_train)

##Put test data together with train data (train data first)
completedataset<-rbind(mergedtrain,mergedtest)

##Subset the complete dataset in order to create a second dataset containing only the columns with means and 
##standard deviations of the measurement
colnamestotal<-colnames(completedataset)
columnstoselect<-(grepl('subject_id',colnamestotal)|grepl('activity_id',colnamestotal)|
                    grepl('mean',colnamestotal)|grepl('std',colnamestotal)|grepl('test_or_train',colnamestotal))
subsetdataset_mean_std<-completedataset[,columnstoselect==T]

##Insert also descriptive activity names and arrange dataset by increasing patient_id and, secondarily, by
##increasing activity_id
subsetdataset_mean_std<-merge(subsetdataset_mean_std,activitylabels, by='activity_id')
correctorder<-c(2:1,length(colnames(subsetdataset_mean_std)),(length(colnames(subsetdataset_mean_std))-1),
                3:(length(colnames(subsetdataset_mean_std))-2))
subsetdataset_mean_std<-subsetdataset_mean_std[,correctorder]
subsetdataset_mean_std<-arrange(subsetdataset_mean_std,subsetdataset_mean_std$subject_id,
                                subsetdataset_mean_std$activity_id)



##Create a new database with averages of the values in the columns per patient, per activity
averagedata<-aggregate(subsetdataset_mean_std[,-(3:4)], by=list(subsetdataset_mean_std$subject_id,
                                                                subsetdataset_mean_std$activity_id), FUN = mean)
averagedata<-averagedata[,-(1:2)]
averagedata<-merge(averagedata,activitylabels, by='activity_id')
averagedata$test_or_train<-ifelse((averagedata$subject_id %in% mergedtest$subject_id),yes='test',no='train')
averagedata<-averagedata[,correctorder]
averagedata<-averagedata[order(averagedata$subject_id, averagedata$activity_id),]
averagedata<-averagedata[,-2]

##Write a file with the new dataset
write.table(averagedata,'./UCI HAR Dataset/average_subsetdataset_mean_std.txt', row.names = F)
