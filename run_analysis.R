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
zip.list <- unzip(raw.data.file, list=TRUE)
zip.list <- zip.list[grepl("[.]txt$", zip.list$Name) & zip.list$Length > 0,]
message(sprintf("Found %d text files with size greater than zero:", 
                nrow(zip.list)))

zip.file.activity_labels <- zip.list[which(grepl("activity_labels[.]txt$", 
                                           zip.list$Name)), c("Name")]
zip.file.features <- zip.list[which(grepl("features[.]txt$", 
                                             zip.list$Name)), c("Name")]
message("    2 files with metadata.")

zip.list.train <- as.list(zip.list[grepl("train[.]txt$", zip.list$Name), 
                                   c("Name")])
message(sprintf("    %d files with training data.", length(zip.list.train)))

zip.list.test <- as.list(zip.list[grepl("test[.]txt$", zip.list$Name), 
                                  c("Name")])
message(sprintf("    %d files with test data.", length(zip.list.test)))

names.train <- lapply(zip.list.train, 
                      function (s) sub("_train[.]txt$", "", 
                                       tail(strsplit(s, "/")[[1]], 1)))

names.test <- lapply(zip.list.test, 
                     function (s) sub("_test[.]txt$", "", 
                                      tail(strsplit(s, "/")[[1]], 1)))

assertion.datanames <- identical(sort(unlist(names.train)), 
                                 sort(unlist(names.test)))

message(sprintf("Checking if same files exist for training and test data: %s", 
                assertion.datanames))
if (!assertion.datanames) {
    stop("Training and test data must have same file structure!")
}

names(names.train) <- names.train
names(zip.list.train) <- names.train
names(names.test) <. names.test
names(zip.list.test) <- names.test

############################################################
# Loading data from zip file                               #                                                                      
############################################################

message("Loading metadata...")
activity_labels <- load.with.msg(raw.data.file, zip.file.activity_labels)
features <- load.with.msg(raw.data.file, zip.file.features)

# Load training data
message("Loading training data (can take some time...)")
data.train <- lapply(zip.list.train, 
                     function(f) load.with.msg(raw.data.file, f))


message("Loading test data (can take some time...)")
# Load test data
data.test <- lapply(zip.list.test, 
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
data <- lapply(names.train, 
               function (n) rbind(data.train[[n]], data.test[[n]]))

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

names(activity_labels) <- c("activityCode", "activityName")
names(features) <- c("vectorColumn", "feature")
# Make sure features is ordered by vectorColumn number
features <- <- features[order(features[,1]),]

# Put feature names as column names for size 561 vectors
names(data[["X"]]) <- features[,"feature"]
names(data[["subject"]]) <- c("subject")
names(data[["y"]]) <- c("activityCode")

# NEXT THREE LINES TODO
data[["X"]][,"activityCode"] <- data[["y"]][,"activityCode"] 
data[["X"]][,"subject"] <- data[["x"]][,"subject"]
data[["X"]] <- merge(data[["X"]], activity_labels, by="activityCode")


############################################################
# Assignment instruction 2                                 #
# Extract only the measurements on the mean and standard   #
# deviation for each measurement.                          #                                      
############################################################

message("TODO: Performing assignment instruction 2")


############################################################
# Assignment instruction 5                                 #
# Create a second, independent tidy data set with the      #
# average of each variable for each activity and each      #
# subject.                                                 #                                                             
############################################################

message("TODO: Performing assignment instruction 5")

message("Finished processing. Bye!")

################################################################################
##                                                                            ##
## End of file                                                                ##
################################################################################