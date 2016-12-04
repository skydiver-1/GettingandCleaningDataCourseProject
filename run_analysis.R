# setWD
setwd("~/Desktop/UCI HAR Dataset 2")
library(dplyr)

######################################################################
# Step 1: merge 3 seperate files from TRAIN subfolder into one dataset 

# (file 1) read subject_train data from train subfolder (subject number)
subject_train <- read.table ("train/subject_train.txt")
# update column name
names(subject_train) <- "subject"

# (file 2) read Y_train data from train subfolder (contains data re: 6 activities)
Y_train <- read.table ("train/y_train.txt")
# update column name
names(Y_train) <- "activity_labels"

# (file 3) read X_train data from train subfolder 
X_train <- read.table ("train/X_train.txt")
features <- read.table("features.txt")
features <- features[,2]

names(X_train) <- features 

#combine 3 files
combined_train <- cbind(subject_train,Y_train,X_train)

#limit columns to mean and standard deviation measurements
filter <- c(1:6,41:46,81:86,121:126,161:166,201,201,214,215,227,228,240,241,253,254,266:271,345:350,424:429,503,504,516,517,529,530,542,543)
combined_train_complete <- combined_train[,c(1,2,filter+2)]

######################################################################
# Step 2: merge 3 seperate files from TEST subfolder into one dataset 

# (file 1) read subject_test data from test subfolder (subject number)
subject_test <- read.table ("test/subject_test.txt")
# update column name
names(subject_test) <- "subject"

# (file 2) read Y_test data from test subfolder (contains data re: 6 activities)
Y_test <- read.table ("test/y_test.txt")
# update column name
names(Y_test) <- "activity_labels"

# (file 3) read X_test data from test subfolder 
X_test <- read.table ("test/X_test.txt")

names(X_test) <- features 

#combine 3 files
combined_test <- cbind(subject_test,Y_test,X_test)

#limit columns to mean and standard deviation measurements
combined_test_complete <- combined_test[,c(1,2,filter+2)]

######################################################################
# Step 3: r-bind combined_train and combined_test files into one final tidy dataset
final_tidy_dataset <- rbind(combined_train_complete,combined_test_complete)


######################################################################
# Step 4: create second tidy data set containing average for each activity and subject


#calculate means
mean_values <- final_tidy_dataset %>% group_by(activity_labels) %>% summarise_each(funs(mean))
transposed_means <- as.data.frame(t(mean_values))

#convert activity_labels of 1-6 to actual activity ... data set numerically ordered from left to right and c() contains names in key order
names(transposed_means) <- c("walking","walking_upstairs","walking_downstairs","sitting","standing","laying")

#remove first two rows from summary table: numerical activity_labels and the mean of the subject numbers
tidy_dataset_final_means <- transposed_means[-c(1,2),]


# partial output: head(tidy_dataset_final_means)
#                      walking walking_upstairs  walking_downstairs    sitting    standing      laying
# tBodyAcc-mean()-X  0.27633688       0.26229465         0.28813723  0.27305961  0.27915349  0.26864864
# tBodyAcc-mean()-Y -0.01790683      -0.02592329        -0.01631193 -0.01268957 -0.01615189 -0.01831773
# tBodyAcc-mean()-Z -0.10888169      -0.12053793        -0.10576162 -0.10551700 -0.10658691 -0.10743563
# tBodyAcc-std()-X  -0.31464445      -0.23798975         0.10076633 -0.98344622 -0.98443471 -0.96093241
# tBodyAcc-std()-Y  -0.02358295      -0.01603251         0.05954862 -0.93488056 -0.93250871 -0.94350719
# tBodyAcc-std()-Z  -0.27392080      -0.17544970        -0.19080451 -0.93898158 -0.93991350 -0.94806930
