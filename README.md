getting-cleaning-data
=====================

**WARNING: This is not the master branch of this repository. This branch was 
only created for testing. Please, switch to the master branch to perform the 
evaluation.**

Course project for the Getting and Cleaning Data course, part of the Coursera 
Data Science Specialization

All the processing is done by the script *run_analysis.R*. Which prints messages
along the way describing the tasks it's performing.

The script performs the following steps:

Conditional download
--------------------

Checks if the zip file with the data exists in the working directory, otherwise 
download from the provided URL and save it to *UCI_HAR_Dataset.zip*. Upon 
download save a timestamp to *download_timestamp.txt*.

Analize ZIP file
----------------

Analize the ZIP file structure. The complete list of ZIP file contents is 
retrieved and then files are classified, according to filename patterns, into
 metadata (*activity_labels.txt*, *features.txt*), training data (files ending 
in '_train.txt'), or test data (filenames ending in '_test.txt'). Non text, 
zero size files, or files not belonging to these three categories are ignored.

In this step one list of files is created for each category, to be able to load 
the files to data frames at with a single line of code using an `lapply` 
command. The loading list would look like the following:

```
load.list.train <- list(subject="UCI HAR Dataset/train/subject_train.txt", 
                        X="UCI HAR Dataset/train/X_train.txt", 
                        y="UCI HAR Dataset/train/y_train.txt"))
```

Please, note that the literal on the right is included here for documentation 
purposes only. In the real code, the list is built automatically and the code is
different.

Load the data
-------------

Load the data in a single line of code for each load list using lapply on the
load list and specifying the loading function in the FUN argument.

```
data.train <- lapply(load.list.train, 
                     function(f) load.with.msg(raw.data.file, f))
```

The result is a list in which the names are the same as the load list, but the 
items are data frames containing the data from each file. Each data frame can 
be referenced using the list and the corresponding name: `data.train$X` or 
`data.train[["X"]]`.

The advantage of this method is that as the amount of files grow you don't need
to remember all the names in the loading stage and the code is reusable for
other similar files, because the names are determined automatically. It also
makes very easy the data merging.

Merge the training and test set
-------------------------------

The test and trains are stored in a similar set of file, whose names only differ
in a suffix before the extension ("_train.txt", "_test.txt"). Thanks to this,
our loading list for both cases have the same names for the data frames and can
be merged easily with:

```
data <- sapply(names.train, 
               FUN=function (n) rbind(data.train[[n]], data.test[[n]]),
               USE.NAMES=TRUE)`
```

Where `names.train` is a list of the names used in the training data loading
list (which are identical to those in the test data loading list). This easy
mergin is also possible beacuse the training and test data files have the same
number of columns containing the same variables for each case. Now, the list
`data` contains a series of data frames with the merged data, with a name for
each file loaded.
All data is indexed when loaded, and the index is used in several merging steps 
in which order to avoid messing the order or the windows. 

Add descriptive names and label the data
----------------------------------------

There are three main steps here. First adding the 561 column names to 
the data[["X"]] data frame. The column names are loaded from 
*feature_info.txt*, and cleaned by removing or replacing the characters that are
not allowed in R data frame column names. Periods are also replaced by
underscores for MongoDB compatibility.

There is an issue here with the columns names, that the list of names appearing 
in the file has duplicates (see for example lines 390, 404 and 418 of the text 
file), and the corresponding columns in data[["X"]] contain different numbers. 
My choice in this case was to rename the duplicated columns names using 
suffixes ("-DUP1", "-DUP2", etc.) and keep all the data. After renaming the 
duplicated the column labeling is done with:

```
names(data[["X"]]) <- features$feature
```

Second, merging the subject and activity data (loaded under the names `subject` 
and `y`), and the activity labels (loaded as metadata from *activity_labels.txt*
 into the variable `activity_labels`). This is done with the command:

```
info <- merge(data.frame(data[["y"]], data[["subject"]]), activity_labels, 
              by="activityCode")
```

Third, computing the time correspoding to each window. Each row we have for a
subject/activity pair, corresponds to a position of the 2.56 seconds rolling
window. The resulting windows are 2.56 seconds wide and have a 50% overlap,
the separation between two neighboring windows is thus 1.28 seconds. I've taken 
the time for each window at it's center, so the very first window has time 1.28,
and the subsequent ones have times in increments of that same value. Different
subject/activity pairs have different number of windows measured. The column
with the times is computed by the following piece of code:

```
info$time <- rep(0.0, nrow(info))

