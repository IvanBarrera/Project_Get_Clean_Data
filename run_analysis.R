
# Download file
temp <- tempfile() # Create a temporal file
download.file ("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", temp)
unzip(temp) # Unzip temporal file
unlink(temp) # Delete temporal file
rm(temp) # Removes temporal file from Global Environment of R

# Reading and binding test data
library(data.table)
## Reading subject data and setting column name
subject.test <- fread("~/Documents/R Projects/Data_Science_Specialization/Cleaning data/Getting_Cleaning_Data_Project/UCI HAR Dataset/test/subject_test.txt")
colnames(subject.test) <- "subject"

## Reading activities data and setting column name
activities.test <- fread("~/Documents/R Projects/Data_Science_Specialization/Cleaning data/Getting_Cleaning_Data_Project/UCI HAR Dataset/test/y_test.txt", select = )
colnames(activities.test) <- "activities"

## Creating a vector of columns with the mean and standard deviation for each measurement
variables <- c(1:6, 41:46, 81:86, 121:126, 161:166, 201:202, 214:215, 227:228, 240:241, 253:254, 266:271, 294:296, 345:350, 373:375, 424:429, 452:454, 503:504, 516:517, 526, 529:530, 542:543, 552, 555:561)

## Reading variable data
variable.test <- fread("~/Documents/R Projects/Data_Science_Specialization/Cleaning data/Getting_Cleaning_Data_Project/UCI HAR Dataset/test/X_test.txt", select = variables)

### Renaming variable names
variable.names <- fread("~/Documents/R Projects/Data_Science_Specialization/Cleaning data/Getting_Cleaning_Data_Project/UCI HAR Dataset/features.txt")
variable.names <- variable.names$V2[variable.names$V1 %in% variables]
colnames(variable.test) <- variable.names

## Binding test data
test.data <- cbind(subject.test,activities.test,variable.test)

# Reading and binding train data
## Reading subject data and setting column name
subject.train <- fread("~/Documents/R Projects/Data_Science_Specialization/Cleaning data/Getting_Cleaning_Data_Project/UCI HAR Dataset/train/subject_train.txt")
colnames(subject.train) <- "subject"

## Reading activities data and setting column name
activities.train <- fread("~/Documents/R Projects/Data_Science_Specialization/Cleaning data/Getting_Cleaning_Data_Project/UCI HAR Dataset/train/y_train.txt", select = )
colnames(activities.train) <- "activities"

## Reading variable data
variable.train <- fread("~/Documents/R Projects/Data_Science_Specialization/Cleaning data/Getting_Cleaning_Data_Project/UCI HAR Dataset/train/X_train.txt", select = variables)
colnames(variable.train) <- variable.names

## Binding train data
train.data <- cbind(subject.train,activities.train,variable.train)

# Merging training and test sets
smartlab.exp <- rbindlist(list(train.data, test.data), use.names = TRUE)

# Assign descriptive activity names to data set
library(plyr)
smartlab.exp$activities <- mapvalues(smartlab.exp$activities,
                                     from = c("1", "2", "3", "4", "5", "6"),
                                     to = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING"))


# Creating new tidy data set
smartlab.exp.avg <- aggregate(smartlab.exp[,3:86, with = FALSE],
                              by = list(subject = smartlab.exp$subject,
                                        activities = smartlab.exp$activities),
                              FUN = mean)

# Writing txt file
write.table( smartlab.exp.avg, file = "tidy_data.txt" , row.names = FALSE)
