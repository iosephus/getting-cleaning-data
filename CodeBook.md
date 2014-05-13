Codebook for the Getting and Cleaning Data course project
=========================================================

A brief description of how the data, as organized in the original files, will be
given, followed by an explanation of how the data is organized in the tidy data 
sets created by the processing script (*run_analysis.R*).

Original data sets
------------------

###Documentation files

Two explanatory files can be found in the root folder of the data set 
(*'UCI HAR Dataset'*). 

The file *README.txt* describes the experiment design 
and how the data was gathered, It also describes the general organization of 
the data set files, and the filtering scheme and rolling windows procedure used 
to generate the inertial data vectors from the raw sensor data. It also mentions
that features were derived from the inertial data vectors and refers to
*features_info.txt* for a description.
 
The file *features_info.txt* contains a description of the magnitudes computed
for each inertial data vector and the statistical feature calculated for them 
(mean, standard deviation, min, max, etc.), which form the columns in the 
features data set.

### Metadata

Two files with metadata can be found in the dataset. The file *features.txt*
contains two columns, one with an index and a second column with the feature
name. The index ranging from 1 to 561 denotes the column for that feature in
the feature data file. The file *activity_labels.txt* contains two columns
(convertible to integer and string respectively) that describe the association
between the activity codes in the other data sets and the names of the
activities.

This two metadata files are key to be able to properly label the tidy datasets 
later.

### Data

The original data set is divided in a training and a test set, which are
contained in two different folders with the self explanatory names *train* and
*test*. Each of these folder contains the following structure:

X_train.txt
y_train.txt
subject_train.txt
Inertial Signals/total_acc_x_train.txt
Inertial Signals/total_acc_y_train.txt
Inertial Signals/total_acc_z_train.txt
Inertial Signals/body_acc_x_train.txt
Inertial Signals/body_acc_y_train.txt
Inertial Signals/body_acc_z_train.txt
Inertial Signals/body_gyro_x_train.txt
Inertial Signals/body_gyro_y_train.txt
Inertial Signals/body_gyro_z_train.txt

The structure for the *train* folder is shown here, replacing the string 
"_train" for "_test" would give the structure for the *test* folder. The file
*X_train.txt* contains the 561 features vectors, and the files *y_train.txt* and
*subject_train.txt* contain the activity codes and subject codes for the rows in
"X_train.txt" (The same applies for the *test* folder with appropriate name
substitution). The *Inertial Signals* folder contains one file for each 
variable and component with the structure *<variable>_<component>_<set>.txt*.
For example the *total_acc_x_train.txt* contains the *x* component of the total 
acceleration *total_acc* for the training set. All the data files for a given
set (training/test) have the same number of rows, since the features in the "X"
file have been derived for each rolling time window in the inertial signal 
files.

An important thing to note is that since the rolling 2.56 seconds windows have 
50% overlap each 128 sample vector in the inertial data files have duplicated 
data with the first 64 values in each vector being the same as the last 64 in 
the previous vector for a given subject/activity combination. This is important 
to generate a tidy data set for the inertial data.These samples correspond to a 
time series with samples separated by a 0.02 seconds interval, corresponding to
a sampling frequency of 50 Hz..

Tidy data sets
--------------

The tidy data sets contain data from the original data sets, that has been 
reorganized, by operations such as merging, melting (combining different 
columns into a single one with an additional column describing the original
column for the variable), and differentiating or removing duplicates when
needed. Some new information that is implicit in the original data set have been
added, this is the case of the temporal window number for the features and the
sample number for the inertial data.  

The next sections describe the columns for the tidy data sets.

### Features

This tidy data set of feature is stored in the variable data$X. It has the
following columns:

| Column name | Type    | Possible values   | Description                      |
|-------------|---------|-------------------|----------------------------------|
| subject     | Integer | Range 1-30        | Experimental subject             |
| activity    | Factor  | 'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING' | Experimental activity |
| window      | Integer | Positive integers | Number of the time window from which the feature was extracted. |
| set         | Factor  | 'Training', 'Test'| Whether the row was originally in
the training or test set.




