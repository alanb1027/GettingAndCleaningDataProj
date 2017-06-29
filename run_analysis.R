ActivityType = read.table("./activity_labels.txt",header=FALSE)
Features = read.table("./features.txt",header=FALSE)
TestSubject = read.table("./test/subject_test.txt",header=FALSE)
XTest = read.table("./test/X_test.txt",header=FALSE)
YTest = read.table("./test/y_test.txt",header=FALSE)
TrainSubject = read.table("./train/subject_train.txt",header=FALSE)
XTrain = read.table("./train/X_train.txt",header=FALSE)
YTrain = read.table("./train/y_train.txt",header=FALSE)
colnames(TestSubject)  = "SubjectId"
colnames(XTest)        = Features[,2]
colnames(YTest)        = "ActivityId"
colnames(ActivityType)  = c("ActivityId","ActivityType")
colnames(TrainSubject)  = "SubjectId"
colnames(XTrain)        = Features[,2]
colnames(YTrain)        = "ActivityId"
TestData=cbind(YTest,TestSubject,XTest)
TrainingData=cbind(YTrain,TrainSubject,XTrain)
FinalData=rbind(TestData,TrainingData)
colnames<-colnames(FinalData)
MeanStdColumns<-(grepl("ActivityId",colnames)|grepl("SubjectId",colnames)|grepl("mean..",colnames)|grepl("std..",colnames))
MeanStdData<-FinalData[,MeanStdColumns==TRUE]
MeanStdData[,1]<-ActivityType[MeanStdData[,1],2]
names(MeanStdData)<-gsub("^t", "time", names(MeanStdData))
names(MeanStdData)<-gsub("^f", "frequency", names(MeanStdData))
names(MeanStdData)<-gsub("Acc", "Accelerometer", names(MeanStdData))
names(MeanStdData)<-gsub("Gyro", "Gyroscope", names(MeanStdData))
names(MeanStdData)<-gsub("Mag", "Magnitude", names(MeanStdData))
names(MeanStdData)<-gsub("BodyBody", "Body", names(MeanStdData))
averages <- aggregate(. ~SubjectId + ActivityId, MeanStdData, mean)
write.table(averages, "averages.txt", row.name=FALSE)