for (s in unique(info$subject)) {
    for (a in unique(info$activity)) {
	selector <- info[,"subject"] == s & info[,"activity"] == a
        info[selector,"time"] <- seq(1, nrow(info[selector,])) * twindow.sep
    }
}
```

Finally, the three columns `subject`, `activity`, and `time`, are added to the 
561-columns data frame in `data$X`. Now, we have a tidy dataset with labelled 
columns and activities.

Inertial signals data
~~~~~~~~~~~~~~~~~~~~~

The data corresponding to the inertial signals is also loaded and a tidy,
conveniently labelled data set is created for it. Since this data has a
structure that is different from the data for the derived variables, it has to
be kept in a separate dataset. Please, refer to the last section with example 
output, to see how these two data sets are organized. 

Extract the means and standard deviations
-----------------------------------------

A subset of column names is selected searching with the command `grep` for the
strings 'mean()' and 'std()' in the names and keeping the names for activity and
subject. The variables of the type "meanFreq" are not selected, I choose to 
ignore them, since they are not simple means of variables, but a weighted mean 
of the frequencies.

Once the list is built a new data frame is created containing the same number of
rows, and only the selected columns.

Create the data set with subject/activity averages
--------------------------------------------------

This is done applying the function `aggregate` to the original tidy data set 
(containing all original variables). A single command does it:

```
averages.tidy <- aggregate(. ~ subject + activity, data=data[["X"]], 
                           FUN=mean)
```

This data frame will be saved as a text file with field separate by spaces,
under the name *averages-tidy.txt*. Given how the `time` column was 
constructed, it's average is half the total time during which data was collected
for that subject and activity. The file *averages-tidy.txt* is the only disk 
output of the script (apart from the data download timestamp).

Example output
--------------

```
iosephus@whitehorse:~/src/getting-cleaning-data$ Rscript run_analysis.R

Getting list of files in "UCI_HAR_Dataset.zip"...
Found 28 text files with size greater than zero.
Keeping only relevant files (26):
    2 files with metadata.
    12 files with training data.
    12 files with test data.
Checking if same files exist for training and test data: TRUE

Loading metadata...
    "UCI HAR Dataset/activity_labels.txt"
    "UCI HAR Dataset/features.txt"
Loading training data (can take some time...)
    "UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt"
    "UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt"
    "UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt"
    "UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt"
    "UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt"
    "UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt"
    "UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt"
    "UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt"
    "UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt"
    "UCI HAR Dataset/train/subject_train.txt"
    "UCI HAR Dataset/train/X_train.txt"
    "UCI HAR Dataset/train/y_train.txt"
Loading test data (can take some time...)
    "UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt"
    "UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt"
    "UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt"
    "UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt"
    "UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt"
    "UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt"
    "UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt"
    "UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt"
    "UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt"
    "UCI HAR Dataset/test/subject_test.txt"
    "UCI HAR Dataset/test/X_test.txt"
    "UCI HAR Dataset/test/y_test.txt"
Checking if training and test data sets have same number of columns: TRUE
Adding index and set identifier (Training/Test) before merging

Merging training and test data sets (ASSIGNMENT INSTRUCTION 1)

Add activity labels and feature names to data sets (ASSIGNMENT INSTRUCTION 3-4)
Deduplicating feature names (keeping all data)

We have a tidy data set for the variables (non-inertial) data
'data.frame':	10299 obs. of  565 variables:
 $ subject                            : int  1 1 1 1 1 1 1 1 1 1 ...
 $ activity                           : Factor w/ 6 levels "LAYING","SITTING",..: 3 3 3 3 3 3 3 3 3 3 ...
 $ set                                : Factor w/ 2 levels "Training","Test": 1 1 1 1 1 1 1 1 1 1 ...
 $ window                             : num  1 2 3 4 5 6 7 8 9 10 ...
 $ tBodyAcc_mean_X                    : num  0.289 0.278 0.28 0.279 0.277 ...
 $ tBodyAcc_mean_Y                    : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
 $ tBodyAcc_mean_Z                    : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
 $ tBodyAcc_std_X                     : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
 $ tBodyAcc_std_Y                     : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
 $ tBodyAcc_std_Z                     : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
 $ tBodyAcc_mad_X                     : num  -0.995 -0.999 -0.997 -0.997 -0.998 ...
 $ tBodyAcc_mad_Y                     : num  -0.983 -0.975 -0.964 -0.983 -0.98 ...
  [list output truncated]

