getting-cleaning-data
=====================

Course project for the Getting and Cleaning Data course, part of the Coursera 
Data Science Specialization

All the processing is done by the script `run_analysis.R`. Which prints messages
along the way describing the tasks it's performing.

The script performs the following steps:

Conditional download
--------------------

Checks if the zip file with the data exists in the working directory, otherwise 
download from the provided URL and save it to `UCI_HAR_Dataset.zip`. Upon 
download save a timestamp to "download_timestamp.txt".

Analize ZIP file
----------------

Analize the ZIP file structure. The complete list of ZIP file contents is 
retrieved and then files are classified, according to filename patterns, into
 metadata ("activity_labels.txt", "features.txt"), training data (files ending 
in "_train.txt"), or test data (filenames ending in "_test.txt"). Non text, 
zero size files, files in the folder "Inertial Signals", or files not 
belonging to these three categories are ignored.

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

Add descriptive names and label the data
----------------------------------------

There are two main steps here. First adding the 561 column names to 
the data[["X"]] data frame. The column names are loaded from 
"feature_info.txt".There is an issue here, that the list of names appearing in 
the file has duplicates (see for example lines 390 and 404 of the text file), 
and the corresponding columns in data[["X"]] contain different numbers. 
My choice in this case was to rename the duplicated columns names using 
suffixes ("-DUP1", "-DUP2", etc.) and keep all the data. After renaming the 
duplicated the column labeling is done with:

```
names(data[["X"]]) <- features$feature
```

Second, merging the subject and activity data (loaded under the names `subject` 
and `y`), and the activity labels (loaded as metadata from "activity_labels.txt"
 into the variable `activity_labels`). This is done with the command:

```
info <- merge(data.frame(data[["y"]], data[["subject"]]), activity_labels, 
              by="activityCode")
```

Now, we have a tidy dataset with labelled columns and activities.


Extract the means and standard deviations
-----------------------------------------

A subset of column names is selected searching with the command `grep` for the
strings "mean()" and "std()" in the names and keeping the names for activity and
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
under the name "averages-tidy.txt". This is the only disk output of the script 
(apart from the data download timestamp).

