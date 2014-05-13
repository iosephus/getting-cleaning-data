################################################################################
## File: run_analysis.R                                                       ##
## This box is 80 characters wide, keep all lines shorter                     ##
##                                                                            ##
################################################################################

library(reshape2)

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

# 2.56 seconds rolling windows with 50% overlap
window.size <- 2.56
window.sep <- 0.5 * window.size # 1.28 seconds

tidy.averages.file <- "averages-tidy.txt"

# Max number of lines to print for data frames str ouput
num.lines.info <- 12

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
message(sprintf("\nGetting list of files in \"%s\"...", raw.data.file))

zfiles <- unzip(raw.data.file, list=TRUE)

zfilenames <- zfiles[grepl("[.]txt$", zfiles$Name) & zfiles$Length > 0, 
		     c("Name")]

message(sprintf("Found %d text files with size greater than zero.", 
                length(zfilenames)))

# Let's remove info and from list, we won't use them
relevant.file.selector <- !grepl("README[.]txt$", zfilenames) & 
                          !grepl("features_info[.]txt$", zfilenames)

# Remove inertial signal files from list

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

message("\nLoading metadata...")
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

message(sprintf("Checking if training and test data sets %s: %s", 
                "have same number of columns", 
                assertion.datacols))

if (!assertion.datacols) {
    stop("Training and test data sets must have same number of columns!")
}

############################################################
# Assignment instruction 1                                 #
# Merge the training and the test sets to create one       #
# data set.                                                #
############################################################

# Lets add columns to each data set to differentiate training and test data in
# the merged data set.
# Let's also add a column with an incremental index to be able to keep track
# of the order of the data (which is important because the data corresponds to
# ordered temporal windows).
# Data in test data set will have index shifted by the number of rows in the
# training data set so that we have a single index for ordering the marged 
# data set.

# This function will add index (with optional shift) and data set identifier.
add.index.and.setid <- function (d, setid, shift=0) {

    d$idx <- 1:nrow(d) + shift
    d$set <- factor(rep(setid, nrow(d)))
    d
}

message("Adding index and set identifier (Training/Test) before merging")
# Add index and data set identifier to training data
data.train <- lapply(data.train, 
		     function (d) add.index.and.setid(d, "Training"))

# Add index and data set identifier to test data.
# Add index shifted by the number of rows in training data set
data.test <- lapply(data.test, 
		     function (d) add.index.and.setid(d, "Test",
						      shift=nrow(data.train$X)))

message("\nMerging training and test data sets (ASSIGNMENT INSTRUCTION 1)")
# Merge training and test data sets
data <- sapply(names.train, 
               FUN=function (n) rbind(data.train[[n]], data.test[[n]]),
               USE.NAMES=TRUE)

# Remove loaded non merged data to save memory
rm(data.train)
rm(data.test)

############################################################
# Assignment instruction 3                                 #
# Use descriptive activity names to name the activities    #
# in the data set.                                         #
# Assignment instruction 4                                 #
# Appropriately label the data set with descriptive        #
# activity names.                                          #
############################################################

message(paste("\nAdd activity labels and feature names to data sets",
              "(ASSIGNMENT INSTRUCTION 3-4)"))

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

# Put feature names as column names for the 561-feature vectors data set
old.names <- paste0("V", 1:(ncol(data$X) - 2))
names(data$X)[match(old.names, names(data$X))] <- features$feature

# Name columns in subject and activity list data sets
names(data$subject)[match("V1", names(data$subject))] <- c("subject")
names(data$y)[match("V1", names(data$y))] <- c("activityCode")

# Add new columns with subject and activity data to 
# the 561-feature vectors data set

info <- merge(merge(data$y, data$subject, by="idx"), activity_labels, 
	      by="activityCode")

info$activityCode <- NULL

info <- info[order(info$idx),]

# Compute the window number for the rolling time series for each subject and 
# activity
# Create also a window count data set that will be used later
info$window <- rep(0, nrow(info))
count <- expand.grid(subject=unique(info$subject), 
		     activity=levels(info$activity))
count$windowcount <- as.integer(rep(0, nrow(count)))

for (s in unique(info$subject)) {
    for (a in levels(info$activity)) {
	selector <- info[,"subject"] == s & info[,"activity"] == a
        info[selector,"window"] <- as.integer(1:nrow(info[selector,]))
	count[count$subject == s & count$activity == a, "windowcount"] <- 
	    nrow(info[selector,])
	    
    }
}

data$X$activity <- info$activity
data$X$subject <- info$subject
data$X$window <- info$window

# Once we added the subject, activity, set and window number info, we can
# remove the index, we don't need it anymore
data$X$idx <- NULL

# Order data$X columns
new.order <- c("subject", "activity", "set", "window", names(data$X))
new.order <- new.order[!duplicated(new.order)]

data$X <- data$X[,new.order]

#p <- ggplot(d=data$X[data$X[,"subject"] %in% sample(1:30, 5),], aes(x=wtime, y=fBodyAccMag_mean, color=activity)) + geom_line() + facet_wrap(subject~activity, ncol=6) + theme(text = element_text(size=9), legend.position="none") + xlim(0, 65) + xlab("Window time (seconds)") 
#ggsave(file="tseries-acc.pdf", plot=p, units="in", width=11, height=8.5)

message("\nWe have a tidy data set for the variables (non-inertial) data")
str(data$X, list.len=num.lines.info)


############################################################
# Creating tidy data set for inertial signals               #
# Extra work for fun                                       #
############################################################