Processing inertial signals data
Reorganizing and labelling data in inertial signal data sets
    body_acc_x
    body_acc_y
    body_acc_z
    body_gyro_x
    body_gyro_y
    body_gyro_z
    total_acc_x
    total_acc_y
    total_acc_z
Merging into categories (total_acc, body_acc, body_gyro)
    total_acc
    body_acc
    body_gyro
Melting and relabelling total_acc for final merge
Melting and relabelling body_acc for final merge
Melting and relabelling body_gyro for final merge

Creating tidy data set with all inertial signals data (this may take some time...)
Merging total_acc and body_acc first...
Merging body_gyro to the result
Done! (stored in variable 'data.inertial.tidy')
'data.frame':	2011968 obs. of  7 variables:
 $ subject  : int  1 1 1 1 1 1 1 1 1 1 ...
 $ activity : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
 $ sample   : int  1 1 1 2 2 2 3 3 3 4 ...
 $ component: Factor w/ 3 levels "x","y","z": 1 2 3 1 2 3 1 2 3 1 ...
 $ total_acc: chr  "0.1817778" "0.7400756" "0.5840367" "0.201486" ...
 $ body_acc : chr  "0.07035597" "-0.04852346" "-0.006084994" "0.1018921" ...
 $ body_gyro: chr  "-0.008240117" "0.1404171" "0.3030315" "0.116828" ...

Creating tidy data set containing only means and standard deviations (ASSIGNMENT INSTRUCTION 2)
'data.frame':	10299 obs. of  82 variables:
 $ subject                      : int  1 1 1 1 1 1 1 1 1 1 ...
 $ activity                     : Factor w/ 6 levels "LAYING","SITTING",..: 3 3 3 3 3 3 3 3 3 3 ...
 $ window                       : num  1 2 3 4 5 6 7 8 9 10 ...
 $ tBodyAcc_mean_X              : num  0.289 0.278 0.28 0.279 0.277 ...
 $ tBodyAcc_mean_Y              : num  -0.0203 -0.0164 -0.0195 -0.0262 -0.0166 ...
 $ tBodyAcc_mean_Z              : num  -0.133 -0.124 -0.113 -0.123 -0.115 ...
 $ tBodyAcc_std_X               : num  -0.995 -0.998 -0.995 -0.996 -0.998 ...
 $ tBodyAcc_std_Y               : num  -0.983 -0.975 -0.967 -0.983 -0.981 ...
 $ tBodyAcc_std_Z               : num  -0.914 -0.96 -0.979 -0.991 -0.99 ...
 $ tGravityAcc_mean_X           : num  0.963 0.967 0.967 0.968 0.968 ...
 $ tGravityAcc_mean_Y           : num  -0.141 -0.142 -0.142 -0.144 -0.149 ...
 $ tGravityAcc_mean_Z           : num  0.1154 0.1094 0.1019 0.0999 0.0945 ...
  [list output truncated]

Creating tidy data set with averages per subject/activity (ASSIGNMENT INSTRUCTION 5)
'data.frame':	180 obs. of  564 variables:
 $ subject                            : int  1 1 1 1 1 1 2 2 2 2 ...
 $ activity                           : Factor w/ 6 levels "LAYING","SITTING",..: 1 2 3 4 5 6 1 2 3 4 ...
 $ windowcount                        : int  50 47 53 95 49 53 48 46 54 59 ...
 $ tBodyAcc_mean_X                    : num  0.222 0.261 0.279 0.277 0.289 ...
 $ tBodyAcc_mean_Y                    : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
 $ tBodyAcc_mean_Z                    : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
 $ tBodyAcc_std_X                     : num  -0.928 -0.977 -0.996 -0.284 0.03 ...
 $ tBodyAcc_std_Y                     : num  -0.8368 -0.9226 -0.9732 0.1145 -0.0319 ...
 $ tBodyAcc_std_Z                     : num  -0.826 -0.94 -0.98 -0.26 -0.23 ...
 $ tBodyAcc_mad_X                     : num  -0.9321 -0.9795 -0.9961 -0.3407 -0.0441 ...
 $ tBodyAcc_mad_Y                     : num  -0.8409 -0.9197 -0.9718 0.0618 -0.1074 ...
 $ tBodyAcc_mad_Z                     : num  -0.822 -0.939 -0.979 -0.25 -0.212 ...
  [list output truncated]

Writing tidy data set with averages per subject/activity to "averages-tidy.txt"
Finished processing. Bye!
```
