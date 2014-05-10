################################################################################
## File: run_analysis.R                                                       ##
## This box is 80 characters wide, keep all lines shorter                     ##
##                                                                            ##
################################################################################

library("reshape2")

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

# Timing parameters
# 2.56 seconds rolling windows with 50% overlap
# Each window has 128 values sampled at 50Hz (sampling interval 0.02s)
sampling.interval <- 1.0 / 50.0  # 0.02 seconds
twindow.size <- 128 * sampling.interval  # 2.56 seconds
twindow.sep <- 0.5 * twindow.size # 1.28 seconds

tidy.averages.file <- "averages-tidy.txt"

ignore.inertial <- FALSE

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

zfilenames <- zfiles[grepl("[.]txt$", zfiles$Name) & zfiles$Length > 0, 
		     c("Name")]

message(sprintf("Found %d text files with size greater than zero.", 
                length(zfilenames)))

# Let's remove info and from list, we won't use them
relevant.file.selector <- !grepl("README[.]txt$", zfilenames) & 
                          !grepl("features_info[.]txt$", zfilenames)

if (ignore.inertial) {
    relevant.file.selector <- relevant.file.selector & 
                              !grepl("[Ii]nertial [Ss]ignals", zfilenames)
}
			  zfilenames <- zfilenames[relevant.file.selector]
message(sprintf("Keeping only relevant files (%d):", 
                length(zfilenames)))

zfilename.activity_labels <- grep("activity_labels[.]txt$", zfilenames, 
				  value=TRUE)[[1]]

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

replace.list  <- list("-"= "_", "," = "_", "\\." = "_", "\\("= "", "\\)"= "")

new.feature.names <- features$feature

for (c in names(replace.list)) {
   new.feature.names <- gsub(c, replace.list[[c]], new.feature.names)    
}

features$feature <- new.feature.names

features$feature <- as.character(features$feature)
# Make sure features is ordered by vectorColumn number
features <- features[order(features[,"vectorColumn"]),]

# There are duplicated names in the feature list.
# The duplicated names will be made unique by adding suffixes
message("Deduplicating feature names (keeping all data)")
duplicated.feature.names <- 
    unique(features$feature[duplicated(features$feature)])

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

info <- merge(data.frame(data[["y"]], data[["subject"]], idx=1:nrow(data[["y"]]))
	      , activity_labels, by="activityCode")

info <- info[order(info$idx),]

# Compute the times for the rolling time series for each subject and activity
info$wtime <- rep(0.0, nrow(info))

for (s in unique(info$subject)) {
    for (a in levels(info$activity)) {
	selector <- info[,"subject"] == s & info[,"activity"] == a
        info[selector,"wtime"] <- seq(1, nrow(info[selector,])) * twindow.sep
    }
}

data[["X"]]$activity <- info$activity
data[["X"]]$subject <- info$subject
data[["X"]]$wtime <- info$wtime


#p <- ggplot(d=data$X[data$X[,"subject"] %in% sample(1:30, 5),], aes(x=wtime, y=fBodyAccMag_mean, color=activity)) + geom_line() + facet_wrap(subject~activity, ncol=6) + theme(text = element_text(size=9), legend.position="none") + xlim(0, 65) + xlab("Window time (seconds)") 
#ggsave(file="tseries-acc.pdf", plot=p, units="in", width=11, height=8.5)


############################################################
# Creating tidy dataset for inertial signals               #
# Extra work for fun                                       #
############################################################


make.inertial4tidy <- function (n) {
    message(sprintf("    %s", n))
    z <- data.frame(data[[n]], subject=info$subject, activity=info$activity, 
    		wtime=info$wtime)
    z <- melt(z, id=c("subject", "activity", "wtime"))
    z <- z[order(z$subject, z$activity, z$wtime, z$variable),]
    z$variable <- NULL
    reduced.time <- rep((0:127)*sampling.interval, length.out=nrow(z))
    z$time <- z$wtime + reduced.time - twindow.sep
    z$wtime <- NULL
    dup.samples <- duplicated(z[,c("subject", "activity", "time", "value")])
    z <- z[!dup.samples,]
    value.name <- substr(n, nchar(n), nchar(n))
    names(z) <- sub("value", value.name, names(z))
    #z[order(z$subject, z$activity, z$time),]
    z
}

if (!ignore.inertial) {
    names.inertial <- grep("acc|gyro", names.train, value=TRUE)
    names(names.inertial) <- names.inertial

    message("Reorganizing and labelling data in inertial signal data sets")
    inertial4tidy <- lapply(names.inertial, make.inertial4tidy)

    message("Merging into categories (body_acc, body_gyro, total_acc)")
    message("    body_acc")
    body_acc <- Reduce(function(x,y) {merge(x,y)}, 
    		   inertial4tidy[grep("^body_acc_", names.inertial, 
				      value=TRUE)])

    message("    body_gyro")
    body_gyro <- Reduce(function(x,y) {merge(x,y)}, 
		   inertial4tidy[grep("^body_gyro_", names.inertial, 
				      value=TRUE)])

    message("    total_acc")
    total_acc <- Reduce(function(x,y) {merge(x,y)}, 
		   inertial4tidy[grep("^total_acc_", names.inertial, 
				      value=TRUE)])

    message("Melting and relabelling body_acc for final merge")
    body_acc <- melt(body_acc, id=c("subject", "activity", "time"))
    names(body_acc) <- gsub("value", "body_acc", 
			gsub("variable", "component", names(body_acc)))

    message("Melting and relabelling body_gyro for final merge")
    body_gyro <- melt(body_gyro, id=c("subject", "activity", "time"))
    names(body_gyro) <- gsub("value", "body_gyro", 
			gsub("variable", "component", names(body_gyro)))

    message("Melting and relabelling total_acc for final merge")
    total_acc <- melt(total_acc, id=c("subject", "activity", "time"))
    names(total_acc) <- gsub("value", "total_acc", 
			gsub("variable", "component", names(total_acc)))


    message(paste("Creating tidy data set with all inertial signals data", 
		  "(this may take some time...)"))
    message("Merging body_acc and body_gyro first...")
    temp <- merge(body_acc, body_gyro)
    message("Merging total acc to the result")
    data.inertial.tidy <- merge(temp, total_acc)
    message("Done! (stored in variable \'data.inertial.tidy\')")

}

############################################################
# Assignment instruction 2                                 #
# Extract only the measurements on the mean and standard   #
# deviation for each measurement.                          #                                     
############################################################

message(paste("Creating tidy dataset containing only means and standard",
              "deviations (assignment instruction 2)"))

# Select columns for mean/sd dataset by searching for the strings 
# "mean()" and "std()" in the column names (features)
names.mean.sd <- c("subject", "activity", "wtime",
                   grep("std|mean", 
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
averages.tidy <- aggregate(. ~ subject + activity, data=data[["X"]], 
			       FUN=mean)

# Order dataset for nicer output
averages.tidy <- averages.tidy[order(averages.tidy$subject, 
				     averages.tidy$activity),]

message(sprintf(paste("Writing tidy dataset with averages per", 
		      "subject/activity to \"%s\""), tidy.averages.file))
# Write tidy dataset with averages to file
write.table(averages.tidy, file=tidy.averages.file, row.names=FALSE)

message("Finished processing. Bye!")

################################################################################
##                                                                            ##
## End of file                                                                ##
################################################################################
