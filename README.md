# GCD_homework
Clean the data and calculate the average of each measurement for each activity and each subject

>Generally speaking,  This study is about using the wearing techonolgy devices to measure all the body motion of 6 activitities. 
The 30 participants in this study are assigned into two group, either the training, or the testing group.
Each participant have performed 36 to 95 times for each activity, and each activity has 561 types of measurements, a.k.a. features.
Accordinglly, the outcome measurements are also saved in two differnet folders.

My strategy to perform this analysis are listed below.
+ PART1. Loading library.
+ PART2. Loading all the data needed, except those within the "Inertial Signals" folder.
+ PART3. Concatenating training and testing data becasue there are two group of people. Then, gather 561 measurements into 1 column, so that we can see 1 measurement and 1 outcome in a row. Finally, make the ID for each measurement.
+ PART4. Add the real names of features (a.k.a. measurements). Then , add the real names of activities, and make column names to be easily understand.
+ PART5. Make a simple descriptive statistic, the average result of each measurement for each activity and each subject. This can be done by the dplyr Verbs, group_by() and summarize().
+ PART6. Export the final summarized result.
