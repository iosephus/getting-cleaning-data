################################################################################
## File: run_analysis.R                                                       ##
## This box is 80 characters wide, keep all lines shorter                     ##
##                                                                            ##
################################################################################

################################################################################
## Function definition section                                                ##
##                                                                            ##
################################################################################

# This function loads a file <f> from a zip archive <zipfile>
# Prints a message with the indented filename <f>
load.with.msg <- function (zipfile, f) {
    message(sprintf("    \"%s\"", f))
    df <- read.table(unz(zipfile, f))
    #message(sprintf("Loaded %s rows with %d variables each", 
    #               nrow(df), ncol(df)))
    df
}


################################################################################
## Parameter definition section                                               ##
##                                                                            ##
################################################################################

# URL for downloading the compressed data
raw.data.url <- paste0("https://d396qusza40orc.cloudfront.net/getdata%2F",
                      "projectfiles%2FUCI%20HAR%20Dataset.zip")

# Local file to store the compressed data
raw.data.file <- "UCI_HAR_Dataset.zip"

# Local file to store the download date and time
timestamp.file <- "download_timestamp.txt"

################################################################################
## Real work starts here!                                                     ##
##                                                                            ##
################################################################################

############################################################
# Conditional data download                                #                                                             
############################################################

# Check if data file exists in working directory, otherwise donwload it.
if (!file.exists(raw.data.file)) {
    message(sprintf("Downloading compressed data to \"%s\"...", raw.data.file))
    # Create download timestamp
    download.timestamp <- format(Sys.time(), tz="UTC", usetz=TRUE)
    # Download file
    download.file(raw.data.url, destfile=raw.data.file, method="curl")
    message(sprintf("Saving download timestamp (%s) to \"%s\"", 
                    download.timestamp, timestamp.file))
    # Save download timestamp
    cat(download.timestamp, file=timestamp.file)
}

############################################################
# Analize zip file structure                               #                                                             
############################################################

# List zipfile contents
message(sprintf("Getting list of files in \"%s\"...", raw.data.file))
zfiles <- unzip(raw.data.file, list=TRUE)
zfilenames <- zfiles[grepl("[.]txt$", zfiles$Name) & zfiles$Length > 0,c("Name")]
message(sprintf("Found %d text files with size greater than zero:", 
                length(zfilenames)))

zfilename.activity_labels <- grep("activity_labels[.]txt$", zfilenames, value=TRUE)[[1]]
zfilename.features <- grep("features[.]txt$", zfilenames, value=TRUE)[[1]]

message("    2 files with metadata.")

zfilenames.train <- grep("_train[.]txt$", zfilenames, value=TRUE)
message(sprintf("    %d files with training data.", length(zfilenames.train)))

zfilenames.test <- grep("_test[.]txt$", zfilenames, value=TRUE)
message(sprintf("    %d files with test data.", length(zfilenames.test)))

names.train <- sub("_train[.]txt$", "", basename(zfilenames.train))
names.test <- sub("_test[.]txt$", "", basename(zfilenames.test))

assertion.datanames <- identical(sort(names.train), 
                                 sort(names.test))

message(sprintf("Checking if same files exist for training and test data: %s", 
                assertion.datanames))
if (!assertion.datanames) {
    stop("Training and test data must have same file structure!")
}

load.list.train <- as.list(zfilenames.train)
names(load.list.train) <- names.train

load.list.test <- as.list(zfilenames.test)
names(load.list.test) <- names.test

############################################################
# Loading data from zip file                               #                                                                      
############################################################

message("Loading metadata...")
activity_labels <- load.with.msg(raw.data.file, zfilename.activity_labels)
features <- load.with.msg(raw.data.file, zfilename.features)

# Load training data
message("Loading training data (can take some time...)")
data.train <- lapply(load.list.train, 
                     function(f) load.with.msg(raw.data.file, f))


message("Loading test data (can take some time...)")
# Load test data
data.test <- lapply(load.list.test, 
                     function(f) load.with.msg(raw.data.file, f))

# Check if loaded trainign and test dataframes have same number of cols 
assertion.datacols <- identical(lapply(data.train, FUN=ncol), 
                                lapply(data.test, FUN=ncol))
message(sprintf("Checking if training and test datasets %s: %s", 
                "have same number of columns", 
                assertion.datacols))
if (!assertion.datacols) {
    stop("Training and test datasets must have same number of columns!")
}

############################################################
# Assignment instruction 1                                 #
# Merge the training and the test sets to create one       #
# data set.                                                #
############################################################

message("Mergin training and test datasets (assignment instruction 1)")
# Merge training and test datasets
data <- sapply(names.train, 
               FUN=function (n) rbind(data.train[[n]], data.test[[n]]),
               USE.NAMES=TRUE)

############################################################
# Assignment instruction 3                                 #
# Use descriptive activity names to name the activities    #
# in the data set.                                         #
# Assignment instruction 4                                 #
# Appropriately label the data set with descriptive        #
# activity names.                                          #
############################################################

message(paste("Add activity labels and feature names to datasets",
              "(assignment instruction 3-4)"))

# Name columns in activity_labels
names(activity_labels) <- c("activityCode", "activity")

# Name columns in features
names(features) <- c("vectorColumn", "feature")
features$feature <- as.character(features$feature)
# Make sure features is ordered by vectorColumn number
features <- features[order(features[,"vectorColumn"]),]

# There are duplicated names in the feature list.
# The duplicated names will be made unique by adding suffixes
message("Deduplicating feature names (keeping all data)")
duplicated.feature.names <- unique(features$feature[duplicated(features$feature)])

features.unique.names <- features$feature

for (d in duplicated.feature.names) {
    occurrences <- grep(d, features.unique.names, fixed=TRUE)
    suffixes <- paste0("-DUP", as.character(1:length(occurrences)))
    features.unique.names[occurrences] <- 
	paste0(features.unique.names[occurrences], suffixes)
}

# Modify names in original feature data frame
features$feature <- features.unique.names

# Put feature names as column names for the 561-feature vectors dataset
names(data[["X"]]) <- features$feature

# Name columns in subject and activity list datasets
names(data[["subject"]]) <- c("subject")
names(data[["y"]]) <- c("activityCode")

# Add new columns with subject and activity data to 
# the 561-feature vectors dataset

info <- merge(data.frame(data[["y"]], data[["subject"]]), activity_labels, by="activityCode")

data[["X"]]$activity <- info$activity
data[["X"]]$subject <- info$subject

############################################################
# Assignment instruction 2                                 #
# Extract only the measurements on the mean and standard   #
# deviation for each measurement.                          #                                      
############################################################

message(paste("Creating tidy dataset containing only means and standard",
              "deviations (assignment instruction 2)"))

# Select columns for mean/sd dataset by searching for the strings 
# "mean()" and "std()" in the column names (features)
names.mean.sd <- c("subject", "activity", 
                   grep("std\\(\\)|mean\\(\\)", 
                        names(data[["X"]]), value=TRUE))

# Create tidy mean/sd dataset
data.mean.sd <- data[["X"]][,names.mean.sd]

############################################################
# Assignment instruction 5                                 #
# Create a second, independent tidy data set with the      #
# average of each variable for each activity and each      #
# subject.                                                 #                                                             
############################################################

message(paste("Creating tidy dataset with averages per subject/activity", 
	      "(assignment instruction 5)"))
ag <- aggregate(. ~ subject + activity, data=data[["X"]], FUN=mean)

message("Finished processing. Bye!")

################################################################################
##                                                                            ##
## End of file                                                                ##
################################################################################