# This function will add subject, activity, data set and window number data
# to an inertial signals data set.
# Then will melt it and remove duplicate samples (rolling windows has 50%
# overlap)
make.inertial4tidy <- function (n) {
    message(sprintf("    %s", n))
    z <- merge(data[[n]], info, by="idx")
    z <- z[order(z$idx),]
    z <- melt(z, id=c("subject", "activity", "window"))
    reduced.sample <- rep((1:128), length.out=nrow(z))
    z$sample <- as.integer((z$window - 1) * 64 + reduced.sample)
    z$idx <- NULL
    z$variable <- NULL
    z$window <- NULL
    dup.samples <- duplicated(z[,c("subject", "activity", "sample")])
    z <- z[!dup.samples,]
    names(z)[match("value", names(z))] <- substr(n, nchar(n), nchar(n))
    z
}

if (!ignore.inertial) {
    message("\nProcessing inertial signals data")
    names.inertial <- grep("acc|gyro", names.train, value=TRUE)
    names(names.inertial) <- names.inertial

    message("Reorganizing and labelling data in inertial signal data sets")
    inertial4tidy <- lapply(names.inertial, make.inertial4tidy)

    message("Merging into categories (total_acc, body_acc, body_gyro)")
    message("    total_acc")
    total_acc <- Reduce(function(x,y) {merge(x,y)}, 
		   inertial4tidy[grep("^total_acc_", names.inertial, 
				      value=TRUE)])

    message("    body_acc")
    body_acc <- Reduce(function(x,y) {merge(x,y)}, 
    		   inertial4tidy[grep("^body_acc_", names.inertial, 
				      value=TRUE)])

    message("    body_gyro")
    body_gyro <- Reduce(function(x,y) {merge(x,y)}, 
		   inertial4tidy[grep("^body_gyro_", names.inertial, 
				      value=TRUE)])

    # Free some memeory by removing intermediate data
    rm(inertial4tidy)

    message("Melting and relabelling total_acc for final merge")
    total_acc <- melt(total_acc, id=c("subject", "activity", "sample"))
    names(total_acc)[match(c("variable", "value"), names(total_acc))] <- 
	                                           c("component", "total_acc")
    total_acc <- total_acc[order(total_acc$subject, 
				 total_acc$activity,
				 total_acc$sample,
				 total_acc$component
				 ),]

    message("Melting and relabelling body_acc for final merge")
    body_acc <- melt(body_acc, id=c("subject", "activity", "sample"))
    names(body_acc)[match(c("variable", "value"), names(body_acc))] <- 
	                                           c("component", "body_acc")

    message("Melting and relabelling body_gyro for final merge")
    body_gyro <- melt(body_gyro, id=c("subject", "activity", "sample"))
    names(body_gyro)[match(c("variable", "value"), names(body_gyro))] <- 
	                                           c("component", "body_gyro")

    message(paste("\nCreating tidy data set with all inertial signals data", 
		  "(this may take some time...)"))
    message("Merging total_acc and body_acc first...")
    temp <- merge(total_acc, body_acc)

    # Free some memeory by removing intermediate data
    rm(total_acc)
    rm(body_acc)

    message("Merging body_gyro to the result")
    data.inertial.tidy <- merge(temp, body_gyro)

    # Free some memeory by removing intermediate data
    rm(temp)
    rm(body_gyro)

    # Order the data set
    data.inertial.tidy <- data.inertial.tidy[order(data.inertial.tidy$subject,
                                                   data.inertial.tidy$activity,
                                                   data.inertial.tidy$sample,
                                                   data.inertial.tidy$component
						   ),]
    message("Done! (stored in variable \'data.inertial.tidy\')")
    str(data.inertial.tidy, list.len=10)

}

############################################################
# Assignment instruction 2                                 #
# Extract only the measurements on the mean and standard   #
# deviation for each measurement.                          #                                     
############################################################

message(paste("\nCreating tidy data set containing only means and standard",
              "deviations (ASSIGNMENT INSTRUCTION 2)"))

# Select columns for mean/sd data set by searching for the strings 
# "mean()" and "std()" in the column names (features)
names.mean.sd <- c("subject", "activity", "window",
                   grep("std|mean", 
                        names(data$X), value=TRUE))

# Create tidy mean/sd data set
data.mean.sd <- data$X[,names.mean.sd]
str(data.mean.sd, list.len=num.lines.info)

############################################################
# Assignment instruction 5                                 #
# Create a second, independent tidy data set with the      #
# average of each variable for each activity and each      #
# subject.                                                 #                       
############################################################

message(paste("\nCreating tidy data set with averages per subject/activity", 
	      "(ASSIGNMENT INSTRUCTION 5)"))
averages.tidy <- aggregate(. ~ subject + activity, data=data$X, 
			       FUN=mean)

averages.tidy$window <- NULL
averages.tidy$set <- NULL

averages.tidy <- merge(averages.tidy, count, by=c("subject", "activity"))

# Let's order columns more conveniently
new.order <- c("subject", "activity", "windowcount", names(averages.tidy))
new.order <- new.order[!duplicated(new.order)]

averages.tidy <- averages.tidy[, new.order]

# Order data set rows for nicer output
averages.tidy <- averages.tidy[order(averages.tidy$subject, 
				     averages.tidy$activity),]


str(averages.tidy, list.len=num.lines.info)

message(sprintf(paste("\nWriting tidy data set with averages per", 
		      "subject/activity to \"%s\""), tidy.averages.file))
# Write tidy data set with averages to file
write.table(averages.tidy, file=tidy.averages.file, row.names=FALSE)

message("Finished processing. Bye!")

################################################################################
##                                                                            ##
## End of file                                                                ##
################################################################################
