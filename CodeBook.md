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

This tidy data set of feature is stored in the variable `data$X`. It has the
following columns:

| Column name | Type    | Possible values   | Description                      |
|-------------|---------|-------------------|----------------------------------|
| subject     | Integer | Interval [1, 30]     | Experimental subject             |
| activity    | Factor  | Set {'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'} | Experimental activity |
| set         | Factor  | Set {'Training', 'Test'} | Whether the row was originally in the training or test set |
| window      | Integer | Interval [1, 95] | Number of the time window from which the feature was extracted. |
| Other 561 columns with all the features values (see appendix) |


### Inertial data

This is the measured data for acceleration and angular velocities, 
and a calculation of body acceleration. Stored in the variable `data.inertial.tidy`.

| Column name | Type    | Possible values   | Description                      |
|-------------|---------|-------------------|----------------------------------|
| subject     | Integer | Interval [1, 30]     | Experimental subject             |
| activity    | Factor  | Set {'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'} | Experimental activity |
| sample      | Integer | Interval [1, 6144] | Ordinal inertial data sample number |
| component   | Factor  | Set {'x', 'y', 'z'} | Component of the 3D XYZ vector        |
| total_acc   | Double  | Interval [-1.7, 2.2] | Acceleration component measured by the accelerometer sensor signal in standard *g* units |
| body_acc    | Double  | Interval [-1.4, 1.3] | Calculated component of body acceleration |
| body_gyro   | Double  | Interval [-6, 5.8] | Angular velocity component measured by the gyroscope sensor in *radians/second* |


### Means and standard deviations only

This data set is a subset of the tidy features data set, that only contains the columns
for means and standard deviations. Stored in the variable `data.mean.sd`.

| Column name | Type    | Possible values   | Description                      |
|-------------|---------|-------------------|----------------------------------|
| subject     | Integer | Interval [1, 30]     | Experimental subject             |
| activity    | Factor  | Set {'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'} | Experimental activity |
| set         | Factor  | Set {'Training', 'Test'} | Whether the row was originally in the training or test set |
| window      | Integer | Interval [1, 95] | Number of the time window from which the feature was extracted. |
| Other 78 columns with the selected features values (see appendix) |


### Averages for all variables

This data set contains the averages of the features for each subject/activity combination, 
taken over all the windows present for each combination. Stored in the variable `averages.tidy` 
and in the submitted space delimited file *averages-tidy.txt*.

| Column name | Type    | Possible values   | Description                      |
|-------------|---------|-------------------|----------------------------------|
| subject     | Integer | Interval [1, 30]     | Experimental subject             |
| activity    | Factor  | Set {'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'} | Experimental activity |
| windowcount | Integer | Interval [36, 95] | Number of windows over which the average was calculated |
| Other 561 columns corresponding to the averages of all the feature values (see Appendix) |


### Appendix - Column description for the 561 features

These are the column names for the features and feature averages data sets. 
All columns contain doubles in the interval [-1, 1]. 

