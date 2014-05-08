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
message(sprintf("Found %d files with size greater than zero.", 
                nrow(zip.list)))

message("Getting files names for training and test data...")
zip.list.train <- as.list(zip.list[grepl("train[.]txt$", zip.list$Name), 
                                   c("Name")])
message(sprintf("Found %d files with training data.", length(zip.list.train)))

zip.list.test <- as.list(zip.list[grepl("test[.]txt$", zip.list$Name), 
                                  c("Name")])
message(sprintf("Found %d files with test data.", length(zip.list.test)))

names.train <- lapply(zip.list.train, 
                      function (s) sub("_train[.]txt$", "", 
                                       tail(strsplit(s, "/")[[1]], 1)))

names.test <- lapply(zip.list.test, 
                     function (s) sub("_test[.]txt$", "", 
                                      tail(strsplit(s, "/")[[1]], 1)))

assertion.datanames <- identical(names.train, names.test)
message(sprintf("Checking if same files exist for training and test data: %s", 
                assertion.datanames))
if (!assertion.datanames) {
    stop("Training and test data must have same file structure!")
}

names(zip.list.train) <- names.train
names(zip.list.test) <- names.test

############################################################
# Loading data from zip file                               #                                                                      
############################################################

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

message("TODO: Performing assignment instruction 1")

############################################################
# Assignment instruction 2                                 #
# Extract only the measurements on the mean and standard   #
# deviation for each measurement.                          #                                      
############################################################

message("TODO: Performing assignment instruction 2")

############################################################
# Assignment instruction 3                                 #
# Use descriptive activity names to name the activities    #
# in the data set.                                         #
############################################################

message("TODO: Performing assignment instruction 3")

############################################################
# Assignment instruction 4                                 #
# Appropriately label the data set with descriptive        #
# activity names.
############################################################

message("TODO: Performing assignment instruction 4")

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