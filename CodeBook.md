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

- 'X_train.txt'
- 'y_train.txt'
- 'subject_train.txt'
- 'Inertial Signals/total_acc_x_train.txt'
- 'Inertial Signals/total_acc_y_train.txt'
- 'Inertial Signals/total_acc_z_train.txt'
- 'Inertial Signals/body_acc_x_train.txt'
- 'Inertial Signals/body_acc_y_train.txt'
- 'Inertial Signals/body_acc_z_train.txt'
- 'Inertial Signals/body_gyro_x_train.txt'
- 'Inertial Signals/body_gyro_y_train.txt'
- 'Inertial Signals/body_gyro_z_train.txt'

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
| subject     | Integer | Interval [1, 30]     | Experimental subject             |
| activity    | Factor  | Set {'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'} | Experimental activity |
| set         | Factor  | Set {'Training', 'Test'} | Whether the row was originally in the training or test set |
| window      | Integer | Interval [1, 95] | Number of the time window from which the feature was extracted. |
| tBodyAcc_mean_X | Double | Interval [-1, 1] | Feature                          
| tBodyAcc_mean_Y | Double | Interval [-1, 1] | Feature 
| tBodyAcc_mean_Z | Double | Interval [-1, 1] | Feature 
| tBodyAcc_std_X | Double | Interval [-1, 1] | Feature 
| tBodyAcc_std_Y | Double | Interval [-1, 1] | Feature 
| tBodyAcc_std_Z | Double | Interval [-1, 1] | Feature 
| tBodyAcc_mad_X | Double | Interval [-1, 1] | Feature 
| tBodyAcc_mad_Y | Double | Interval [-1, 1] | Feature 
| tBodyAcc_mad_Z | Double | Interval [-1, 1] | Feature 
| tBodyAcc_max_X | Double | Interval [-1, 1] | Feature 
| tBodyAcc_max_Y | Double | Interval [-1, 1] | Feature 
| tBodyAcc_max_Z | Double | Interval [-1, 1] | Feature 
| tBodyAcc_min_X | Double | Interval [-1, 1] | Feature 
| tBodyAcc_min_Y | Double | Interval [-1, 1] | Feature 
| tBodyAcc_min_Z | Double | Interval [-1, 1] | Feature 
| tBodyAcc_sma | Double | Interval [-1, 1] | Feature 
| tBodyAcc_energy_X | Double | Interval [-1, 1] | Feature 
| tBodyAcc_energy_Y | Double | Interval [-1, 1] | Feature 
| tBodyAcc_energy_Z | Double | Interval [-1, 1] | Feature 
| tBodyAcc_iqr_X | Double | Interval [-1, 1] | Feature 
| tBodyAcc_iqr_Y | Double | Interval [-1, 1] | Feature 
| tBodyAcc_iqr_Z | Double | Interval [-1, 1] | Feature 
| tBodyAcc_entropy_X | Double | Interval [-1, 1] | Feature 
| tBodyAcc_entropy_Y | Double | Interval [-1, 1] | Feature 
| tBodyAcc_entropy_Z | Double | Interval [-1, 1] | Feature 
| tBodyAcc_arCoeff_X_1 | Double | Interval [-1, 1] | Feature 
| tBodyAcc_arCoeff_X_2 | Double | Interval [-1, 1] | Feature 
| tBodyAcc_arCoeff_X_3 | Double | Interval [-1, 1] | Feature 
| tBodyAcc_arCoeff_X_4 | Double | Interval [-1, 1] | Feature 
| tBodyAcc_arCoeff_Y_1 | Double | Interval [-1, 1] | Feature 
| tBodyAcc_arCoeff_Y_2 | Double | Interval [-1, 1] | Feature 
| tBodyAcc_arCoeff_Y_3 | Double | Interval [-1, 1] | Feature 
| tBodyAcc_arCoeff_Y_4 | Double | Interval [-1, 1] | Feature 
| tBodyAcc_arCoeff_Z_1 | Double | Interval [-1, 1] | Feature 
| tBodyAcc_arCoeff_Z_2 | Double | Interval [-1, 1] | Feature 
| tBodyAcc_arCoeff_Z_3 | Double | Interval [-1, 1] | Feature 
| tBodyAcc_arCoeff_Z_4 | Double | Interval [-1, 1] | Feature 
| tBodyAcc_correlation_X_Y | Double | Interval [-1, 1] | Feature 
| tBodyAcc_correlation_X_Z | Double | Interval [-1, 1] | Feature 
| tBodyAcc_correlation_Y_Z | Double | Interval [-1, 1] | Feature 
| tGravityAcc_mean_X | Double | Interval [-1, 1] | Feature 
| tGravityAcc_mean_Y | Double | Interval [-1, 1] | Feature 
| tGravityAcc_mean_Z | Double | Interval [-1, 1] | Feature 
| tGravityAcc_std_X | Double | Interval [-1, 1] | Feature 
| tGravityAcc_std_Y | Double | Interval [-1, 1] | Feature 
| tGravityAcc_std_Z | Double | Interval [-1, 1] | Feature 
| tGravityAcc_mad_X | Double | Interval [-1, 1] | Feature 
| tGravityAcc_mad_Y | Double | Interval [-1, 1] | Feature 
| tGravityAcc_mad_Z | Double | Interval [-1, 1] | Feature 
| tGravityAcc_max_X | Double | Interval [-1, 1] | Feature 
| tGravityAcc_max_Y | Double | Interval [-1, 1] | Feature 
| tGravityAcc_max_Z | Double | Interval [-1, 1] | Feature 
| tGravityAcc_min_X | Double | Interval [-1, 1] | Feature 
| tGravityAcc_min_Y | Double | Interval [-1, 1] | Feature 
| tGravityAcc_min_Z | Double | Interval [-1, 1] | Feature 
| tGravityAcc_sma | Double | Interval [-1, 1] | Feature 
| tGravityAcc_energy_X | Double | Interval [-1, 1] | Feature 
| tGravityAcc_energy_Y | Double | Interval [-1, 1] | Feature 
| tGravityAcc_energy_Z | Double | Interval [-1, 1] | Feature 
| tGravityAcc_iqr_X | Double | Interval [-1, 1] | Feature 
| tGravityAcc_iqr_Y | Double | Interval [-1, 1] | Feature 
| tGravityAcc_iqr_Z | Double | Interval [-1, 1] | Feature 
| tGravityAcc_entropy_X | Double | Interval [-1, 1] | Feature 
| tGravityAcc_entropy_Y | Double | Interval [-1, 1] | Feature 
| tGravityAcc_entropy_Z | Double | Interval [-1, 1] | Feature 
| tGravityAcc_arCoeff_X_1 | Double | Interval [-1, 1] | Feature 
| tGravityAcc_arCoeff_X_2 | Double | Interval [-1, 1] | Feature 
| tGravityAcc_arCoeff_X_3 | Double | Interval [-1, 1] | Feature 
| tGravityAcc_arCoeff_X_4 | Double | Interval [-1, 1] | Feature 
| tGravityAcc_arCoeff_Y_1 | Double | Interval [-1, 1] | Feature 
| tGravityAcc_arCoeff_Y_2 | Double | Interval [-1, 1] | Feature 
| tGravityAcc_arCoeff_Y_3 | Double | Interval [-1, 1] | Feature 
| tGravityAcc_arCoeff_Y_4 | Double | Interval [-1, 1] | Feature 
| tGravityAcc_arCoeff_Z_1 | Double | Interval [-1, 1] | Feature 
| tGravityAcc_arCoeff_Z_2 | Double | Interval [-1, 1] | Feature 
| tGravityAcc_arCoeff_Z_3 | Double | Interval [-1, 1] | Feature 
| tGravityAcc_arCoeff_Z_4 | Double | Interval [-1, 1] | Feature 
| tGravityAcc_correlation_X_Y | Double | Interval [-1, 1] | Feature 
| tGravityAcc_correlation_X_Z | Double | Interval [-1, 1] | Feature 
| tGravityAcc_correlation_Y_Z | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_mean_X | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_mean_Y | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_mean_Z | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_std_X | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_std_Y | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_std_Z | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_mad_X | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_mad_Y | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_mad_Z | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_max_X | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_max_Y | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_max_Z | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_min_X | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_min_Y | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_min_Z | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_sma | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_energy_X | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_energy_Y | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_energy_Z | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_iqr_X | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_iqr_Y | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_iqr_Z | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_entropy_X | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_entropy_Y | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_entropy_Z | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_arCoeff_X_1 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_arCoeff_X_2 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_arCoeff_X_3 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_arCoeff_X_4 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_arCoeff_Y_1 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_arCoeff_Y_2 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_arCoeff_Y_3 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_arCoeff_Y_4 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_arCoeff_Z_1 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_arCoeff_Z_2 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_arCoeff_Z_3 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_arCoeff_Z_4 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_correlation_X_Y | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_correlation_X_Z | Double | Interval [-1, 1] | Feature 
| tBodyAccJerk_correlation_Y_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyro_mean_X | Double | Interval [-1, 1] | Feature 
| tBodyGyro_mean_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyro_mean_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyro_std_X | Double | Interval [-1, 1] | Feature 
| tBodyGyro_std_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyro_std_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyro_mad_X | Double | Interval [-1, 1] | Feature 
| tBodyGyro_mad_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyro_mad_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyro_max_X | Double | Interval [-1, 1] | Feature 
| tBodyGyro_max_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyro_max_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyro_min_X | Double | Interval [-1, 1] | Feature 
| tBodyGyro_min_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyro_min_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyro_sma | Double | Interval [-1, 1] | Feature 
| tBodyGyro_energy_X | Double | Interval [-1, 1] | Feature 
| tBodyGyro_energy_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyro_energy_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyro_iqr_X | Double | Interval [-1, 1] | Feature 
| tBodyGyro_iqr_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyro_iqr_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyro_entropy_X | Double | Interval [-1, 1] | Feature 
| tBodyGyro_entropy_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyro_entropy_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyro_arCoeff_X_1 | Double | Interval [-1, 1] | Feature 
| tBodyGyro_arCoeff_X_2 | Double | Interval [-1, 1] | Feature 
| tBodyGyro_arCoeff_X_3 | Double | Interval [-1, 1] | Feature 
| tBodyGyro_arCoeff_X_4 | Double | Interval [-1, 1] | Feature 
| tBodyGyro_arCoeff_Y_1 | Double | Interval [-1, 1] | Feature 
| tBodyGyro_arCoeff_Y_2 | Double | Interval [-1, 1] | Feature 
| tBodyGyro_arCoeff_Y_3 | Double | Interval [-1, 1] | Feature 
| tBodyGyro_arCoeff_Y_4 | Double | Interval [-1, 1] | Feature 
| tBodyGyro_arCoeff_Z_1 | Double | Interval [-1, 1] | Feature 
| tBodyGyro_arCoeff_Z_2 | Double | Interval [-1, 1] | Feature 
| tBodyGyro_arCoeff_Z_3 | Double | Interval [-1, 1] | Feature 
| tBodyGyro_arCoeff_Z_4 | Double | Interval [-1, 1] | Feature 
| tBodyGyro_correlation_X_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyro_correlation_X_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyro_correlation_Y_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_mean_X | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_mean_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_mean_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_std_X | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_std_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_std_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_mad_X | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_mad_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_mad_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_max_X | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_max_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_max_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_min_X | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_min_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_min_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_sma | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_energy_X | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_energy_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_energy_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_iqr_X | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_iqr_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_iqr_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_entropy_X | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_entropy_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_entropy_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_arCoeff_X_1 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_arCoeff_X_2 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_arCoeff_X_3 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_arCoeff_X_4 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_arCoeff_Y_1 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_arCoeff_Y_2 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_arCoeff_Y_3 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_arCoeff_Y_4 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_arCoeff_Z_1 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_arCoeff_Z_2 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_arCoeff_Z_3 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_arCoeff_Z_4 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_correlation_X_Y | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_correlation_X_Z | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerk_correlation_Y_Z | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_mean | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_std | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_mad | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_max | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_min | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_sma | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_energy | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_iqr | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_entropy | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_arCoeff1 | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_arCoeff2 | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_arCoeff3 | Double | Interval [-1, 1] | Feature 
| tBodyAccMag_arCoeff4 | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_mean | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_std | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_mad | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_max | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_min | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_sma | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_energy | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_iqr | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_entropy | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_arCoeff1 | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_arCoeff2 | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_arCoeff3 | Double | Interval [-1, 1] | Feature 
| tGravityAccMag_arCoeff4 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_mean | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_std | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_mad | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_max | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_min | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_sma | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_energy | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_iqr | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_entropy | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_arCoeff1 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_arCoeff2 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_arCoeff3 | Double | Interval [-1, 1] | Feature 
| tBodyAccJerkMag_arCoeff4 | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_mean | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_std | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_mad | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_max | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_min | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_sma | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_energy | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_iqr | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_entropy | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_arCoeff1 | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_arCoeff2 | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_arCoeff3 | Double | Interval [-1, 1] | Feature 
| tBodyGyroMag_arCoeff4 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_mean | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_std | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_mad | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_max | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_min | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_sma | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_energy | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_iqr | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_entropy | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_arCoeff1 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_arCoeff2 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_arCoeff3 | Double | Interval [-1, 1] | Feature 
| tBodyGyroJerkMag_arCoeff4 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_mean_X | Double | Interval [-1, 1] | Feature 
| fBodyAcc_mean_Y | Double | Interval [-1, 1] | Feature 
| fBodyAcc_mean_Z | Double | Interval [-1, 1] | Feature 
| fBodyAcc_std_X | Double | Interval [-1, 1] | Feature 
| fBodyAcc_std_Y | Double | Interval [-1, 1] | Feature 
| fBodyAcc_std_Z | Double | Interval [-1, 1] | Feature 
| fBodyAcc_mad_X | Double | Interval [-1, 1] | Feature 
| fBodyAcc_mad_Y | Double | Interval [-1, 1] | Feature 
| fBodyAcc_mad_Z | Double | Interval [-1, 1] | Feature 
| fBodyAcc_max_X | Double | Interval [-1, 1] | Feature 
| fBodyAcc_max_Y | Double | Interval [-1, 1] | Feature 
| fBodyAcc_max_Z | Double | Interval [-1, 1] | Feature 
| fBodyAcc_min_X | Double | Interval [-1, 1] | Feature 
| fBodyAcc_min_Y | Double | Interval [-1, 1] | Feature 
| fBodyAcc_min_Z | Double | Interval [-1, 1] | Feature 
| fBodyAcc_sma | Double | Interval [-1, 1] | Feature 
| fBodyAcc_energy_X | Double | Interval [-1, 1] | Feature 
| fBodyAcc_energy_Y | Double | Interval [-1, 1] | Feature 
| fBodyAcc_energy_Z | Double | Interval [-1, 1] | Feature 
| fBodyAcc_iqr_X | Double | Interval [-1, 1] | Feature 
| fBodyAcc_iqr_Y | Double | Interval [-1, 1] | Feature 
| fBodyAcc_iqr_Z | Double | Interval [-1, 1] | Feature 
| fBodyAcc_entropy_X | Double | Interval [-1, 1] | Feature 
| fBodyAcc_entropy_Y | Double | Interval [-1, 1] | Feature 
| fBodyAcc_entropy_Z | Double | Interval [-1, 1] | Feature 
| fBodyAcc_maxInds_X | Double | Interval [-1, 1] | Feature 
| fBodyAcc_maxInds_Y | Double | Interval [-1, 1] | Feature 
| fBodyAcc_maxInds_Z | Double | Interval [-1, 1] | Feature 
| fBodyAcc_meanFreq_X | Double | Interval [-1, 1] | Feature 
| fBodyAcc_meanFreq_Y | Double | Interval [-1, 1] | Feature 
| fBodyAcc_meanFreq_Z | Double | Interval [-1, 1] | Feature 
| fBodyAcc_skewness_X | Double | Interval [-1, 1] | Feature 
| fBodyAcc_kurtosis_X | Double | Interval [-1, 1] | Feature 
| fBodyAcc_skewness_Y | Double | Interval [-1, 1] | Feature 
| fBodyAcc_kurtosis_Y | Double | Interval [-1, 1] | Feature 
| fBodyAcc_skewness_Z | Double | Interval [-1, 1] | Feature 
| fBodyAcc_kurtosis_Z | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_1_8-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_9_16-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_17_24-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_25_32-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_33_40-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_41_48-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_49_56-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_57_64-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_1_16-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_17_32-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_33_48-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_49_64-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_1_24-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_25_48-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_1_8-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_9_16-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_17_24-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_25_32-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_33_40-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_41_48-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_49_56-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_57_64-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_1_16-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_17_32-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_33_48-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_49_64-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_1_24-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_25_48-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_1_8-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_9_16-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_17_24-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_25_32-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_33_40-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_41_48-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_49_56-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_57_64-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_1_16-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_17_32-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_33_48-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_49_64-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_1_24-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAcc_bandsEnergy_25_48-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_mean_X | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_mean_Y | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_mean_Z | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_std_X | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_std_Y | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_std_Z | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_mad_X | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_mad_Y | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_mad_Z | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_max_X | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_max_Y | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_max_Z | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_min_X | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_min_Y | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_min_Z | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_sma | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_energy_X | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_energy_Y | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_energy_Z | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_iqr_X | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_iqr_Y | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_iqr_Z | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_entropy_X | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_entropy_Y | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_entropy_Z | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_maxInds_X | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_maxInds_Y | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_maxInds_Z | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_meanFreq_X | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_meanFreq_Y | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_meanFreq_Z | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_skewness_X | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_kurtosis_X | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_skewness_Y | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_kurtosis_Y | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_skewness_Z | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_kurtosis_Z | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_1_8-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_9_16-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_17_24-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_25_32-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_33_40-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_41_48-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_49_56-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_57_64-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_1_16-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_17_32-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_33_48-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_49_64-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_1_24-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_25_48-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_1_8-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_9_16-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_17_24-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_25_32-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_33_40-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_41_48-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_49_56-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_57_64-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_1_16-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_17_32-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_33_48-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_49_64-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_1_24-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_25_48-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_1_8-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_9_16-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_17_24-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_25_32-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_33_40-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_41_48-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_49_56-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_57_64-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_1_16-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_17_32-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_33_48-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_49_64-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_1_24-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccJerk_bandsEnergy_25_48-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_mean_X | Double | Interval [-1, 1] | Feature 
| fBodyGyro_mean_Y | Double | Interval [-1, 1] | Feature 
| fBodyGyro_mean_Z | Double | Interval [-1, 1] | Feature 
| fBodyGyro_std_X | Double | Interval [-1, 1] | Feature 
| fBodyGyro_std_Y | Double | Interval [-1, 1] | Feature 
| fBodyGyro_std_Z | Double | Interval [-1, 1] | Feature 
| fBodyGyro_mad_X | Double | Interval [-1, 1] | Feature 
| fBodyGyro_mad_Y | Double | Interval [-1, 1] | Feature 
| fBodyGyro_mad_Z | Double | Interval [-1, 1] | Feature 
| fBodyGyro_max_X | Double | Interval [-1, 1] | Feature 
| fBodyGyro_max_Y | Double | Interval [-1, 1] | Feature 
| fBodyGyro_max_Z | Double | Interval [-1, 1] | Feature 
| fBodyGyro_min_X | Double | Interval [-1, 1] | Feature 
| fBodyGyro_min_Y | Double | Interval [-1, 1] | Feature 
| fBodyGyro_min_Z | Double | Interval [-1, 1] | Feature 
| fBodyGyro_sma | Double | Interval [-1, 1] | Feature 
| fBodyGyro_energy_X | Double | Interval [-1, 1] | Feature 
| fBodyGyro_energy_Y | Double | Interval [-1, 1] | Feature 
| fBodyGyro_energy_Z | Double | Interval [-1, 1] | Feature 
| fBodyGyro_iqr_X | Double | Interval [-1, 1] | Feature 
| fBodyGyro_iqr_Y | Double | Interval [-1, 1] | Feature 
| fBodyGyro_iqr_Z | Double | Interval [-1, 1] | Feature 
| fBodyGyro_entropy_X | Double | Interval [-1, 1] | Feature 
| fBodyGyro_entropy_Y | Double | Interval [-1, 1] | Feature 
| fBodyGyro_entropy_Z | Double | Interval [-1, 1] | Feature 
| fBodyGyro_maxInds_X | Double | Interval [-1, 1] | Feature 
| fBodyGyro_maxInds_Y | Double | Interval [-1, 1] | Feature 
| fBodyGyro_maxInds_Z | Double | Interval [-1, 1] | Feature 
| fBodyGyro_meanFreq_X | Double | Interval [-1, 1] | Feature 
| fBodyGyro_meanFreq_Y | Double | Interval [-1, 1] | Feature 
| fBodyGyro_meanFreq_Z | Double | Interval [-1, 1] | Feature 
| fBodyGyro_skewness_X | Double | Interval [-1, 1] | Feature 
| fBodyGyro_kurtosis_X | Double | Interval [-1, 1] | Feature 
| fBodyGyro_skewness_Y | Double | Interval [-1, 1] | Feature 
| fBodyGyro_kurtosis_Y | Double | Interval [-1, 1] | Feature 
| fBodyGyro_skewness_Z | Double | Interval [-1, 1] | Feature 
| fBodyGyro_kurtosis_Z | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_1_8-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_9_16-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_17_24-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_25_32-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_33_40-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_41_48-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_49_56-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_57_64-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_1_16-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_17_32-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_33_48-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_49_64-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_1_24-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_25_48-DUP1 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_1_8-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_9_16-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_17_24-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_25_32-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_33_40-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_41_48-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_49_56-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_57_64-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_1_16-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_17_32-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_33_48-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_49_64-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_1_24-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_25_48-DUP2 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_1_8-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_9_16-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_17_24-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_25_32-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_33_40-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_41_48-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_49_56-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_57_64-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_1_16-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_17_32-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_33_48-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_49_64-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_1_24-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyGyro_bandsEnergy_25_48-DUP3 | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_mean | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_std | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_mad | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_max | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_min | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_sma | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_energy | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_iqr | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_entropy | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_maxInds | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_meanFreq | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_skewness | Double | Interval [-1, 1] | Feature 
| fBodyAccMag_kurtosis | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_mean | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_std | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_mad | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_max | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_min | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_sma | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_energy | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_iqr | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_entropy | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_maxInds | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_meanFreq | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_skewness | Double | Interval [-1, 1] | Feature 
| fBodyBodyAccJerkMag_kurtosis | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_mean | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_std | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_mad | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_max | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_min | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_sma | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_energy | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_iqr | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_entropy | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_maxInds | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_meanFreq | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_skewness | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroMag_kurtosis | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_mean | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_std | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_mad | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_max | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_min | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_sma | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_energy | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_iqr | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_entropy | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_maxInds | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_meanFreq | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_skewness | Double | Interval [-1, 1] | Feature 
| fBodyBodyGyroJerkMag_kurtosis | Double | Interval [-1, 1] | Feature 
| angletBodyAccMean_gravity | Double | Interval [-1, 1] | Feature 
| angletBodyAccJerkMean_gravityMean | Double | Interval [-1, 1] | Feature 
| angletBodyGyroMean_gravityMean | Double | Interval [-1, 1] | Feature 
| angletBodyGyroJerkMean_gravityMean | Double | Interval [-1, 1] | Feature 
| angleX_gravityMean | Double | Interval [-1, 1] | Feature 
| angleY_gravityMean | Double | Interval [-1, 1] | Feature 
| angleZ_gravityMean | Double |Interval [-1, 1] | Feature 