| Column name | In `data.mean.sd` | Description   |
|-------------|-------------------|---------------|
| tBodyAcc_mean_X | Yes | Feature *tBodyAcc-mean()-X* |
| tBodyAcc_mean_Y | Yes | Feature *tBodyAcc-mean()-Y* |
| tBodyAcc_mean_Z | Yes | Feature *tBodyAcc-mean()-Z* |
| tBodyAcc_std_X | Yes | Feature *tBodyAcc-std()-X* |
| tBodyAcc_std_Y | Yes | Feature *tBodyAcc-std()-Y* |
| tBodyAcc_std_Z | Yes | Feature *tBodyAcc-std()-Z* |
| tBodyAcc_mad_X | No | Feature *tBodyAcc-mad()-X* |
| tBodyAcc_mad_Y | No | Feature *tBodyAcc-mad()-Y* |
| tBodyAcc_mad_Z | No | Feature *tBodyAcc-mad()-Z* |
| tBodyAcc_max_X | No | Feature *tBodyAcc-max()-X* |
| tBodyAcc_max_Y | No | Feature *tBodyAcc-max()-Y* |
| tBodyAcc_max_Z | No | Feature *tBodyAcc-max()-Z* |
| tBodyAcc_min_X | No | Feature *tBodyAcc-min()-X* |
| tBodyAcc_min_Y | No | Feature *tBodyAcc-min()-Y* |
| tBodyAcc_min_Z | No | Feature *tBodyAcc-min()-Z* |
| tBodyAcc_sma | No | Feature *tBodyAcc-sma()* |
| tBodyAcc_energy_X | No | Feature *tBodyAcc-energy()-X* |
| tBodyAcc_energy_Y | No | Feature *tBodyAcc-energy()-Y* |
| tBodyAcc_energy_Z | No | Feature *tBodyAcc-energy()-Z* |
| tBodyAcc_iqr_X | No | Feature *tBodyAcc-iqr()-X* |
| tBodyAcc_iqr_Y | No | Feature *tBodyAcc-iqr()-Y* |
| tBodyAcc_iqr_Z | No | Feature *tBodyAcc-iqr()-Z* |
| tBodyAcc_entropy_X | No | Feature *tBodyAcc-entropy()-X* |
| tBodyAcc_entropy_Y | No | Feature *tBodyAcc-entropy()-Y* |
| tBodyAcc_entropy_Z | No | Feature *tBodyAcc-entropy()-Z* |
| tBodyAcc_arCoeff_X_1 | No | Feature *tBodyAcc-arCoeff()-X,1* |
| tBodyAcc_arCoeff_X_2 | No | Feature *tBodyAcc-arCoeff()-X,2* |
| tBodyAcc_arCoeff_X_3 | No | Feature *tBodyAcc-arCoeff()-X,3* |
| tBodyAcc_arCoeff_X_4 | No | Feature *tBodyAcc-arCoeff()-X,4* |
| tBodyAcc_arCoeff_Y_1 | No | Feature *tBodyAcc-arCoeff()-Y,1* |
| tBodyAcc_arCoeff_Y_2 | No | Feature *tBodyAcc-arCoeff()-Y,2* |
| tBodyAcc_arCoeff_Y_3 | No | Feature *tBodyAcc-arCoeff()-Y,3* |
| tBodyAcc_arCoeff_Y_4 | No | Feature *tBodyAcc-arCoeff()-Y,4* |
| tBodyAcc_arCoeff_Z_1 | No | Feature *tBodyAcc-arCoeff()-Z,1* |
| tBodyAcc_arCoeff_Z_2 | No | Feature *tBodyAcc-arCoeff()-Z,2* |
| tBodyAcc_arCoeff_Z_3 | No | Feature *tBodyAcc-arCoeff()-Z,3* |
| tBodyAcc_arCoeff_Z_4 | No | Feature *tBodyAcc-arCoeff()-Z,4* |
| tBodyAcc_correlation_X_Y | No | Feature *tBodyAcc-correlation()-X,Y* |
| tBodyAcc_correlation_X_Z | No | Feature *tBodyAcc-correlation()-X,Z* |
| tBodyAcc_correlation_Y_Z | No | Feature *tBodyAcc-correlation()-Y,Z* |
| tGravityAcc_mean_X | Yes | Feature *tGravityAcc-mean()-X* |
| tGravityAcc_mean_Y | Yes | Feature *tGravityAcc-mean()-Y* |
| tGravityAcc_mean_Z | Yes | Feature *tGravityAcc-mean()-Z* |
| tGravityAcc_std_X | Yes | Feature *tGravityAcc-std()-X* |
| tGravityAcc_std_Y | Yes | Feature *tGravityAcc-std()-Y* |
| tGravityAcc_std_Z | Yes | Feature *tGravityAcc-std()-Z* |
| tGravityAcc_mad_X | No | Feature *tGravityAcc-mad()-X* |
| tGravityAcc_mad_Y | No | Feature *tGravityAcc-mad()-Y* |
| tGravityAcc_mad_Z | No | Feature *tGravityAcc-mad()-Z* |
| tGravityAcc_max_X | No | Feature *tGravityAcc-max()-X* |
| tGravityAcc_max_Y | No | Feature *tGravityAcc-max()-Y* |
| tGravityAcc_max_Z | No | Feature *tGravityAcc-max()-Z* |
| tGravityAcc_min_X | No | Feature *tGravityAcc-min()-X* |
| tGravityAcc_min_Y | No | Feature *tGravityAcc-min()-Y* |
| tGravityAcc_min_Z | No | Feature *tGravityAcc-min()-Z* |
| tGravityAcc_sma | No | Feature *tGravityAcc-sma()* |
| tGravityAcc_energy_X | No | Feature *tGravityAcc-energy()-X* |
| tGravityAcc_energy_Y | No | Feature *tGravityAcc-energy()-Y* |
| tGravityAcc_energy_Z | No | Feature *tGravityAcc-energy()-Z* |
| tGravityAcc_iqr_X | No | Feature *tGravityAcc-iqr()-X* |
| tGravityAcc_iqr_Y | No | Feature *tGravityAcc-iqr()-Y* |
| tGravityAcc_iqr_Z | No | Feature *tGravityAcc-iqr()-Z* |
| tGravityAcc_entropy_X | No | Feature *tGravityAcc-entropy()-X* |
| tGravityAcc_entropy_Y | No | Feature *tGravityAcc-entropy()-Y* |
| tGravityAcc_entropy_Z | No | Feature *tGravityAcc-entropy()-Z* |
| tGravityAcc_arCoeff_X_1 | No | Feature *tGravityAcc-arCoeff()-X,1* |
| tGravityAcc_arCoeff_X_2 | No | Feature *tGravityAcc-arCoeff()-X,2* |
| tGravityAcc_arCoeff_X_3 | No | Feature *tGravityAcc-arCoeff()-X,3* |
| tGravityAcc_arCoeff_X_4 | No | Feature *tGravityAcc-arCoeff()-X,4* |
| tGravityAcc_arCoeff_Y_1 | No | Feature *tGravityAcc-arCoeff()-Y,1* |
| tGravityAcc_arCoeff_Y_2 | No | Feature *tGravityAcc-arCoeff()-Y,2* |
| tGravityAcc_arCoeff_Y_3 | No | Feature *tGravityAcc-arCoeff()-Y,3* |
| tGravityAcc_arCoeff_Y_4 | No | Feature *tGravityAcc-arCoeff()-Y,4* |
| tGravityAcc_arCoeff_Z_1 | No | Feature *tGravityAcc-arCoeff()-Z,1* |
| tGravityAcc_arCoeff_Z_2 | No | Feature *tGravityAcc-arCoeff()-Z,2* |
| tGravityAcc_arCoeff_Z_3 | No | Feature *tGravityAcc-arCoeff()-Z,3* |
| tGravityAcc_arCoeff_Z_4 | No | Feature *tGravityAcc-arCoeff()-Z,4* |
| tGravityAcc_correlation_X_Y | No | Feature *tGravityAcc-correlation()-X,Y* |
| tGravityAcc_correlation_X_Z | No | Feature *tGravityAcc-correlation()-X,Z* |
| tGravityAcc_correlation_Y_Z | No | Feature *tGravityAcc-correlation()-Y,Z* |
| tBodyAccJerk_mean_X | Yes | Feature *tBodyAccJerk-mean()-X* |
| tBodyAccJerk_mean_Y | Yes | Feature *tBodyAccJerk-mean()-Y* |
| tBodyAccJerk_mean_Z | Yes | Feature *tBodyAccJerk-mean()-Z* |
| tBodyAccJerk_std_X | Yes | Feature *tBodyAccJerk-std()-X* |
| tBodyAccJerk_std_Y | Yes | Feature *tBodyAccJerk-std()-Y* |
| tBodyAccJerk_std_Z | Yes | Feature *tBodyAccJerk-std()-Z* |
| tBodyAccJerk_mad_X | No | Feature *tBodyAccJerk-mad()-X* |
| tBodyAccJerk_mad_Y | No | Feature *tBodyAccJerk-mad()-Y* |
| tBodyAccJerk_mad_Z | No | Feature *tBodyAccJerk-mad()-Z* |
| tBodyAccJerk_max_X | No | Feature *tBodyAccJerk-max()-X* |
| tBodyAccJerk_max_Y | No | Feature *tBodyAccJerk-max()-Y* |
| tBodyAccJerk_max_Z | No | Feature *tBodyAccJerk-max()-Z* |
| tBodyAccJerk_min_X | No | Feature *tBodyAccJerk-min()-X* |
| tBodyAccJerk_min_Y | No | Feature *tBodyAccJerk-min()-Y* |
| tBodyAccJerk_min_Z | No | Feature *tBodyAccJerk-min()-Z* |
| tBodyAccJerk_sma | No | Feature *tBodyAccJerk-sma()* |
| tBodyAccJerk_energy_X | No | Feature *tBodyAccJerk-energy()-X* |
| tBodyAccJerk_energy_Y | No | Feature *tBodyAccJerk-energy()-Y* |
| tBodyAccJerk_energy_Z | No | Feature *tBodyAccJerk-energy()-Z* |
| tBodyAccJerk_iqr_X | No | Feature *tBodyAccJerk-iqr()-X* |
| tBodyAccJerk_iqr_Y | No | Feature *tBodyAccJerk-iqr()-Y* |
| tBodyAccJerk_iqr_Z | No | Feature *tBodyAccJerk-iqr()-Z* |
| tBodyAccJerk_entropy_X | No | Feature *tBodyAccJerk-entropy()-X* |
| tBodyAccJerk_entropy_Y | No | Feature *tBodyAccJerk-entropy()-Y* |
| tBodyAccJerk_entropy_Z | No | Feature *tBodyAccJerk-entropy()-Z* |
| tBodyAccJerk_arCoeff_X_1 | No | Feature *tBodyAccJerk-arCoeff()-X,1* |
| tBodyAccJerk_arCoeff_X_2 | No | Feature *tBodyAccJerk-arCoeff()-X,2* |
| tBodyAccJerk_arCoeff_X_3 | No | Feature *tBodyAccJerk-arCoeff()-X,3* |
| tBodyAccJerk_arCoeff_X_4 | No | Feature *tBodyAccJerk-arCoeff()-X,4* |
| tBodyAccJerk_arCoeff_Y_1 | No | Feature *tBodyAccJerk-arCoeff()-Y,1* |
| tBodyAccJerk_arCoeff_Y_2 | No | Feature *tBodyAccJerk-arCoeff()-Y,2* |
| tBodyAccJerk_arCoeff_Y_3 | No | Feature *tBodyAccJerk-arCoeff()-Y,3* |
| tBodyAccJerk_arCoeff_Y_4 | No | Feature *tBodyAccJerk-arCoeff()-Y,4* |
| tBodyAccJerk_arCoeff_Z_1 | No | Feature *tBodyAccJerk-arCoeff()-Z,1* |
| tBodyAccJerk_arCoeff_Z_2 | No | Feature *tBodyAccJerk-arCoeff()-Z,2* |
| tBodyAccJerk_arCoeff_Z_3 | No | Feature *tBodyAccJerk-arCoeff()-Z,3* |
| tBodyAccJerk_arCoeff_Z_4 | No | Feature *tBodyAccJerk-arCoeff()-Z,4* |
| tBodyAccJerk_correlation_X_Y | No | Feature *tBodyAccJerk-correlation()-X,Y* |
| tBodyAccJerk_correlation_X_Z | No | Feature *tBodyAccJerk-correlation()-X,Z* |
| tBodyAccJerk_correlation_Y_Z | No | Feature *tBodyAccJerk-correlation()-Y,Z* |
| tBodyGyro_mean_X | Yes | Feature *tBodyGyro-mean()-X* |
| tBodyGyro_mean_Y | Yes | Feature *tBodyGyro-mean()-Y* |
| tBodyGyro_mean_Z | Yes | Feature *tBodyGyro-mean()-Z* |
| tBodyGyro_std_X | Yes | Feature *tBodyGyro-std()-X* |
| tBodyGyro_std_Y | Yes | Feature *tBodyGyro-std()-Y* |
| tBodyGyro_std_Z | Yes | Feature *tBodyGyro-std()-Z* |
| tBodyGyro_mad_X | No | Feature *tBodyGyro-mad()-X* |
| tBodyGyro_mad_Y | No | Feature *tBodyGyro-mad()-Y* |
| tBodyGyro_mad_Z | No | Feature *tBodyGyro-mad()-Z* |
| tBodyGyro_max_X | No | Feature *tBodyGyro-max()-X* |
| tBodyGyro_max_Y | No | Feature *tBodyGyro-max()-Y* |
| tBodyGyro_max_Z | No | Feature *tBodyGyro-max()-Z* |
| tBodyGyro_min_X | No | Feature *tBodyGyro-min()-X* |
| tBodyGyro_min_Y | No | Feature *tBodyGyro-min()-Y* |
| tBodyGyro_min_Z | No | Feature *tBodyGyro-min()-Z* |
| tBodyGyro_sma | No | Feature *tBodyGyro-sma()* |
| tBodyGyro_energy_X | No | Feature *tBodyGyro-energy()-X* |
| tBodyGyro_energy_Y | No | Feature *tBodyGyro-energy()-Y* |
| tBodyGyro_energy_Z | No | Feature *tBodyGyro-energy()-Z* |
| tBodyGyro_iqr_X | No | Feature *tBodyGyro-iqr()-X* |
| tBodyGyro_iqr_Y | No | Feature *tBodyGyro-iqr()-Y* |
| tBodyGyro_iqr_Z | No | Feature *tBodyGyro-iqr()-Z* |
| tBodyGyro_entropy_X | No | Feature *tBodyGyro-entropy()-X* |
| tBodyGyro_entropy_Y | No | Feature *tBodyGyro-entropy()-Y* |
| tBodyGyro_entropy_Z | No | Feature *tBodyGyro-entropy()-Z* |
| tBodyGyro_arCoeff_X_1 | No | Feature *tBodyGyro-arCoeff()-X,1* |
| tBodyGyro_arCoeff_X_2 | No | Feature *tBodyGyro-arCoeff()-X,2* |
| tBodyGyro_arCoeff_X_3 | No | Feature *tBodyGyro-arCoeff()-X,3* |
| tBodyGyro_arCoeff_X_4 | No | Feature *tBodyGyro-arCoeff()-X,4* |
| tBodyGyro_arCoeff_Y_1 | No | Feature *tBodyGyro-arCoeff()-Y,1* |
| tBodyGyro_arCoeff_Y_2 | No | Feature *tBodyGyro-arCoeff()-Y,2* |
| tBodyGyro_arCoeff_Y_3 | No | Feature *tBodyGyro-arCoeff()-Y,3* |
| tBodyGyro_arCoeff_Y_4 | No | Feature *tBodyGyro-arCoeff()-Y,4* |
| tBodyGyro_arCoeff_Z_1 | No | Feature *tBodyGyro-arCoeff()-Z,1* |
| tBodyGyro_arCoeff_Z_2 | No | Feature *tBodyGyro-arCoeff()-Z,2* |
| tBodyGyro_arCoeff_Z_3 | No | Feature *tBodyGyro-arCoeff()-Z,3* |
| tBodyGyro_arCoeff_Z_4 | No | Feature *tBodyGyro-arCoeff()-Z,4* |
| tBodyGyro_correlation_X_Y | No | Feature *tBodyGyro-correlation()-X,Y* |
| tBodyGyro_correlation_X_Z | No | Feature *tBodyGyro-correlation()-X,Z* |
| tBodyGyro_correlation_Y_Z | No | Feature *tBodyGyro-correlation()-Y,Z* |
| tBodyGyroJerk_mean_X | Yes | Feature *tBodyGyroJerk-mean()-X* |
| tBodyGyroJerk_mean_Y | Yes | Feature *tBodyGyroJerk-mean()-Y* |
| tBodyGyroJerk_mean_Z | Yes | Feature *tBodyGyroJerk-mean()-Z* |
| tBodyGyroJerk_std_X | Yes | Feature *tBodyGyroJerk-std()-X* |
| tBodyGyroJerk_std_Y | Yes | Feature *tBodyGyroJerk-std()-Y* |
| tBodyGyroJerk_std_Z | Yes | Feature *tBodyGyroJerk-std()-Z* |
| tBodyGyroJerk_mad_X | No | Feature *tBodyGyroJerk-mad()-X* |
| tBodyGyroJerk_mad_Y | No | Feature *tBodyGyroJerk-mad()-Y* |
| tBodyGyroJerk_mad_Z | No | Feature *tBodyGyroJerk-mad()-Z* |
| tBodyGyroJerk_max_X | No | Feature *tBodyGyroJerk-max()-X* |
| tBodyGyroJerk_max_Y | No | Feature *tBodyGyroJerk-max()-Y* |
| tBodyGyroJerk_max_Z | No | Feature *tBodyGyroJerk-max()-Z* |
| tBodyGyroJerk_min_X | No | Feature *tBodyGyroJerk-min()-X* |
| tBodyGyroJerk_min_Y | No | Feature *tBodyGyroJerk-min()-Y* |
| tBodyGyroJerk_min_Z | No | Feature *tBodyGyroJerk-min()-Z* |
| tBodyGyroJerk_sma | No | Feature *tBodyGyroJerk-sma()* |
| tBodyGyroJerk_energy_X | No | Feature *tBodyGyroJerk-energy()-X* |
| tBodyGyroJerk_energy_Y | No | Feature *tBodyGyroJerk-energy()-Y* |
| tBodyGyroJerk_energy_Z | No | Feature *tBodyGyroJerk-energy()-Z* |
| tBodyGyroJerk_iqr_X | No | Feature *tBodyGyroJerk-iqr()-X* |
| tBodyGyroJerk_iqr_Y | No | Feature *tBodyGyroJerk-iqr()-Y* |
| tBodyGyroJerk_iqr_Z | No | Feature *tBodyGyroJerk-iqr()-Z* |
| tBodyGyroJerk_entropy_X | No | Feature *tBodyGyroJerk-entropy()-X* |
| tBodyGyroJerk_entropy_Y | No | Feature *tBodyGyroJerk-entropy()-Y* |
| tBodyGyroJerk_entropy_Z | No | Feature *tBodyGyroJerk-entropy()-Z* |
| tBodyGyroJerk_arCoeff_X_1 | No | Feature *tBodyGyroJerk-arCoeff()-X,1* |
| tBodyGyroJerk_arCoeff_X_2 | No | Feature *tBodyGyroJerk-arCoeff()-X,2* |
| tBodyGyroJerk_arCoeff_X_3 | No | Feature *tBodyGyroJerk-arCoeff()-X,3* |
| tBodyGyroJerk_arCoeff_X_4 | No | Feature *tBodyGyroJerk-arCoeff()-X,4* |
| tBodyGyroJerk_arCoeff_Y_1 | No | Feature *tBodyGyroJerk-arCoeff()-Y,1* |
| tBodyGyroJerk_arCoeff_Y_2 | No | Feature *tBodyGyroJerk-arCoeff()-Y,2* |
| tBodyGyroJerk_arCoeff_Y_3 | No | Feature *tBodyGyroJerk-arCoeff()-Y,3* |
| tBodyGyroJerk_arCoeff_Y_4 | No | Feature *tBodyGyroJerk-arCoeff()-Y,4* |
| tBodyGyroJerk_arCoeff_Z_1 | No | Feature *tBodyGyroJerk-arCoeff()-Z,1* |
| tBodyGyroJerk_arCoeff_Z_2 | No | Feature *tBodyGyroJerk-arCoeff()-Z,2* |
| tBodyGyroJerk_arCoeff_Z_3 | No | Feature *tBodyGyroJerk-arCoeff()-Z,3* |
| tBodyGyroJerk_arCoeff_Z_4 | No | Feature *tBodyGyroJerk-arCoeff()-Z,4* |
| tBodyGyroJerk_correlation_X_Y | No | Feature *tBodyGyroJerk-correlation()-X,Y* |
| tBodyGyroJerk_correlation_X_Z | No | Feature *tBodyGyroJerk-correlation()-X,Z* |
| tBodyGyroJerk_correlation_Y_Z | No | Feature *tBodyGyroJerk-correlation()-Y,Z* |
| tBodyAccMag_mean | Yes | Feature *tBodyAccMag-mean()* |
| tBodyAccMag_std | Yes | Feature *tBodyAccMag-std()* |
| tBodyAccMag_mad | No | Feature *tBodyAccMag-mad()* |
| tBodyAccMag_max | No | Feature *tBodyAccMag-max()* |
| tBodyAccMag_min | No | Feature *tBodyAccMag-min()* |
| tBodyAccMag_sma | No | Feature *tBodyAccMag-sma()* |
| tBodyAccMag_energy | No | Feature *tBodyAccMag-energy()* |
| tBodyAccMag_iqr | No | Feature *tBodyAccMag-iqr()* |
| tBodyAccMag_entropy | No | Feature *tBodyAccMag-entropy()* |
| tBodyAccMag_arCoeff1 | No | Feature *tBodyAccMag-arCoeff()1* |
| tBodyAccMag_arCoeff2 | No | Feature *tBodyAccMag-arCoeff()2* |
| tBodyAccMag_arCoeff3 | No | Feature *tBodyAccMag-arCoeff()3* |
| tBodyAccMag_arCoeff4 | No | Feature *tBodyAccMag-arCoeff()4* |
| tGravityAccMag_mean | Yes | Feature *tGravityAccMag-mean()* |
| tGravityAccMag_std | Yes | Feature *tGravityAccMag-std()* |
| tGravityAccMag_mad | No | Feature *tGravityAccMag-mad()* |
| tGravityAccMag_max | No | Feature *tGravityAccMag-max()* |
| tGravityAccMag_min | No | Feature *tGravityAccMag-min()* |
| tGravityAccMag_sma | No | Feature *tGravityAccMag-sma()* |
| tGravityAccMag_energy | No | Feature *tGravityAccMag-energy()* |
| tGravityAccMag_iqr | No | Feature *tGravityAccMag-iqr()* |
| tGravityAccMag_entropy | No | Feature *tGravityAccMag-entropy()* |
| tGravityAccMag_arCoeff1 | No | Feature *tGravityAccMag-arCoeff()1* |
| tGravityAccMag_arCoeff2 | No | Feature *tGravityAccMag-arCoeff()2* |
| tGravityAccMag_arCoeff3 | No | Feature *tGravityAccMag-arCoeff()3* |
| tGravityAccMag_arCoeff4 | No | Feature *tGravityAccMag-arCoeff()4* |
| tBodyAccJerkMag_mean | Yes | Feature *tBodyAccJerkMag-mean()* |
| tBodyAccJerkMag_std | Yes | Feature *tBodyAccJerkMag-std()* |
| tBodyAccJerkMag_mad | No | Feature *tBodyAccJerkMag-mad()* |
| tBodyAccJerkMag_max | No | Feature *tBodyAccJerkMag-max()* |
| tBodyAccJerkMag_min | No | Feature *tBodyAccJerkMag-min()* |
| tBodyAccJerkMag_sma | No | Feature *tBodyAccJerkMag-sma()* |
| tBodyAccJerkMag_energy | No | Feature *tBodyAccJerkMag-energy()* |
| tBodyAccJerkMag_iqr | No | Feature *tBodyAccJerkMag-iqr()* |
| tBodyAccJerkMag_entropy | No | Feature *tBodyAccJerkMag-entropy()* |
| tBodyAccJerkMag_arCoeff1 | No | Feature *tBodyAccJerkMag-arCoeff()1* |
| tBodyAccJerkMag_arCoeff2 | No | Feature *tBodyAccJerkMag-arCoeff()2* |
| tBodyAccJerkMag_arCoeff3 | No | Feature *tBodyAccJerkMag-arCoeff()3* |
| tBodyAccJerkMag_arCoeff4 | No | Feature *tBodyAccJerkMag-arCoeff()4* |
| tBodyGyroMag_mean | Yes | Feature *tBodyGyroMag-mean()* |
| tBodyGyroMag_std | Yes | Feature *tBodyGyroMag-std()* |
| tBodyGyroMag_mad | No | Feature *tBodyGyroMag-mad()* |
| tBodyGyroMag_max | No | Feature *tBodyGyroMag-max()* |
| tBodyGyroMag_min | No | Feature *tBodyGyroMag-min()* |
| tBodyGyroMag_sma | No | Feature *tBodyGyroMag-sma()* |
| tBodyGyroMag_energy | No | Feature *tBodyGyroMag-energy()* |
| tBodyGyroMag_iqr | No | Feature *tBodyGyroMag-iqr()* |
| tBodyGyroMag_entropy | No | Feature *tBodyGyroMag-entropy()* |
| tBodyGyroMag_arCoeff1 | No | Feature *tBodyGyroMag-arCoeff()1* |
| tBodyGyroMag_arCoeff2 | No | Feature *tBodyGyroMag-arCoeff()2* |
| tBodyGyroMag_arCoeff3 | No | Feature *tBodyGyroMag-arCoeff()3* |
| tBodyGyroMag_arCoeff4 | No | Feature *tBodyGyroMag-arCoeff()4* |
| tBodyGyroJerkMag_mean | Yes | Feature *tBodyGyroJerkMag-mean()* |
| tBodyGyroJerkMag_std | Yes | Feature *tBodyGyroJerkMag-std()* |
| tBodyGyroJerkMag_mad | No | Feature *tBodyGyroJerkMag-mad()* |
| tBodyGyroJerkMag_max | No | Feature *tBodyGyroJerkMag-max()* |
| tBodyGyroJerkMag_min | No | Feature *tBodyGyroJerkMag-min()* |
| tBodyGyroJerkMag_sma | No | Feature *tBodyGyroJerkMag-sma()* |
| tBodyGyroJerkMag_energy | No | Feature *tBodyGyroJerkMag-energy()* |
| tBodyGyroJerkMag_iqr | No | Feature *tBodyGyroJerkMag-iqr()* |
| tBodyGyroJerkMag_entropy | No | Feature *tBodyGyroJerkMag-entropy()* |
| tBodyGyroJerkMag_arCoeff1 | No | Feature *tBodyGyroJerkMag-arCoeff()1* |
| tBodyGyroJerkMag_arCoeff2 | No | Feature *tBodyGyroJerkMag-arCoeff()2* |
| tBodyGyroJerkMag_arCoeff3 | No | Feature *tBodyGyroJerkMag-arCoeff()3* |
| tBodyGyroJerkMag_arCoeff4 | No | Feature *tBodyGyroJerkMag-arCoeff()4* |
| fBodyAcc_mean_X | Yes | Feature *fBodyAcc-mean()-X* |
| fBodyAcc_mean_Y | Yes | Feature *fBodyAcc-mean()-Y* |
| fBodyAcc_mean_Z | Yes | Feature *fBodyAcc-mean()-Z* |
| fBodyAcc_std_X | Yes | Feature *fBodyAcc-std()-X* |
| fBodyAcc_std_Y | Yes | Feature *fBodyAcc-std()-Y* |
| fBodyAcc_std_Z | Yes | Feature *fBodyAcc-std()-Z* |
| fBodyAcc_mad_X | No | Feature *fBodyAcc-mad()-X* |
| fBodyAcc_mad_Y | No | Feature *fBodyAcc-mad()-Y* |
| fBodyAcc_mad_Z | No | Feature *fBodyAcc-mad()-Z* |
| fBodyAcc_max_X | No | Feature *fBodyAcc-max()-X* |
| fBodyAcc_max_Y | No | Feature *fBodyAcc-max()-Y* |
| fBodyAcc_max_Z | No | Feature *fBodyAcc-max()-Z* |
| fBodyAcc_min_X | No | Feature *fBodyAcc-min()-X* |
| fBodyAcc_min_Y | No | Feature *fBodyAcc-min()-Y* |
| fBodyAcc_min_Z | No | Feature *fBodyAcc-min()-Z* |
| fBodyAcc_sma | No | Feature *fBodyAcc-sma()* |
| fBodyAcc_energy_X | No | Feature *fBodyAcc-energy()-X* |
| fBodyAcc_energy_Y | No | Feature *fBodyAcc-energy()-Y* |
| fBodyAcc_energy_Z | No | Feature *fBodyAcc-energy()-Z* |
| fBodyAcc_iqr_X | No | Feature *fBodyAcc-iqr()-X* |
| fBodyAcc_iqr_Y | No | Feature *fBodyAcc-iqr()-Y* |
| fBodyAcc_iqr_Z | No | Feature *fBodyAcc-iqr()-Z* |
| fBodyAcc_entropy_X | No | Feature *fBodyAcc-entropy()-X* |
| fBodyAcc_entropy_Y | No | Feature *fBodyAcc-entropy()-Y* |
| fBodyAcc_entropy_Z | No | Feature *fBodyAcc-entropy()-Z* |
| fBodyAcc_maxInds_X | No | Feature *fBodyAcc-maxInds-X* |
| fBodyAcc_maxInds_Y | No | Feature *fBodyAcc-maxInds-Y* |
| fBodyAcc_maxInds_Z | No | Feature *fBodyAcc-maxInds-Z* |
| fBodyAcc_meanFreq_X | Yes | Feature *fBodyAcc-meanFreq()-X* |
| fBodyAcc_meanFreq_Y | Yes | Feature *fBodyAcc-meanFreq()-Y* |
| fBodyAcc_meanFreq_Z | Yes | Feature *fBodyAcc-meanFreq()-Z* |
| fBodyAcc_skewness_X | No | Feature *fBodyAcc-skewness()-X* |
| fBodyAcc_kurtosis_X | No | Feature *fBodyAcc-kurtosis()-X* |
| fBodyAcc_skewness_Y | No | Feature *fBodyAcc-skewness()-Y* |
| fBodyAcc_kurtosis_Y | No | Feature *fBodyAcc-kurtosis()-Y* |
| fBodyAcc_skewness_Z | No | Feature *fBodyAcc-skewness()-Z* |
| fBodyAcc_kurtosis_Z | No | Feature *fBodyAcc-kurtosis()-Z* |
| fBodyAcc_bandsEnergy_1_8-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-1,8* |
| fBodyAcc_bandsEnergy_9_16-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-9,16* |
| fBodyAcc_bandsEnergy_17_24-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-17,24* |
| fBodyAcc_bandsEnergy_25_32-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-25,32* |
| fBodyAcc_bandsEnergy_33_40-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-33,40* |
| fBodyAcc_bandsEnergy_41_48-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-41,48* |
| fBodyAcc_bandsEnergy_49_56-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-49,56* |
| fBodyAcc_bandsEnergy_57_64-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-57,64* |
| fBodyAcc_bandsEnergy_1_16-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-1,16* |
| fBodyAcc_bandsEnergy_17_32-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-17,32* |
| fBodyAcc_bandsEnergy_33_48-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-33,48* |
| fBodyAcc_bandsEnergy_49_64-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-49,64* |
| fBodyAcc_bandsEnergy_1_24-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-1,24* |
| fBodyAcc_bandsEnergy_25_48-DUP1 | No | Feature *fBodyAcc-bandsEnergy()-25,48* |
| fBodyAcc_bandsEnergy_1_8-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-1,8* |
| fBodyAcc_bandsEnergy_9_16-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-9,16* |
| fBodyAcc_bandsEnergy_17_24-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-17,24* |
| fBodyAcc_bandsEnergy_25_32-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-25,32* |
| fBodyAcc_bandsEnergy_33_40-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-33,40* |
| fBodyAcc_bandsEnergy_41_48-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-41,48* |
| fBodyAcc_bandsEnergy_49_56-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-49,56* |
| fBodyAcc_bandsEnergy_57_64-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-57,64* |
| fBodyAcc_bandsEnergy_1_16-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-1,16* |
| fBodyAcc_bandsEnergy_17_32-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-17,32* |
| fBodyAcc_bandsEnergy_33_48-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-33,48* |
| fBodyAcc_bandsEnergy_49_64-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-49,64* |
| fBodyAcc_bandsEnergy_1_24-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-1,24* |
| fBodyAcc_bandsEnergy_25_48-DUP2 | No | Feature *fBodyAcc-bandsEnergy()-25,48* |
| fBodyAcc_bandsEnergy_1_8-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-1,8* |
| fBodyAcc_bandsEnergy_9_16-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-9,16* |
| fBodyAcc_bandsEnergy_17_24-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-17,24* |
| fBodyAcc_bandsEnergy_25_32-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-25,32* |
| fBodyAcc_bandsEnergy_33_40-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-33,40* |
| fBodyAcc_bandsEnergy_41_48-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-41,48* |
| fBodyAcc_bandsEnergy_49_56-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-49,56* |
| fBodyAcc_bandsEnergy_57_64-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-57,64* |
| fBodyAcc_bandsEnergy_1_16-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-1,16* |
| fBodyAcc_bandsEnergy_17_32-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-17,32* |
| fBodyAcc_bandsEnergy_33_48-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-33,48* |
| fBodyAcc_bandsEnergy_49_64-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-49,64* |
| fBodyAcc_bandsEnergy_1_24-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-1,24* |
| fBodyAcc_bandsEnergy_25_48-DUP3 | No | Feature *fBodyAcc-bandsEnergy()-25,48* |
| fBodyAccJerk_mean_X | Yes | Feature *fBodyAccJerk-mean()-X* |
| fBodyAccJerk_mean_Y | Yes | Feature *fBodyAccJerk-mean()-Y* |
| fBodyAccJerk_mean_Z | Yes | Feature *fBodyAccJerk-mean()-Z* |
| fBodyAccJerk_std_X | Yes | Feature *fBodyAccJerk-std()-X* |
| fBodyAccJerk_std_Y | Yes | Feature *fBodyAccJerk-std()-Y* |
| fBodyAccJerk_std_Z | Yes | Feature *fBodyAccJerk-std()-Z* |
| fBodyAccJerk_mad_X | No | Feature *fBodyAccJerk-mad()-X* |
| fBodyAccJerk_mad_Y | No | Feature *fBodyAccJerk-mad()-Y* |
| fBodyAccJerk_mad_Z | No | Feature *fBodyAccJerk-mad()-Z* |
| fBodyAccJerk_max_X | No | Feature *fBodyAccJerk-max()-X* |
| fBodyAccJerk_max_Y | No | Feature *fBodyAccJerk-max()-Y* |
| fBodyAccJerk_max_Z | No | Feature *fBodyAccJerk-max()-Z* |
| fBodyAccJerk_min_X | No | Feature *fBodyAccJerk-min()-X* |
| fBodyAccJerk_min_Y | No | Feature *fBodyAccJerk-min()-Y* |
| fBodyAccJerk_min_Z | No | Feature *fBodyAccJerk-min()-Z* |
| fBodyAccJerk_sma | No | Feature *fBodyAccJerk-sma()* |
| fBodyAccJerk_energy_X | No | Feature *fBodyAccJerk-energy()-X* |
| fBodyAccJerk_energy_Y | No | Feature *fBodyAccJerk-energy()-Y* |
| fBodyAccJerk_energy_Z | No | Feature *fBodyAccJerk-energy()-Z* |
| fBodyAccJerk_iqr_X | No | Feature *fBodyAccJerk-iqr()-X* |
| fBodyAccJerk_iqr_Y | No | Feature *fBodyAccJerk-iqr()-Y* |
| fBodyAccJerk_iqr_Z | No | Feature *fBodyAccJerk-iqr()-Z* |
| fBodyAccJerk_entropy_X | No | Feature *fBodyAccJerk-entropy()-X* |
| fBodyAccJerk_entropy_Y | No | Feature *fBodyAccJerk-entropy()-Y* |
| fBodyAccJerk_entropy_Z | No | Feature *fBodyAccJerk-entropy()-Z* |
| fBodyAccJerk_maxInds_X | No | Feature *fBodyAccJerk-maxInds-X* |
| fBodyAccJerk_maxInds_Y | No | Feature *fBodyAccJerk-maxInds-Y* |
| fBodyAccJerk_maxInds_Z | No | Feature *fBodyAccJerk-maxInds-Z* |
| fBodyAccJerk_meanFreq_X | Yes | Feature *fBodyAccJerk-meanFreq()-X* |
| fBodyAccJerk_meanFreq_Y | Yes | Feature *fBodyAccJerk-meanFreq()-Y* |
| fBodyAccJerk_meanFreq_Z | Yes | Feature *fBodyAccJerk-meanFreq()-Z* |
| fBodyAccJerk_skewness_X | No | Feature *fBodyAccJerk-skewness()-X* |
| fBodyAccJerk_kurtosis_X | No | Feature *fBodyAccJerk-kurtosis()-X* |
| fBodyAccJerk_skewness_Y | No | Feature *fBodyAccJerk-skewness()-Y* |
| fBodyAccJerk_kurtosis_Y | No | Feature *fBodyAccJerk-kurtosis()-Y* |
| fBodyAccJerk_skewness_Z | No | Feature *fBodyAccJerk-skewness()-Z* |
| fBodyAccJerk_kurtosis_Z | No | Feature *fBodyAccJerk-kurtosis()-Z* |
| fBodyAccJerk_bandsEnergy_1_8-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-1,8* |
| fBodyAccJerk_bandsEnergy_9_16-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-9,16* |
| fBodyAccJerk_bandsEnergy_17_24-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-17,24* |
| fBodyAccJerk_bandsEnergy_25_32-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-25,32* |
| fBodyAccJerk_bandsEnergy_33_40-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-33,40* |
| fBodyAccJerk_bandsEnergy_41_48-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-41,48* |
| fBodyAccJerk_bandsEnergy_49_56-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-49,56* |
| fBodyAccJerk_bandsEnergy_57_64-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-57,64* |
| fBodyAccJerk_bandsEnergy_1_16-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-1,16* |
| fBodyAccJerk_bandsEnergy_17_32-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-17,32* |
| fBodyAccJerk_bandsEnergy_33_48-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-33,48* |
| fBodyAccJerk_bandsEnergy_49_64-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-49,64* |
| fBodyAccJerk_bandsEnergy_1_24-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-1,24* |
| fBodyAccJerk_bandsEnergy_25_48-DUP1 | No | Feature *fBodyAccJerk-bandsEnergy()-25,48* |
| fBodyAccJerk_bandsEnergy_1_8-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-1,8* |
| fBodyAccJerk_bandsEnergy_9_16-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-9,16* |
| fBodyAccJerk_bandsEnergy_17_24-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-17,24* |
| fBodyAccJerk_bandsEnergy_25_32-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-25,32* |
| fBodyAccJerk_bandsEnergy_33_40-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-33,40* |
| fBodyAccJerk_bandsEnergy_41_48-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-41,48* |
| fBodyAccJerk_bandsEnergy_49_56-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-49,56* |
| fBodyAccJerk_bandsEnergy_57_64-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-57,64* |
| fBodyAccJerk_bandsEnergy_1_16-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-1,16* |
| fBodyAccJerk_bandsEnergy_17_32-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-17,32* |
| fBodyAccJerk_bandsEnergy_33_48-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-33,48* |
| fBodyAccJerk_bandsEnergy_49_64-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-49,64* |
| fBodyAccJerk_bandsEnergy_1_24-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-1,24* |
| fBodyAccJerk_bandsEnergy_25_48-DUP2 | No | Feature *fBodyAccJerk-bandsEnergy()-25,48* |
| fBodyAccJerk_bandsEnergy_1_8-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-1,8* |
| fBodyAccJerk_bandsEnergy_9_16-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-9,16* |
| fBodyAccJerk_bandsEnergy_17_24-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-17,24* |
| fBodyAccJerk_bandsEnergy_25_32-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-25,32* |
| fBodyAccJerk_bandsEnergy_33_40-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-33,40* |
| fBodyAccJerk_bandsEnergy_41_48-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-41,48* |
| fBodyAccJerk_bandsEnergy_49_56-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-49,56* |
| fBodyAccJerk_bandsEnergy_57_64-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-57,64* |
| fBodyAccJerk_bandsEnergy_1_16-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-1,16* |
| fBodyAccJerk_bandsEnergy_17_32-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-17,32* |
| fBodyAccJerk_bandsEnergy_33_48-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-33,48* |
| fBodyAccJerk_bandsEnergy_49_64-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-49,64* |
| fBodyAccJerk_bandsEnergy_1_24-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-1,24* |
| fBodyAccJerk_bandsEnergy_25_48-DUP3 | No | Feature *fBodyAccJerk-bandsEnergy()-25,48* |
| fBodyGyro_mean_X | Yes | Feature *fBodyGyro-mean()-X* |
| fBodyGyro_mean_Y | Yes | Feature *fBodyGyro-mean()-Y* |
| fBodyGyro_mean_Z | Yes | Feature *fBodyGyro-mean()-Z* |
| fBodyGyro_std_X | Yes | Feature *fBodyGyro-std()-X* |
| fBodyGyro_std_Y | Yes | Feature *fBodyGyro-std()-Y* |
| fBodyGyro_std_Z | Yes | Feature *fBodyGyro-std()-Z* |
| fBodyGyro_mad_X | No | Feature *fBodyGyro-mad()-X* |
| fBodyGyro_mad_Y | No | Feature *fBodyGyro-mad()-Y* |
| fBodyGyro_mad_Z | No | Feature *fBodyGyro-mad()-Z* |
| fBodyGyro_max_X | No | Feature *fBodyGyro-max()-X* |
| fBodyGyro_max_Y | No | Feature *fBodyGyro-max()-Y* |
| fBodyGyro_max_Z | No | Feature *fBodyGyro-max()-Z* |
| fBodyGyro_min_X | No | Feature *fBodyGyro-min()-X* |
| fBodyGyro_min_Y | No | Feature *fBodyGyro-min()-Y* |
| fBodyGyro_min_Z | No | Feature *fBodyGyro-min()-Z* |
| fBodyGyro_sma | No | Feature *fBodyGyro-sma()* |
| fBodyGyro_energy_X | No | Feature *fBodyGyro-energy()-X* |
| fBodyGyro_energy_Y | No | Feature *fBodyGyro-energy()-Y* |
| fBodyGyro_energy_Z | No | Feature *fBodyGyro-energy()-Z* |
| fBodyGyro_iqr_X | No | Feature *fBodyGyro-iqr()-X* |
| fBodyGyro_iqr_Y | No | Feature *fBodyGyro-iqr()-Y* |
| fBodyGyro_iqr_Z | No | Feature *fBodyGyro-iqr()-Z* |
| fBodyGyro_entropy_X | No | Feature *fBodyGyro-entropy()-X* |
| fBodyGyro_entropy_Y | No | Feature *fBodyGyro-entropy()-Y* |
| fBodyGyro_entropy_Z | No | Feature *fBodyGyro-entropy()-Z* |
| fBodyGyro_maxInds_X | No | Feature *fBodyGyro-maxInds-X* |
| fBodyGyro_maxInds_Y | No | Feature *fBodyGyro-maxInds-Y* |
| fBodyGyro_maxInds_Z | No | Feature *fBodyGyro-maxInds-Z* |
| fBodyGyro_meanFreq_X | Yes | Feature *fBodyGyro-meanFreq()-X* |
| fBodyGyro_meanFreq_Y | Yes | Feature *fBodyGyro-meanFreq()-Y* |
| fBodyGyro_meanFreq_Z | Yes | Feature *fBodyGyro-meanFreq()-Z* |
| fBodyGyro_skewness_X | No | Feature *fBodyGyro-skewness()-X* |
| fBodyGyro_kurtosis_X | No | Feature *fBodyGyro-kurtosis()-X* |
| fBodyGyro_skewness_Y | No | Feature *fBodyGyro-skewness()-Y* |
| fBodyGyro_kurtosis_Y | No | Feature *fBodyGyro-kurtosis()-Y* |
| fBodyGyro_skewness_Z | No | Feature *fBodyGyro-skewness()-Z* |
| fBodyGyro_kurtosis_Z | No | Feature *fBodyGyro-kurtosis()-Z* |
| fBodyGyro_bandsEnergy_1_8-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-1,8* |
| fBodyGyro_bandsEnergy_9_16-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-9,16* |
| fBodyGyro_bandsEnergy_17_24-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-17,24* |
| fBodyGyro_bandsEnergy_25_32-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-25,32* |
| fBodyGyro_bandsEnergy_33_40-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-33,40* |
| fBodyGyro_bandsEnergy_41_48-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-41,48* |
| fBodyGyro_bandsEnergy_49_56-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-49,56* |
| fBodyGyro_bandsEnergy_57_64-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-57,64* |
| fBodyGyro_bandsEnergy_1_16-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-1,16* |
| fBodyGyro_bandsEnergy_17_32-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-17,32* |
| fBodyGyro_bandsEnergy_33_48-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-33,48* |
| fBodyGyro_bandsEnergy_49_64-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-49,64* |
| fBodyGyro_bandsEnergy_1_24-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-1,24* |
| fBodyGyro_bandsEnergy_25_48-DUP1 | No | Feature *fBodyGyro-bandsEnergy()-25,48* |
| fBodyGyro_bandsEnergy_1_8-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-1,8* |
| fBodyGyro_bandsEnergy_9_16-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-9,16* |
| fBodyGyro_bandsEnergy_17_24-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-17,24* |
| fBodyGyro_bandsEnergy_25_32-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-25,32* |
| fBodyGyro_bandsEnergy_33_40-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-33,40* |
| fBodyGyro_bandsEnergy_41_48-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-41,48* |
| fBodyGyro_bandsEnergy_49_56-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-49,56* |
| fBodyGyro_bandsEnergy_57_64-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-57,64* |
| fBodyGyro_bandsEnergy_1_16-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-1,16* |
| fBodyGyro_bandsEnergy_17_32-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-17,32* |
| fBodyGyro_bandsEnergy_33_48-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-33,48* |
| fBodyGyro_bandsEnergy_49_64-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-49,64* |
| fBodyGyro_bandsEnergy_1_24-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-1,24* |
| fBodyGyro_bandsEnergy_25_48-DUP2 | No | Feature *fBodyGyro-bandsEnergy()-25,48* |
| fBodyGyro_bandsEnergy_1_8-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-1,8* |
| fBodyGyro_bandsEnergy_9_16-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-9,16* |
| fBodyGyro_bandsEnergy_17_24-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-17,24* |
| fBodyGyro_bandsEnergy_25_32-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-25,32* |
| fBodyGyro_bandsEnergy_33_40-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-33,40* |
| fBodyGyro_bandsEnergy_41_48-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-41,48* |
| fBodyGyro_bandsEnergy_49_56-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-49,56* |
| fBodyGyro_bandsEnergy_57_64-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-57,64* |
| fBodyGyro_bandsEnergy_1_16-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-1,16* |
| fBodyGyro_bandsEnergy_17_32-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-17,32* |
| fBodyGyro_bandsEnergy_33_48-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-33,48* |
| fBodyGyro_bandsEnergy_49_64-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-49,64* |
| fBodyGyro_bandsEnergy_1_24-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-1,24* |
| fBodyGyro_bandsEnergy_25_48-DUP3 | No | Feature *fBodyGyro-bandsEnergy()-25,48* |
| fBodyAccMag_mean | Yes | Feature *fBodyAccMag-mean()* |
| fBodyAccMag_std | Yes | Feature *fBodyAccMag-std()* |
| fBodyAccMag_mad | No | Feature *fBodyAccMag-mad()* |
| fBodyAccMag_max | No | Feature *fBodyAccMag-max()* |
| fBodyAccMag_min | No | Feature *fBodyAccMag-min()* |
| fBodyAccMag_sma | No | Feature *fBodyAccMag-sma()* |
| fBodyAccMag_energy | No | Feature *fBodyAccMag-energy()* |
| fBodyAccMag_iqr | No | Feature *fBodyAccMag-iqr()* |
| fBodyAccMag_entropy | No | Feature *fBodyAccMag-entropy()* |
| fBodyAccMag_maxInds | No | Feature *fBodyAccMag-maxInds* |
| fBodyAccMag_meanFreq | Yes | Feature *fBodyAccMag-meanFreq()* |
| fBodyAccMag_skewness | No | Feature *fBodyAccMag-skewness()* |
| fBodyAccMag_kurtosis | No | Feature *fBodyAccMag-kurtosis()* |
| fBodyBodyAccJerkMag_mean | Yes | Feature *fBodyBodyAccJerkMag-mean()* |
| fBodyBodyAccJerkMag_std | Yes | Feature *fBodyBodyAccJerkMag-std()* |
| fBodyBodyAccJerkMag_mad | No | Feature *fBodyBodyAccJerkMag-mad()* |
| fBodyBodyAccJerkMag_max | No | Feature *fBodyBodyAccJerkMag-max()* |
| fBodyBodyAccJerkMag_min | No | Feature *fBodyBodyAccJerkMag-min()* |
| fBodyBodyAccJerkMag_sma | No | Feature *fBodyBodyAccJerkMag-sma()* |
| fBodyBodyAccJerkMag_energy | No | Feature *fBodyBodyAccJerkMag-energy()* |
| fBodyBodyAccJerkMag_iqr | No | Feature *fBodyBodyAccJerkMag-iqr()* |
| fBodyBodyAccJerkMag_entropy | No | Feature *fBodyBodyAccJerkMag-entropy()* |
| fBodyBodyAccJerkMag_maxInds | No | Feature *fBodyBodyAccJerkMag-maxInds* |
| fBodyBodyAccJerkMag_meanFreq | Yes | Feature *fBodyBodyAccJerkMag-meanFreq()* |
| fBodyBodyAccJerkMag_skewness | No | Feature *fBodyBodyAccJerkMag-skewness()* |
| fBodyBodyAccJerkMag_kurtosis | No | Feature *fBodyBodyAccJerkMag-kurtosis()* |
| fBodyBodyGyroMag_mean | Yes | Feature *fBodyBodyGyroMag-mean()* |
| fBodyBodyGyroMag_std | Yes | Feature *fBodyBodyGyroMag-std()* |
| fBodyBodyGyroMag_mad | No | Feature *fBodyBodyGyroMag-mad()* |
| fBodyBodyGyroMag_max | No | Feature *fBodyBodyGyroMag-max()* |
| fBodyBodyGyroMag_min | No | Feature *fBodyBodyGyroMag-min()* |
| fBodyBodyGyroMag_sma | No | Feature *fBodyBodyGyroMag-sma()* |
| fBodyBodyGyroMag_energy | No | Feature *fBodyBodyGyroMag-energy()* |
| fBodyBodyGyroMag_iqr | No | Feature *fBodyBodyGyroMag-iqr()* |
| fBodyBodyGyroMag_entropy | No | Feature *fBodyBodyGyroMag-entropy()* |
| fBodyBodyGyroMag_maxInds | No | Feature *fBodyBodyGyroMag-maxInds* |
| fBodyBodyGyroMag_meanFreq | Yes | Feature *fBodyBodyGyroMag-meanFreq()* |
| fBodyBodyGyroMag_skewness | No | Feature *fBodyBodyGyroMag-skewness()* |
| fBodyBodyGyroMag_kurtosis | No | Feature *fBodyBodyGyroMag-kurtosis()* |
| fBodyBodyGyroJerkMag_mean | Yes | Feature *fBodyBodyGyroJerkMag-mean()* |
| fBodyBodyGyroJerkMag_std | Yes | Feature *fBodyBodyGyroJerkMag-std()* |
| fBodyBodyGyroJerkMag_mad | No | Feature *fBodyBodyGyroJerkMag-mad()* |
| fBodyBodyGyroJerkMag_max | No | Feature *fBodyBodyGyroJerkMag-max()* |
| fBodyBodyGyroJerkMag_min | No | Feature *fBodyBodyGyroJerkMag-min()* |
| fBodyBodyGyroJerkMag_sma | No | Feature *fBodyBodyGyroJerkMag-sma()* |
| fBodyBodyGyroJerkMag_energy | No | Feature *fBodyBodyGyroJerkMag-energy()* |
| fBodyBodyGyroJerkMag_iqr | No | Feature *fBodyBodyGyroJerkMag-iqr()* |
| fBodyBodyGyroJerkMag_entropy | No | Feature *fBodyBodyGyroJerkMag-entropy()* |
| fBodyBodyGyroJerkMag_maxInds | No | Feature *fBodyBodyGyroJerkMag-maxInds* |
| fBodyBodyGyroJerkMag_meanFreq | Yes | Feature *fBodyBodyGyroJerkMag-meanFreq()* |
| fBodyBodyGyroJerkMag_skewness | No | Feature *fBodyBodyGyroJerkMag-skewness()* |
| fBodyBodyGyroJerkMag_kurtosis | No | Feature *fBodyBodyGyroJerkMag-kurtosis()* |
| angletBodyAccMean_gravity | No | Feature *angle(tBodyAccMean,gravity)* |
| angletBodyAccJerkMean_gravityMean | No | Feature *angle(tBodyAccJerkMean),gravityMean)* |
| angletBodyGyroMean_gravityMean | No | Feature *angle(tBodyGyroMean,gravityMean)* |
| angletBodyGyroJerkMean_gravityMean | No | Feature *angle(tBodyGyroJerkMean,gravityMean)* |
| angleX_gravityMean | No | Feature *angle(X,gravityMean)* |
| angleY_gravityMean | No | Feature *angle(Y,gravityMean)* |
| angleZ_gravityMean | No | Feature *angle(Z,gravityMean)* |

