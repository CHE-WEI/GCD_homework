# Homework assingment
# You should create one R script called run_analysis.R that does the following. 
#    1. Merges the training and the test sets to create one data set.
#    2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#    3. Uses descriptive activity names to name the activities in the data set
#    4. Appropriately labels the data set with descriptive variable names. 
#    5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## This study is about using the wearing techonolgy devices 
## to measure all the body motion of 6 activitities.
## The 30 participants in this study are assigned into two group,
## either the training, or the testing group.
## Each participant have performed 36 to 95 times for each activity,  
## and each activity has 561 types of measurements, a.k.a. features.
## The outcome measurements are also saved in two differnet folders.


## PART1. Loading library
# setwd("Z:/UCI HAR Dataset")
library(dplyr)
library(tidyr)

## PART2. Loading all the data needed, 
## except those within the "Inertial Signals" folder.

  #### the names of activities with unique ID 
names<-c("act_id", "act_name")
activity_labels <-
  read.table(file="activity_labels.txt", 
             header = FALSE, sep = " ",
             stringsAsFactors = FALSE,
             col.names=names)

  #### the names of measured features with unique ID.
  #### filter the measurements which have mean or std in their name
names<-c("f_id", "f_name")
features<-
  read.table(file="features.txt", 
             header = FALSE, sep = " ",  
             stringsAsFactors = FALSE,
                     col.names=names) %>%
  filter(grepl("mean()", f_name, fixed = TRUE) |
           grepl("std()", f_name, fixed = TRUE))


  #### all the training data, including participants ID, 
  #### activity ID and the outcome for each feature
names<-c("r_id" )
train_subject<-
  read.table(file="./train/subject_train.txt", 
             header = FALSE, 
             stringsAsFactors = FALSE,
                          col.names=names)

names<-c("act_id" )
train_label<-
  read.table(file="./train/y_train.txt", 
             header = FALSE, 
             stringsAsFactors = FALSE,
                        col.names=names)

train_set<-
  read.table(file="./train/X_train.txt", 
             header = FALSE, 
             stringsAsFactors = FALSE) 
  #### merge the all the three training data 
training<-cbind(train_subject,train_label,train_set) %>%
  mutate(type="train")

  
  #### all the testing data, including participants ID, 
  #### activity ID and the outcome for each feature
names<-c("r_id" )
test_subject<-
  read.table(file="./test/subject_test.txt", 
             header = FALSE, 
             stringsAsFactors = FALSE,
                         col.names=names)

names<-c("act_id" )
test_label<-
  read.table(file="./test/y_test.txt", 
             header = FALSE, 
             stringsAsFactors = FALSE,
                       col.names=names)

test_set<-
  read.table(file="./test/X_test.txt", 
             header = FALSE, 
             stringsAsFactors = FALSE) 
  #### merge the all the three testing data 
testing<-cbind(test_subject,test_label,test_set) %>%
  mutate(type="test")



## PART3. Concatenating training and testing
## becasue there are two group of people.
## Then, gather 561 measurements into 1 column,
## so that we can see 1 measurement and 1 outcome in a row.
## Finally, make the id for each measurement
all<- rbind(training, testing ) %>%
  gather(f_id, value, V1:V561 ) %>%
  mutate(f_id=gsub("V","",f_id), f_id=as.integer(f_id))


## PART4. Add the real names of features (a.k.a. measurements).
## Then , add the real names of activities,
## make column names to be easily understand, 

all2<- merge(all, features, by="f_id") 

all3 <- 
  merge(all2, activity_labels, by ="act_id") %>%
  rename(participant=r_id, 
         activity=act_name,
         measurement=f_name,
         result=value        )


## PART5. Make a simple descriptive statistic
## The average result of each measurement 
## for each activity and each subject
all_sum<-
  group_by(all3, participant, activity, measurement) %>%  
  summarize( avg_result = mean(result)  ) %>% 
  spread(measurement,avg_result)
  
  names(all_sum)

  ###### this is just for reference
  ######   all_sum<-group_by(all3, participant, activity, measurement) %>% summarize(avg_result = mean(result), count = n() )
  ######   min(all_sum$count)
  ######   max(all_sum$count)

## PART6. Export the final summarized result.

write.table(all_sum, file="Z:/PGM/summarized_measurement.txt", row.name=FALSE ) 

