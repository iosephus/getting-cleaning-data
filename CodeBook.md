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


### Inertial data

| Column name | Type    | Possible values   | Description                      |
|-------------|---------|-------------------|----------------------------------|
| subject     | Integer | Interval [1, 30]     | Experimental subject             |
| activity    | Factor  | Set {'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'} | Experimental activity |
| sample      | Integer | Interval [1, 6144] | Ordinal inertial data sample number |
| component   | Factor  | Set {'x', 'y', 'z'} | Component of the 3D XYZ vector        |
| total_acc   | Double  | Interval [-1.7, 2.2] | Acceleration component measured by the accelerometer sensor signal in standard *g* units |
| body_acc    | Double  | Interval [-1.4, 1.3] | Calculated component of body acceleration |
| body_gyro   | Double  | Interval [-6, 5.8] | Angular velocity component measured by the gyroscope sensor in *radians/second* |
| Other 561 columns corresponding to the features (see appendix) |


### Means and standard deviations only


| Column name | Type    | Possible values   | Description                      |
|-------------|---------|-------------------|----------------------------------|
| subject     | Integer | Interval [1, 30]     | Experimental subject             |
| activity    | Factor  | Set {'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'} | Experimental activity |
| set         | Factor  | Set {'Training', 'Test'} | Whether the row was originally in the training or test set |
| window      | Integer | Interval [1, 95] | Number of the time window from which the feature was extracted. |
| tBodyAcc_mean_X | Double | Interval [-1, 1] | Feature *tBodyAcc-mean()-X* |
| tBodyAcc_mean_Y | Double | Interval [-1, 1] | Feature *tBodyAcc-mean()-Y* |
| tBodyAcc_mean_Z | Double | Interval [-1, 1] | Feature *tBodyAcc-mean()-Z* |
| tBodyAcc_std_X | Double | Interval [-1, 1] | Feature *tBodyAcc-std()-X* |
| tBodyAcc_std_Y | Double | Interval [-1, 1] | Feature *tBodyAcc-std()-Y* |
| tBodyAcc_std_Z | Double | Interval [-1, 1] | Feature *tBodyAcc-std()-Z* |
| tGravityAcc_mean_X | Double | Interval [-1, 1] | Feature *tGravityAcc-mean()-X* |
| tGravityAcc_mean_Y | Double | Interval [-1, 1] | Feature *tGravityAcc-mean()-Y* |
| tGravityAcc_mean_Z | Double | Interval [-1, 1] | Feature *tGravityAcc-mean()-Z* |
| tGravityAcc_std_X | Double | Interval [-1, 1] | Feature *tGravityAcc-std()-X* |
| tGravityAcc_std_Y | Double | Interval [-1, 1] | Feature *tGravityAcc-std()-Y* |
| tGravityAcc_std_Z | Double | Interval [-1, 1] | Feature *tGravityAcc-std()-Z* |
| tBodyAccJerk_mean_X | Double | Interval [-1, 1] | Feature *tBodyAccJerk-mean()-X* |
| tBodyAccJerk_mean_Y | Double | Interval [-1, 1] | Feature *tBodyAccJerk-mean()-Y* |
| tBodyAccJerk_mean_Z | Double | Interval [-1, 1] | Feature *tBodyAccJerk-mean()-Z* |
| tBodyAccJerk_std_X | Double | Interval [-1, 1] | Feature *tBodyAccJerk-std()-X* |
| tBodyAccJerk_std_Y | Double | Interval [-1, 1] | Feature *tBodyAccJerk-std()-Y* |
| tBodyAccJerk_std_Z | Double | Interval [-1, 1] | Feature *tBodyAccJerk-std()-Z* |
| tBodyGyro_mean_X | Double | Interval [-1, 1] | Feature *tBodyGyro-mean()-X* |
| tBodyGyro_mean_Y | Double | Interval [-1, 1] | Feature *tBodyGyro-mean()-Y* |
| tBodyGyro_mean_Z | Double | Interval [-1, 1] | Feature *tBodyGyro-mean()-Z* |
| tBodyGyro_std_X | Double | Interval [-1, 1] | Feature *tBodyGyro-std()-X* |
| tBodyGyro_std_Y | Double | Interval [-1, 1] | Feature *tBodyGyro-std()-Y* |
| tBodyGyro_std_Z | Double | Interval [-1, 1] | Feature *tBodyGyro-std()-Z* |
| tBodyGyroJerk_mean_X | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-mean()-X* |
| tBodyGyroJerk_mean_Y | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-mean()-Y* |
| tBodyGyroJerk_mean_Z | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-mean()-Z* |
| tBodyGyroJerk_std_X | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-std()-X* |
| tBodyGyroJerk_std_Y | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-std()-Y* |
| tBodyGyroJerk_std_Z | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-std()-Z* |
| tBodyAccMag_mean | Double | Interval [-1, 1] | Feature *tBodyAccMag-mean()* |
| tBodyAccMag_std | Double | Interval [-1, 1] | Feature *tBodyAccMag-std()* |
| tGravityAccMag_mean | Double | Interval [-1, 1] | Feature *tGravityAccMag-mean()* |
| tGravityAccMag_std | Double | Interval [-1, 1] | Feature *tGravityAccMag-std()* |
| tBodyAccJerkMag_mean | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-mean()* |
| tBodyAccJerkMag_std | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-std()* |
| tBodyGyroMag_mean | Double | Interval [-1, 1] | Feature *tBodyGyroMag-mean()* |
| tBodyGyroMag_std | Double | Interval [-1, 1] | Feature *tBodyGyroMag-std()* |
| tBodyGyroJerkMag_mean | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-mean()* |
| tBodyGyroJerkMag_std | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-std()* |
| fBodyAcc_mean_X | Double | Interval [-1, 1] | Feature *fBodyAcc-mean()-X* |
| fBodyAcc_mean_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-mean()-Y* |
| fBodyAcc_mean_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-mean()-Z* |
| fBodyAcc_std_X | Double | Interval [-1, 1] | Feature *fBodyAcc-std()-X* |
| fBodyAcc_std_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-std()-Y* |
| fBodyAcc_std_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-std()-Z* |
| fBodyAcc_meanFreq_X | Double | Interval [-1, 1] | Feature *fBodyAcc-meanFreq()-X* |
| fBodyAcc_meanFreq_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-meanFreq()-Y* |
| fBodyAcc_meanFreq_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-meanFreq()-Z* |
| fBodyAccJerk_mean_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-mean()-X* |
| fBodyAccJerk_mean_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-mean()-Y* |
| fBodyAccJerk_mean_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-mean()-Z* |
| fBodyAccJerk_std_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-std()-X* |
| fBodyAccJerk_std_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-std()-Y* |
| fBodyAccJerk_std_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-std()-Z* |
| fBodyAccJerk_meanFreq_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-meanFreq()-X* |
| fBodyAccJerk_meanFreq_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-meanFreq()-Y* |
| fBodyAccJerk_meanFreq_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-meanFreq()-Z* |
| fBodyGyro_mean_X | Double | Interval [-1, 1] | Feature *fBodyGyro-mean()-X* |
| fBodyGyro_mean_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-mean()-Y* |
| fBodyGyro_mean_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-mean()-Z* |
| fBodyGyro_std_X | Double | Interval [-1, 1] | Feature *fBodyGyro-std()-X* |
| fBodyGyro_std_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-std()-Y* |
| fBodyGyro_std_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-std()-Z* |
| fBodyGyro_meanFreq_X | Double | Interval [-1, 1] | Feature *fBodyGyro-meanFreq()-X* |
| fBodyGyro_meanFreq_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-meanFreq()-Y* |
| fBodyGyro_meanFreq_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-meanFreq()-Z* |
| fBodyAccMag_mean | Double | Interval [-1, 1] | Feature *fBodyAccMag-mean()* |
| fBodyAccMag_std | Double | Interval [-1, 1] | Feature *fBodyAccMag-std()* |
| fBodyAccMag_meanFreq | Double | Interval [-1, 1] | Feature *fBodyAccMag-meanFreq()* |
| fBodyBodyAccJerkMag_mean | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-mean()* |
| fBodyBodyAccJerkMag_std | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-std()* |
| fBodyBodyAccJerkMag_meanFreq | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-meanFreq()* |
| fBodyBodyGyroMag_mean | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-mean()* |
| fBodyBodyGyroMag_std | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-std()* |
| fBodyBodyGyroMag_meanFreq | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-meanFreq()* |
| fBodyBodyGyroJerkMag_mean | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-mean()* |
| fBodyBodyGyroJerkMag_std | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-std()* |
| fBodyBodyGyroJerkMag_meanFreq | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-meanFreq()* |


### Averages for all variables

| Column name | Type    | Possible values   | Description                      |
|-------------|---------|-------------------|----------------------------------|
| subject     | Integer | Interval [1, 30]     | Experimental subject             |
| activity    | Factor  | Set {'WALKING', 'WALKING_UPSTAIRS', 'WALKING_DOWNSTAIRS', 'SITTING', 'STANDING', 'LAYING'} | Experimental activity |
| windowcount | Integer | Interval [36, 95] | Number of windows over which the average was calculated |
| Other 561 columns corresponding to the averages of the variables described in data$X |


### Appendix - Column description for the 561 features

| Column name | Type    | Possible values   | Description                      |
|-------------|---------|-------------------|----------------------------------|
| tBodyAcc_mean_X | Double | Interval [-1, 1] | Feature *tBodyAcc-mean()-X* |
| tBodyAcc_mean_Y | Double | Interval [-1, 1] | Feature *tBodyAcc-mean()-Y* |
| tBodyAcc_mean_Z | Double | Interval [-1, 1] | Feature *tBodyAcc-mean()-Z* |
| tBodyAcc_std_X | Double | Interval [-1, 1] | Feature *tBodyAcc-std()-X* |
| tBodyAcc_std_Y | Double | Interval [-1, 1] | Feature *tBodyAcc-std()-Y* |
| tBodyAcc_std_Z | Double | Interval [-1, 1] | Feature *tBodyAcc-std()-Z* |
| tBodyAcc_mad_X | Double | Interval [-1, 1] | Feature *tBodyAcc-mad()-X* |
| tBodyAcc_mad_Y | Double | Interval [-1, 1] | Feature *tBodyAcc-mad()-Y* |
| tBodyAcc_mad_Z | Double | Interval [-1, 1] | Feature *tBodyAcc-mad()-Z* |
| tBodyAcc_max_X | Double | Interval [-1, 1] | Feature *tBodyAcc-max()-X* |
| tBodyAcc_max_Y | Double | Interval [-1, 1] | Feature *tBodyAcc-max()-Y* |
| tBodyAcc_max_Z | Double | Interval [-1, 1] | Feature *tBodyAcc-max()-Z* |
| tBodyAcc_min_X | Double | Interval [-1, 1] | Feature *tBodyAcc-min()-X* |
| tBodyAcc_min_Y | Double | Interval [-1, 1] | Feature *tBodyAcc-min()-Y* |
| tBodyAcc_min_Z | Double | Interval [-1, 1] | Feature *tBodyAcc-min()-Z* |
| tBodyAcc_sma | Double | Interval [-1, 1] | Feature *tBodyAcc-sma()* |
| tBodyAcc_energy_X | Double | Interval [-1, 1] | Feature *tBodyAcc-energy()-X* |
| tBodyAcc_energy_Y | Double | Interval [-1, 1] | Feature *tBodyAcc-energy()-Y* |
| tBodyAcc_energy_Z | Double | Interval [-1, 1] | Feature *tBodyAcc-energy()-Z* |
| tBodyAcc_iqr_X | Double | Interval [-1, 1] | Feature *tBodyAcc-iqr()-X* |
| tBodyAcc_iqr_Y | Double | Interval [-1, 1] | Feature *tBodyAcc-iqr()-Y* |
| tBodyAcc_iqr_Z | Double | Interval [-1, 1] | Feature *tBodyAcc-iqr()-Z* |
| tBodyAcc_entropy_X | Double | Interval [-1, 1] | Feature *tBodyAcc-entropy()-X* |
| tBodyAcc_entropy_Y | Double | Interval [-1, 1] | Feature *tBodyAcc-entropy()-Y* |
| tBodyAcc_entropy_Z | Double | Interval [-1, 1] | Feature *tBodyAcc-entropy()-Z* |
| tBodyAcc_arCoeff_X_1 | Double | Interval [-1, 1] | Feature *tBodyAcc-arCoeff()-X,1* |
| tBodyAcc_arCoeff_X_2 | Double | Interval [-1, 1] | Feature *tBodyAcc-arCoeff()-X,2* |
| tBodyAcc_arCoeff_X_3 | Double | Interval [-1, 1] | Feature *tBodyAcc-arCoeff()-X,3* |
| tBodyAcc_arCoeff_X_4 | Double | Interval [-1, 1] | Feature *tBodyAcc-arCoeff()-X,4* |
| tBodyAcc_arCoeff_Y_1 | Double | Interval [-1, 1] | Feature *tBodyAcc-arCoeff()-Y,1* |
| tBodyAcc_arCoeff_Y_2 | Double | Interval [-1, 1] | Feature *tBodyAcc-arCoeff()-Y,2* |
| tBodyAcc_arCoeff_Y_3 | Double | Interval [-1, 1] | Feature *tBodyAcc-arCoeff()-Y,3* |
| tBodyAcc_arCoeff_Y_4 | Double | Interval [-1, 1] | Feature *tBodyAcc-arCoeff()-Y,4* |
| tBodyAcc_arCoeff_Z_1 | Double | Interval [-1, 1] | Feature *tBodyAcc-arCoeff()-Z,1* |
| tBodyAcc_arCoeff_Z_2 | Double | Interval [-1, 1] | Feature *tBodyAcc-arCoeff()-Z,2* |
| tBodyAcc_arCoeff_Z_3 | Double | Interval [-1, 1] | Feature *tBodyAcc-arCoeff()-Z,3* |
| tBodyAcc_arCoeff_Z_4 | Double | Interval [-1, 1] | Feature *tBodyAcc-arCoeff()-Z,4* |
| tBodyAcc_correlation_X_Y | Double | Interval [-1, 1] | Feature *tBodyAcc-correlation()-X,Y* |
| tBodyAcc_correlation_X_Z | Double | Interval [-1, 1] | Feature *tBodyAcc-correlation()-X,Z* |
| tBodyAcc_correlation_Y_Z | Double | Interval [-1, 1] | Feature *tBodyAcc-correlation()-Y,Z* |
| tGravityAcc_mean_X | Double | Interval [-1, 1] | Feature *tGravityAcc-mean()-X* |
| tGravityAcc_mean_Y | Double | Interval [-1, 1] | Feature *tGravityAcc-mean()-Y* |
| tGravityAcc_mean_Z | Double | Interval [-1, 1] | Feature *tGravityAcc-mean()-Z* |
| tGravityAcc_std_X | Double | Interval [-1, 1] | Feature *tGravityAcc-std()-X* |
| tGravityAcc_std_Y | Double | Interval [-1, 1] | Feature *tGravityAcc-std()-Y* |
| tGravityAcc_std_Z | Double | Interval [-1, 1] | Feature *tGravityAcc-std()-Z* |
| tGravityAcc_mad_X | Double | Interval [-1, 1] | Feature *tGravityAcc-mad()-X* |
| tGravityAcc_mad_Y | Double | Interval [-1, 1] | Feature *tGravityAcc-mad()-Y* |
| tGravityAcc_mad_Z | Double | Interval [-1, 1] | Feature *tGravityAcc-mad()-Z* |
| tGravityAcc_max_X | Double | Interval [-1, 1] | Feature *tGravityAcc-max()-X* |
| tGravityAcc_max_Y | Double | Interval [-1, 1] | Feature *tGravityAcc-max()-Y* |
| tGravityAcc_max_Z | Double | Interval [-1, 1] | Feature *tGravityAcc-max()-Z* |
| tGravityAcc_min_X | Double | Interval [-1, 1] | Feature *tGravityAcc-min()-X* |
| tGravityAcc_min_Y | Double | Interval [-1, 1] | Feature *tGravityAcc-min()-Y* |
| tGravityAcc_min_Z | Double | Interval [-1, 1] | Feature *tGravityAcc-min()-Z* |
| tGravityAcc_sma | Double | Interval [-1, 1] | Feature *tGravityAcc-sma()* |
| tGravityAcc_energy_X | Double | Interval [-1, 1] | Feature *tGravityAcc-energy()-X* |
| tGravityAcc_energy_Y | Double | Interval [-1, 1] | Feature *tGravityAcc-energy()-Y* |
| tGravityAcc_energy_Z | Double | Interval [-1, 1] | Feature *tGravityAcc-energy()-Z* |
| tGravityAcc_iqr_X | Double | Interval [-1, 1] | Feature *tGravityAcc-iqr()-X* |
| tGravityAcc_iqr_Y | Double | Interval [-1, 1] | Feature *tGravityAcc-iqr()-Y* |
| tGravityAcc_iqr_Z | Double | Interval [-1, 1] | Feature *tGravityAcc-iqr()-Z* |
| tGravityAcc_entropy_X | Double | Interval [-1, 1] | Feature *tGravityAcc-entropy()-X* |
| tGravityAcc_entropy_Y | Double | Interval [-1, 1] | Feature *tGravityAcc-entropy()-Y* |
| tGravityAcc_entropy_Z | Double | Interval [-1, 1] | Feature *tGravityAcc-entropy()-Z* |
| tGravityAcc_arCoeff_X_1 | Double | Interval [-1, 1] | Feature *tGravityAcc-arCoeff()-X,1* |
| tGravityAcc_arCoeff_X_2 | Double | Interval [-1, 1] | Feature *tGravityAcc-arCoeff()-X,2* |
| tGravityAcc_arCoeff_X_3 | Double | Interval [-1, 1] | Feature *tGravityAcc-arCoeff()-X,3* |
| tGravityAcc_arCoeff_X_4 | Double | Interval [-1, 1] | Feature *tGravityAcc-arCoeff()-X,4* |
| tGravityAcc_arCoeff_Y_1 | Double | Interval [-1, 1] | Feature *tGravityAcc-arCoeff()-Y,1* |
| tGravityAcc_arCoeff_Y_2 | Double | Interval [-1, 1] | Feature *tGravityAcc-arCoeff()-Y,2* |
| tGravityAcc_arCoeff_Y_3 | Double | Interval [-1, 1] | Feature *tGravityAcc-arCoeff()-Y,3* |
| tGravityAcc_arCoeff_Y_4 | Double | Interval [-1, 1] | Feature *tGravityAcc-arCoeff()-Y,4* |
| tGravityAcc_arCoeff_Z_1 | Double | Interval [-1, 1] | Feature *tGravityAcc-arCoeff()-Z,1* |
| tGravityAcc_arCoeff_Z_2 | Double | Interval [-1, 1] | Feature *tGravityAcc-arCoeff()-Z,2* |
| tGravityAcc_arCoeff_Z_3 | Double | Interval [-1, 1] | Feature *tGravityAcc-arCoeff()-Z,3* |
| tGravityAcc_arCoeff_Z_4 | Double | Interval [-1, 1] | Feature *tGravityAcc-arCoeff()-Z,4* |
| tGravityAcc_correlation_X_Y | Double | Interval [-1, 1] | Feature *tGravityAcc-correlation()-X,Y* |
| tGravityAcc_correlation_X_Z | Double | Interval [-1, 1] | Feature *tGravityAcc-correlation()-X,Z* |
| tGravityAcc_correlation_Y_Z | Double | Interval [-1, 1] | Feature *tGravityAcc-correlation()-Y,Z* |
| tBodyAccJerk_mean_X | Double | Interval [-1, 1] | Feature *tBodyAccJerk-mean()-X* |
| tBodyAccJerk_mean_Y | Double | Interval [-1, 1] | Feature *tBodyAccJerk-mean()-Y* |
| tBodyAccJerk_mean_Z | Double | Interval [-1, 1] | Feature *tBodyAccJerk-mean()-Z* |
| tBodyAccJerk_std_X | Double | Interval [-1, 1] | Feature *tBodyAccJerk-std()-X* |
| tBodyAccJerk_std_Y | Double | Interval [-1, 1] | Feature *tBodyAccJerk-std()-Y* |
| tBodyAccJerk_std_Z | Double | Interval [-1, 1] | Feature *tBodyAccJerk-std()-Z* |
| tBodyAccJerk_mad_X | Double | Interval [-1, 1] | Feature *tBodyAccJerk-mad()-X* |
| tBodyAccJerk_mad_Y | Double | Interval [-1, 1] | Feature *tBodyAccJerk-mad()-Y* |
| tBodyAccJerk_mad_Z | Double | Interval [-1, 1] | Feature *tBodyAccJerk-mad()-Z* |
| tBodyAccJerk_max_X | Double | Interval [-1, 1] | Feature *tBodyAccJerk-max()-X* |
| tBodyAccJerk_max_Y | Double | Interval [-1, 1] | Feature *tBodyAccJerk-max()-Y* |
| tBodyAccJerk_max_Z | Double | Interval [-1, 1] | Feature *tBodyAccJerk-max()-Z* |
| tBodyAccJerk_min_X | Double | Interval [-1, 1] | Feature *tBodyAccJerk-min()-X* |
| tBodyAccJerk_min_Y | Double | Interval [-1, 1] | Feature *tBodyAccJerk-min()-Y* |
| tBodyAccJerk_min_Z | Double | Interval [-1, 1] | Feature *tBodyAccJerk-min()-Z* |
| tBodyAccJerk_sma | Double | Interval [-1, 1] | Feature *tBodyAccJerk-sma()* |
| tBodyAccJerk_energy_X | Double | Interval [-1, 1] | Feature *tBodyAccJerk-energy()-X* |
| tBodyAccJerk_energy_Y | Double | Interval [-1, 1] | Feature *tBodyAccJerk-energy()-Y* |
| tBodyAccJerk_energy_Z | Double | Interval [-1, 1] | Feature *tBodyAccJerk-energy()-Z* |
| tBodyAccJerk_iqr_X | Double | Interval [-1, 1] | Feature *tBodyAccJerk-iqr()-X* |
| tBodyAccJerk_iqr_Y | Double | Interval [-1, 1] | Feature *tBodyAccJerk-iqr()-Y* |
| tBodyAccJerk_iqr_Z | Double | Interval [-1, 1] | Feature *tBodyAccJerk-iqr()-Z* |
| tBodyAccJerk_entropy_X | Double | Interval [-1, 1] | Feature *tBodyAccJerk-entropy()-X* |
| tBodyAccJerk_entropy_Y | Double | Interval [-1, 1] | Feature *tBodyAccJerk-entropy()-Y* |
| tBodyAccJerk_entropy_Z | Double | Interval [-1, 1] | Feature *tBodyAccJerk-entropy()-Z* |
| tBodyAccJerk_arCoeff_X_1 | Double | Interval [-1, 1] | Feature *tBodyAccJerk-arCoeff()-X,1* |
| tBodyAccJerk_arCoeff_X_2 | Double | Interval [-1, 1] | Feature *tBodyAccJerk-arCoeff()-X,2* |
| tBodyAccJerk_arCoeff_X_3 | Double | Interval [-1, 1] | Feature *tBodyAccJerk-arCoeff()-X,3* |
| tBodyAccJerk_arCoeff_X_4 | Double | Interval [-1, 1] | Feature *tBodyAccJerk-arCoeff()-X,4* |
| tBodyAccJerk_arCoeff_Y_1 | Double | Interval [-1, 1] | Feature *tBodyAccJerk-arCoeff()-Y,1* |
| tBodyAccJerk_arCoeff_Y_2 | Double | Interval [-1, 1] | Feature *tBodyAccJerk-arCoeff()-Y,2* |
| tBodyAccJerk_arCoeff_Y_3 | Double | Interval [-1, 1] | Feature *tBodyAccJerk-arCoeff()-Y,3* |
| tBodyAccJerk_arCoeff_Y_4 | Double | Interval [-1, 1] | Feature *tBodyAccJerk-arCoeff()-Y,4* |
| tBodyAccJerk_arCoeff_Z_1 | Double | Interval [-1, 1] | Feature *tBodyAccJerk-arCoeff()-Z,1* |
| tBodyAccJerk_arCoeff_Z_2 | Double | Interval [-1, 1] | Feature *tBodyAccJerk-arCoeff()-Z,2* |
| tBodyAccJerk_arCoeff_Z_3 | Double | Interval [-1, 1] | Feature *tBodyAccJerk-arCoeff()-Z,3* |
| tBodyAccJerk_arCoeff_Z_4 | Double | Interval [-1, 1] | Feature *tBodyAccJerk-arCoeff()-Z,4* |
| tBodyAccJerk_correlation_X_Y | Double | Interval [-1, 1] | Feature *tBodyAccJerk-correlation()-X,Y* |
| tBodyAccJerk_correlation_X_Z | Double | Interval [-1, 1] | Feature *tBodyAccJerk-correlation()-X,Z* |
| tBodyAccJerk_correlation_Y_Z | Double | Interval [-1, 1] | Feature *tBodyAccJerk-correlation()-Y,Z* |
| tBodyGyro_mean_X | Double | Interval [-1, 1] | Feature *tBodyGyro-mean()-X* |
| tBodyGyro_mean_Y | Double | Interval [-1, 1] | Feature *tBodyGyro-mean()-Y* |
| tBodyGyro_mean_Z | Double | Interval [-1, 1] | Feature *tBodyGyro-mean()-Z* |
| tBodyGyro_std_X | Double | Interval [-1, 1] | Feature *tBodyGyro-std()-X* |
| tBodyGyro_std_Y | Double | Interval [-1, 1] | Feature *tBodyGyro-std()-Y* |
| tBodyGyro_std_Z | Double | Interval [-1, 1] | Feature *tBodyGyro-std()-Z* |
| tBodyGyro_mad_X | Double | Interval [-1, 1] | Feature *tBodyGyro-mad()-X* |
| tBodyGyro_mad_Y | Double | Interval [-1, 1] | Feature *tBodyGyro-mad()-Y* |
| tBodyGyro_mad_Z | Double | Interval [-1, 1] | Feature *tBodyGyro-mad()-Z* |
| tBodyGyro_max_X | Double | Interval [-1, 1] | Feature *tBodyGyro-max()-X* |
| tBodyGyro_max_Y | Double | Interval [-1, 1] | Feature *tBodyGyro-max()-Y* |
| tBodyGyro_max_Z | Double | Interval [-1, 1] | Feature *tBodyGyro-max()-Z* |
| tBodyGyro_min_X | Double | Interval [-1, 1] | Feature *tBodyGyro-min()-X* |
| tBodyGyro_min_Y | Double | Interval [-1, 1] | Feature *tBodyGyro-min()-Y* |
| tBodyGyro_min_Z | Double | Interval [-1, 1] | Feature *tBodyGyro-min()-Z* |
| tBodyGyro_sma | Double | Interval [-1, 1] | Feature *tBodyGyro-sma()* |
| tBodyGyro_energy_X | Double | Interval [-1, 1] | Feature *tBodyGyro-energy()-X* |
| tBodyGyro_energy_Y | Double | Interval [-1, 1] | Feature *tBodyGyro-energy()-Y* |
| tBodyGyro_energy_Z | Double | Interval [-1, 1] | Feature *tBodyGyro-energy()-Z* |
| tBodyGyro_iqr_X | Double | Interval [-1, 1] | Feature *tBodyGyro-iqr()-X* |
| tBodyGyro_iqr_Y | Double | Interval [-1, 1] | Feature *tBodyGyro-iqr()-Y* |
| tBodyGyro_iqr_Z | Double | Interval [-1, 1] | Feature *tBodyGyro-iqr()-Z* |
| tBodyGyro_entropy_X | Double | Interval [-1, 1] | Feature *tBodyGyro-entropy()-X* |
| tBodyGyro_entropy_Y | Double | Interval [-1, 1] | Feature *tBodyGyro-entropy()-Y* |
| tBodyGyro_entropy_Z | Double | Interval [-1, 1] | Feature *tBodyGyro-entropy()-Z* |
| tBodyGyro_arCoeff_X_1 | Double | Interval [-1, 1] | Feature *tBodyGyro-arCoeff()-X,1* |
| tBodyGyro_arCoeff_X_2 | Double | Interval [-1, 1] | Feature *tBodyGyro-arCoeff()-X,2* |
| tBodyGyro_arCoeff_X_3 | Double | Interval [-1, 1] | Feature *tBodyGyro-arCoeff()-X,3* |
| tBodyGyro_arCoeff_X_4 | Double | Interval [-1, 1] | Feature *tBodyGyro-arCoeff()-X,4* |
| tBodyGyro_arCoeff_Y_1 | Double | Interval [-1, 1] | Feature *tBodyGyro-arCoeff()-Y,1* |
| tBodyGyro_arCoeff_Y_2 | Double | Interval [-1, 1] | Feature *tBodyGyro-arCoeff()-Y,2* |
| tBodyGyro_arCoeff_Y_3 | Double | Interval [-1, 1] | Feature *tBodyGyro-arCoeff()-Y,3* |
| tBodyGyro_arCoeff_Y_4 | Double | Interval [-1, 1] | Feature *tBodyGyro-arCoeff()-Y,4* |
| tBodyGyro_arCoeff_Z_1 | Double | Interval [-1, 1] | Feature *tBodyGyro-arCoeff()-Z,1* |
| tBodyGyro_arCoeff_Z_2 | Double | Interval [-1, 1] | Feature *tBodyGyro-arCoeff()-Z,2* |
| tBodyGyro_arCoeff_Z_3 | Double | Interval [-1, 1] | Feature *tBodyGyro-arCoeff()-Z,3* |
| tBodyGyro_arCoeff_Z_4 | Double | Interval [-1, 1] | Feature *tBodyGyro-arCoeff()-Z,4* |
| tBodyGyro_correlation_X_Y | Double | Interval [-1, 1] | Feature *tBodyGyro-correlation()-X,Y* |
| tBodyGyro_correlation_X_Z | Double | Interval [-1, 1] | Feature *tBodyGyro-correlation()-X,Z* |
| tBodyGyro_correlation_Y_Z | Double | Interval [-1, 1] | Feature *tBodyGyro-correlation()-Y,Z* |
| tBodyGyroJerk_mean_X | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-mean()-X* |
| tBodyGyroJerk_mean_Y | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-mean()-Y* |
| tBodyGyroJerk_mean_Z | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-mean()-Z* |
| tBodyGyroJerk_std_X | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-std()-X* |
| tBodyGyroJerk_std_Y | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-std()-Y* |
| tBodyGyroJerk_std_Z | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-std()-Z* |
| tBodyGyroJerk_mad_X | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-mad()-X* |
| tBodyGyroJerk_mad_Y | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-mad()-Y* |
| tBodyGyroJerk_mad_Z | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-mad()-Z* |
| tBodyGyroJerk_max_X | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-max()-X* |
| tBodyGyroJerk_max_Y | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-max()-Y* |
| tBodyGyroJerk_max_Z | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-max()-Z* |
| tBodyGyroJerk_min_X | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-min()-X* |
| tBodyGyroJerk_min_Y | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-min()-Y* |
| tBodyGyroJerk_min_Z | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-min()-Z* |
| tBodyGyroJerk_sma | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-sma()* |
| tBodyGyroJerk_energy_X | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-energy()-X* |
| tBodyGyroJerk_energy_Y | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-energy()-Y* |
| tBodyGyroJerk_energy_Z | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-energy()-Z* |
| tBodyGyroJerk_iqr_X | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-iqr()-X* |
| tBodyGyroJerk_iqr_Y | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-iqr()-Y* |
| tBodyGyroJerk_iqr_Z | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-iqr()-Z* |
| tBodyGyroJerk_entropy_X | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-entropy()-X* |
| tBodyGyroJerk_entropy_Y | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-entropy()-Y* |
| tBodyGyroJerk_entropy_Z | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-entropy()-Z* |
| tBodyGyroJerk_arCoeff_X_1 | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-arCoeff()-X,1* |
| tBodyGyroJerk_arCoeff_X_2 | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-arCoeff()-X,2* |
| tBodyGyroJerk_arCoeff_X_3 | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-arCoeff()-X,3* |
| tBodyGyroJerk_arCoeff_X_4 | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-arCoeff()-X,4* |
| tBodyGyroJerk_arCoeff_Y_1 | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-arCoeff()-Y,1* |
| tBodyGyroJerk_arCoeff_Y_2 | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-arCoeff()-Y,2* |
| tBodyGyroJerk_arCoeff_Y_3 | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-arCoeff()-Y,3* |
| tBodyGyroJerk_arCoeff_Y_4 | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-arCoeff()-Y,4* |
| tBodyGyroJerk_arCoeff_Z_1 | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-arCoeff()-Z,1* |
| tBodyGyroJerk_arCoeff_Z_2 | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-arCoeff()-Z,2* |
| tBodyGyroJerk_arCoeff_Z_3 | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-arCoeff()-Z,3* |
| tBodyGyroJerk_arCoeff_Z_4 | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-arCoeff()-Z,4* |
| tBodyGyroJerk_correlation_X_Y | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-correlation()-X,Y* |
| tBodyGyroJerk_correlation_X_Z | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-correlation()-X,Z* |
| tBodyGyroJerk_correlation_Y_Z | Double | Interval [-1, 1] | Feature *tBodyGyroJerk-correlation()-Y,Z* |
| tBodyAccMag_mean | Double | Interval [-1, 1] | Feature *tBodyAccMag-mean()* |
| tBodyAccMag_std | Double | Interval [-1, 1] | Feature *tBodyAccMag-std()* |
| tBodyAccMag_mad | Double | Interval [-1, 1] | Feature *tBodyAccMag-mad()* |
| tBodyAccMag_max | Double | Interval [-1, 1] | Feature *tBodyAccMag-max()* |
| tBodyAccMag_min | Double | Interval [-1, 1] | Feature *tBodyAccMag-min()* |
| tBodyAccMag_sma | Double | Interval [-1, 1] | Feature *tBodyAccMag-sma()* |
| tBodyAccMag_energy | Double | Interval [-1, 1] | Feature *tBodyAccMag-energy()* |
| tBodyAccMag_iqr | Double | Interval [-1, 1] | Feature *tBodyAccMag-iqr()* |
| tBodyAccMag_entropy | Double | Interval [-1, 1] | Feature *tBodyAccMag-entropy()* |
| tBodyAccMag_arCoeff1 | Double | Interval [-1, 1] | Feature *tBodyAccMag-arCoeff()1* |
| tBodyAccMag_arCoeff2 | Double | Interval [-1, 1] | Feature *tBodyAccMag-arCoeff()2* |
| tBodyAccMag_arCoeff3 | Double | Interval [-1, 1] | Feature *tBodyAccMag-arCoeff()3* |
| tBodyAccMag_arCoeff4 | Double | Interval [-1, 1] | Feature *tBodyAccMag-arCoeff()4* |
| tGravityAccMag_mean | Double | Interval [-1, 1] | Feature *tGravityAccMag-mean()* |
| tGravityAccMag_std | Double | Interval [-1, 1] | Feature *tGravityAccMag-std()* |
| tGravityAccMag_mad | Double | Interval [-1, 1] | Feature *tGravityAccMag-mad()* |
| tGravityAccMag_max | Double | Interval [-1, 1] | Feature *tGravityAccMag-max()* |
| tGravityAccMag_min | Double | Interval [-1, 1] | Feature *tGravityAccMag-min()* |
| tGravityAccMag_sma | Double | Interval [-1, 1] | Feature *tGravityAccMag-sma()* |
| tGravityAccMag_energy | Double | Interval [-1, 1] | Feature *tGravityAccMag-energy()* |
| tGravityAccMag_iqr | Double | Interval [-1, 1] | Feature *tGravityAccMag-iqr()* |
| tGravityAccMag_entropy | Double | Interval [-1, 1] | Feature *tGravityAccMag-entropy()* |
| tGravityAccMag_arCoeff1 | Double | Interval [-1, 1] | Feature *tGravityAccMag-arCoeff()1* |
| tGravityAccMag_arCoeff2 | Double | Interval [-1, 1] | Feature *tGravityAccMag-arCoeff()2* |
| tGravityAccMag_arCoeff3 | Double | Interval [-1, 1] | Feature *tGravityAccMag-arCoeff()3* |
| tGravityAccMag_arCoeff4 | Double | Interval [-1, 1] | Feature *tGravityAccMag-arCoeff()4* |
| tBodyAccJerkMag_mean | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-mean()* |
| tBodyAccJerkMag_std | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-std()* |
| tBodyAccJerkMag_mad | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-mad()* |
| tBodyAccJerkMag_max | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-max()* |
| tBodyAccJerkMag_min | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-min()* |
| tBodyAccJerkMag_sma | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-sma()* |
| tBodyAccJerkMag_energy | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-energy()* |
| tBodyAccJerkMag_iqr | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-iqr()* |
| tBodyAccJerkMag_entropy | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-entropy()* |
| tBodyAccJerkMag_arCoeff1 | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-arCoeff()1* |
| tBodyAccJerkMag_arCoeff2 | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-arCoeff()2* |
| tBodyAccJerkMag_arCoeff3 | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-arCoeff()3* |
| tBodyAccJerkMag_arCoeff4 | Double | Interval [-1, 1] | Feature *tBodyAccJerkMag-arCoeff()4* |
| tBodyGyroMag_mean | Double | Interval [-1, 1] | Feature *tBodyGyroMag-mean()* |
| tBodyGyroMag_std | Double | Interval [-1, 1] | Feature *tBodyGyroMag-std()* |
| tBodyGyroMag_mad | Double | Interval [-1, 1] | Feature *tBodyGyroMag-mad()* |
| tBodyGyroMag_max | Double | Interval [-1, 1] | Feature *tBodyGyroMag-max()* |
| tBodyGyroMag_min | Double | Interval [-1, 1] | Feature *tBodyGyroMag-min()* |
| tBodyGyroMag_sma | Double | Interval [-1, 1] | Feature *tBodyGyroMag-sma()* |
| tBodyGyroMag_energy | Double | Interval [-1, 1] | Feature *tBodyGyroMag-energy()* |
| tBodyGyroMag_iqr | Double | Interval [-1, 1] | Feature *tBodyGyroMag-iqr()* |
| tBodyGyroMag_entropy | Double | Interval [-1, 1] | Feature *tBodyGyroMag-entropy()* |
| tBodyGyroMag_arCoeff1 | Double | Interval [-1, 1] | Feature *tBodyGyroMag-arCoeff()1* |
| tBodyGyroMag_arCoeff2 | Double | Interval [-1, 1] | Feature *tBodyGyroMag-arCoeff()2* |
| tBodyGyroMag_arCoeff3 | Double | Interval [-1, 1] | Feature *tBodyGyroMag-arCoeff()3* |
| tBodyGyroMag_arCoeff4 | Double | Interval [-1, 1] | Feature *tBodyGyroMag-arCoeff()4* |
| tBodyGyroJerkMag_mean | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-mean()* |
| tBodyGyroJerkMag_std | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-std()* |
| tBodyGyroJerkMag_mad | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-mad()* |
| tBodyGyroJerkMag_max | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-max()* |
| tBodyGyroJerkMag_min | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-min()* |
| tBodyGyroJerkMag_sma | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-sma()* |
| tBodyGyroJerkMag_energy | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-energy()* |
| tBodyGyroJerkMag_iqr | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-iqr()* |
| tBodyGyroJerkMag_entropy | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-entropy()* |
| tBodyGyroJerkMag_arCoeff1 | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-arCoeff()1* |
| tBodyGyroJerkMag_arCoeff2 | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-arCoeff()2* |
| tBodyGyroJerkMag_arCoeff3 | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-arCoeff()3* |
| tBodyGyroJerkMag_arCoeff4 | Double | Interval [-1, 1] | Feature *tBodyGyroJerkMag-arCoeff()4* |
| fBodyAcc_mean_X | Double | Interval [-1, 1] | Feature *fBodyAcc-mean()-X* |
| fBodyAcc_mean_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-mean()-Y* |
| fBodyAcc_mean_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-mean()-Z* |
| fBodyAcc_std_X | Double | Interval [-1, 1] | Feature *fBodyAcc-std()-X* |
| fBodyAcc_std_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-std()-Y* |
| fBodyAcc_std_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-std()-Z* |
| fBodyAcc_mad_X | Double | Interval [-1, 1] | Feature *fBodyAcc-mad()-X* |
| fBodyAcc_mad_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-mad()-Y* |
| fBodyAcc_mad_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-mad()-Z* |
| fBodyAcc_max_X | Double | Interval [-1, 1] | Feature *fBodyAcc-max()-X* |
| fBodyAcc_max_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-max()-Y* |
| fBodyAcc_max_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-max()-Z* |
| fBodyAcc_min_X | Double | Interval [-1, 1] | Feature *fBodyAcc-min()-X* |
| fBodyAcc_min_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-min()-Y* |
| fBodyAcc_min_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-min()-Z* |
| fBodyAcc_sma | Double | Interval [-1, 1] | Feature *fBodyAcc-sma()* |
| fBodyAcc_energy_X | Double | Interval [-1, 1] | Feature *fBodyAcc-energy()-X* |
| fBodyAcc_energy_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-energy()-Y* |
| fBodyAcc_energy_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-energy()-Z* |
| fBodyAcc_iqr_X | Double | Interval [-1, 1] | Feature *fBodyAcc-iqr()-X* |
| fBodyAcc_iqr_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-iqr()-Y* |
| fBodyAcc_iqr_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-iqr()-Z* |
| fBodyAcc_entropy_X | Double | Interval [-1, 1] | Feature *fBodyAcc-entropy()-X* |
| fBodyAcc_entropy_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-entropy()-Y* |
| fBodyAcc_entropy_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-entropy()-Z* |
| fBodyAcc_maxInds_X | Double | Interval [-1, 1] | Feature *fBodyAcc-maxInds-X* |
| fBodyAcc_maxInds_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-maxInds-Y* |
| fBodyAcc_maxInds_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-maxInds-Z* |
| fBodyAcc_meanFreq_X | Double | Interval [-1, 1] | Feature *fBodyAcc-meanFreq()-X* |
| fBodyAcc_meanFreq_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-meanFreq()-Y* |
| fBodyAcc_meanFreq_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-meanFreq()-Z* |
| fBodyAcc_skewness_X | Double | Interval [-1, 1] | Feature *fBodyAcc-skewness()-X* |
| fBodyAcc_kurtosis_X | Double | Interval [-1, 1] | Feature *fBodyAcc-kurtosis()-X* |
| fBodyAcc_skewness_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-skewness()-Y* |
| fBodyAcc_kurtosis_Y | Double | Interval [-1, 1] | Feature *fBodyAcc-kurtosis()-Y* |
| fBodyAcc_skewness_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-skewness()-Z* |
| fBodyAcc_kurtosis_Z | Double | Interval [-1, 1] | Feature *fBodyAcc-kurtosis()-Z* |
| fBodyAcc_bandsEnergy_1_8-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-1,8* |
| fBodyAcc_bandsEnergy_9_16-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-9,16* |
| fBodyAcc_bandsEnergy_17_24-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-17,24* |
| fBodyAcc_bandsEnergy_25_32-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-25,32* |
| fBodyAcc_bandsEnergy_33_40-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-33,40* |
| fBodyAcc_bandsEnergy_41_48-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-41,48* |
| fBodyAcc_bandsEnergy_49_56-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-49,56* |
| fBodyAcc_bandsEnergy_57_64-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-57,64* |
| fBodyAcc_bandsEnergy_1_16-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-1,16* |
| fBodyAcc_bandsEnergy_17_32-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-17,32* |
| fBodyAcc_bandsEnergy_33_48-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-33,48* |
| fBodyAcc_bandsEnergy_49_64-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-49,64* |
| fBodyAcc_bandsEnergy_1_24-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-1,24* |
| fBodyAcc_bandsEnergy_25_48-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-25,48* |
| fBodyAcc_bandsEnergy_1_8-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-1,8* |
| fBodyAcc_bandsEnergy_9_16-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-9,16* |
| fBodyAcc_bandsEnergy_17_24-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-17,24* |
| fBodyAcc_bandsEnergy_25_32-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-25,32* |
| fBodyAcc_bandsEnergy_33_40-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-33,40* |
| fBodyAcc_bandsEnergy_41_48-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-41,48* |
| fBodyAcc_bandsEnergy_49_56-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-49,56* |
| fBodyAcc_bandsEnergy_57_64-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-57,64* |
| fBodyAcc_bandsEnergy_1_16-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-1,16* |
| fBodyAcc_bandsEnergy_17_32-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-17,32* |
| fBodyAcc_bandsEnergy_33_48-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-33,48* |
| fBodyAcc_bandsEnergy_49_64-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-49,64* |
| fBodyAcc_bandsEnergy_1_24-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-1,24* |
| fBodyAcc_bandsEnergy_25_48-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-25,48* |
| fBodyAcc_bandsEnergy_1_8-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-1,8* |
| fBodyAcc_bandsEnergy_9_16-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-9,16* |
| fBodyAcc_bandsEnergy_17_24-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-17,24* |
| fBodyAcc_bandsEnergy_25_32-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-25,32* |
| fBodyAcc_bandsEnergy_33_40-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-33,40* |
| fBodyAcc_bandsEnergy_41_48-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-41,48* |
| fBodyAcc_bandsEnergy_49_56-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-49,56* |
| fBodyAcc_bandsEnergy_57_64-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-57,64* |
| fBodyAcc_bandsEnergy_1_16-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-1,16* |
| fBodyAcc_bandsEnergy_17_32-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-17,32* |
| fBodyAcc_bandsEnergy_33_48-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-33,48* |
| fBodyAcc_bandsEnergy_49_64-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-49,64* |
| fBodyAcc_bandsEnergy_1_24-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-1,24* |
| fBodyAcc_bandsEnergy_25_48-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAcc-bandsEnergy()-25,48* |
| fBodyAccJerk_mean_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-mean()-X* |
| fBodyAccJerk_mean_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-mean()-Y* |
| fBodyAccJerk_mean_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-mean()-Z* |
| fBodyAccJerk_std_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-std()-X* |
| fBodyAccJerk_std_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-std()-Y* |
| fBodyAccJerk_std_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-std()-Z* |
| fBodyAccJerk_mad_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-mad()-X* |
| fBodyAccJerk_mad_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-mad()-Y* |
| fBodyAccJerk_mad_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-mad()-Z* |
| fBodyAccJerk_max_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-max()-X* |
| fBodyAccJerk_max_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-max()-Y* |
| fBodyAccJerk_max_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-max()-Z* |
| fBodyAccJerk_min_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-min()-X* |
| fBodyAccJerk_min_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-min()-Y* |
| fBodyAccJerk_min_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-min()-Z* |
| fBodyAccJerk_sma | Double | Interval [-1, 1] | Feature *fBodyAccJerk-sma()* |
| fBodyAccJerk_energy_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-energy()-X* |
| fBodyAccJerk_energy_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-energy()-Y* |
| fBodyAccJerk_energy_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-energy()-Z* |
| fBodyAccJerk_iqr_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-iqr()-X* |
| fBodyAccJerk_iqr_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-iqr()-Y* |
| fBodyAccJerk_iqr_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-iqr()-Z* |
| fBodyAccJerk_entropy_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-entropy()-X* |
| fBodyAccJerk_entropy_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-entropy()-Y* |
| fBodyAccJerk_entropy_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-entropy()-Z* |
| fBodyAccJerk_maxInds_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-maxInds-X* |
| fBodyAccJerk_maxInds_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-maxInds-Y* |
| fBodyAccJerk_maxInds_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-maxInds-Z* |
| fBodyAccJerk_meanFreq_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-meanFreq()-X* |
| fBodyAccJerk_meanFreq_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-meanFreq()-Y* |
| fBodyAccJerk_meanFreq_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-meanFreq()-Z* |
| fBodyAccJerk_skewness_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-skewness()-X* |
| fBodyAccJerk_kurtosis_X | Double | Interval [-1, 1] | Feature *fBodyAccJerk-kurtosis()-X* |
| fBodyAccJerk_skewness_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-skewness()-Y* |
| fBodyAccJerk_kurtosis_Y | Double | Interval [-1, 1] | Feature *fBodyAccJerk-kurtosis()-Y* |
| fBodyAccJerk_skewness_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-skewness()-Z* |
| fBodyAccJerk_kurtosis_Z | Double | Interval [-1, 1] | Feature *fBodyAccJerk-kurtosis()-Z* |
| fBodyAccJerk_bandsEnergy_1_8-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-1,8* |
| fBodyAccJerk_bandsEnergy_9_16-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-9,16* |
| fBodyAccJerk_bandsEnergy_17_24-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-17,24* |
| fBodyAccJerk_bandsEnergy_25_32-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-25,32* |
| fBodyAccJerk_bandsEnergy_33_40-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-33,40* |
| fBodyAccJerk_bandsEnergy_41_48-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-41,48* |
| fBodyAccJerk_bandsEnergy_49_56-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-49,56* |
| fBodyAccJerk_bandsEnergy_57_64-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-57,64* |
| fBodyAccJerk_bandsEnergy_1_16-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-1,16* |
| fBodyAccJerk_bandsEnergy_17_32-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-17,32* |
| fBodyAccJerk_bandsEnergy_33_48-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-33,48* |
| fBodyAccJerk_bandsEnergy_49_64-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-49,64* |
| fBodyAccJerk_bandsEnergy_1_24-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-1,24* |
| fBodyAccJerk_bandsEnergy_25_48-DUP1 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-25,48* |
| fBodyAccJerk_bandsEnergy_1_8-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-1,8* |
| fBodyAccJerk_bandsEnergy_9_16-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-9,16* |
| fBodyAccJerk_bandsEnergy_17_24-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-17,24* |
| fBodyAccJerk_bandsEnergy_25_32-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-25,32* |
| fBodyAccJerk_bandsEnergy_33_40-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-33,40* |
| fBodyAccJerk_bandsEnergy_41_48-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-41,48* |
| fBodyAccJerk_bandsEnergy_49_56-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-49,56* |
| fBodyAccJerk_bandsEnergy_57_64-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-57,64* |
| fBodyAccJerk_bandsEnergy_1_16-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-1,16* |
| fBodyAccJerk_bandsEnergy_17_32-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-17,32* |
| fBodyAccJerk_bandsEnergy_33_48-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-33,48* |
| fBodyAccJerk_bandsEnergy_49_64-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-49,64* |
| fBodyAccJerk_bandsEnergy_1_24-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-1,24* |
| fBodyAccJerk_bandsEnergy_25_48-DUP2 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-25,48* |
| fBodyAccJerk_bandsEnergy_1_8-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-1,8* |
| fBodyAccJerk_bandsEnergy_9_16-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-9,16* |
| fBodyAccJerk_bandsEnergy_17_24-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-17,24* |
| fBodyAccJerk_bandsEnergy_25_32-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-25,32* |
| fBodyAccJerk_bandsEnergy_33_40-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-33,40* |
| fBodyAccJerk_bandsEnergy_41_48-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-41,48* |
| fBodyAccJerk_bandsEnergy_49_56-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-49,56* |
| fBodyAccJerk_bandsEnergy_57_64-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-57,64* |
| fBodyAccJerk_bandsEnergy_1_16-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-1,16* |
| fBodyAccJerk_bandsEnergy_17_32-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-17,32* |
| fBodyAccJerk_bandsEnergy_33_48-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-33,48* |
| fBodyAccJerk_bandsEnergy_49_64-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-49,64* |
| fBodyAccJerk_bandsEnergy_1_24-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-1,24* |
| fBodyAccJerk_bandsEnergy_25_48-DUP3 | Double | Interval [-1, 1] | Feature *fBodyAccJerk-bandsEnergy()-25,48* |
| fBodyGyro_mean_X | Double | Interval [-1, 1] | Feature *fBodyGyro-mean()-X* |
| fBodyGyro_mean_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-mean()-Y* |
| fBodyGyro_mean_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-mean()-Z* |
| fBodyGyro_std_X | Double | Interval [-1, 1] | Feature *fBodyGyro-std()-X* |
| fBodyGyro_std_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-std()-Y* |
| fBodyGyro_std_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-std()-Z* |
| fBodyGyro_mad_X | Double | Interval [-1, 1] | Feature *fBodyGyro-mad()-X* |
| fBodyGyro_mad_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-mad()-Y* |
| fBodyGyro_mad_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-mad()-Z* |
| fBodyGyro_max_X | Double | Interval [-1, 1] | Feature *fBodyGyro-max()-X* |
| fBodyGyro_max_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-max()-Y* |
| fBodyGyro_max_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-max()-Z* |
| fBodyGyro_min_X | Double | Interval [-1, 1] | Feature *fBodyGyro-min()-X* |
| fBodyGyro_min_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-min()-Y* |
| fBodyGyro_min_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-min()-Z* |
| fBodyGyro_sma | Double | Interval [-1, 1] | Feature *fBodyGyro-sma()* |
| fBodyGyro_energy_X | Double | Interval [-1, 1] | Feature *fBodyGyro-energy()-X* |
| fBodyGyro_energy_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-energy()-Y* |
| fBodyGyro_energy_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-energy()-Z* |
| fBodyGyro_iqr_X | Double | Interval [-1, 1] | Feature *fBodyGyro-iqr()-X* |
| fBodyGyro_iqr_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-iqr()-Y* |
| fBodyGyro_iqr_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-iqr()-Z* |
| fBodyGyro_entropy_X | Double | Interval [-1, 1] | Feature *fBodyGyro-entropy()-X* |
| fBodyGyro_entropy_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-entropy()-Y* |
| fBodyGyro_entropy_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-entropy()-Z* |
| fBodyGyro_maxInds_X | Double | Interval [-1, 1] | Feature *fBodyGyro-maxInds-X* |
| fBodyGyro_maxInds_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-maxInds-Y* |
| fBodyGyro_maxInds_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-maxInds-Z* |
| fBodyGyro_meanFreq_X | Double | Interval [-1, 1] | Feature *fBodyGyro-meanFreq()-X* |
| fBodyGyro_meanFreq_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-meanFreq()-Y* |
| fBodyGyro_meanFreq_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-meanFreq()-Z* |
| fBodyGyro_skewness_X | Double | Interval [-1, 1] | Feature *fBodyGyro-skewness()-X* |
| fBodyGyro_kurtosis_X | Double | Interval [-1, 1] | Feature *fBodyGyro-kurtosis()-X* |
| fBodyGyro_skewness_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-skewness()-Y* |
| fBodyGyro_kurtosis_Y | Double | Interval [-1, 1] | Feature *fBodyGyro-kurtosis()-Y* |
| fBodyGyro_skewness_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-skewness()-Z* |
| fBodyGyro_kurtosis_Z | Double | Interval [-1, 1] | Feature *fBodyGyro-kurtosis()-Z* |
| fBodyGyro_bandsEnergy_1_8-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-1,8* |
| fBodyGyro_bandsEnergy_9_16-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-9,16* |
| fBodyGyro_bandsEnergy_17_24-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-17,24* |
| fBodyGyro_bandsEnergy_25_32-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-25,32* |
| fBodyGyro_bandsEnergy_33_40-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-33,40* |
| fBodyGyro_bandsEnergy_41_48-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-41,48* |
| fBodyGyro_bandsEnergy_49_56-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-49,56* |
| fBodyGyro_bandsEnergy_57_64-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-57,64* |
| fBodyGyro_bandsEnergy_1_16-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-1,16* |
| fBodyGyro_bandsEnergy_17_32-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-17,32* |
| fBodyGyro_bandsEnergy_33_48-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-33,48* |
| fBodyGyro_bandsEnergy_49_64-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-49,64* |
| fBodyGyro_bandsEnergy_1_24-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-1,24* |
| fBodyGyro_bandsEnergy_25_48-DUP1 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-25,48* |
| fBodyGyro_bandsEnergy_1_8-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-1,8* |
| fBodyGyro_bandsEnergy_9_16-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-9,16* |
| fBodyGyro_bandsEnergy_17_24-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-17,24* |
| fBodyGyro_bandsEnergy_25_32-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-25,32* |
| fBodyGyro_bandsEnergy_33_40-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-33,40* |
| fBodyGyro_bandsEnergy_41_48-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-41,48* |
| fBodyGyro_bandsEnergy_49_56-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-49,56* |
| fBodyGyro_bandsEnergy_57_64-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-57,64* |
| fBodyGyro_bandsEnergy_1_16-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-1,16* |
| fBodyGyro_bandsEnergy_17_32-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-17,32* |
| fBodyGyro_bandsEnergy_33_48-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-33,48* |
| fBodyGyro_bandsEnergy_49_64-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-49,64* |
| fBodyGyro_bandsEnergy_1_24-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-1,24* |
| fBodyGyro_bandsEnergy_25_48-DUP2 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-25,48* |
| fBodyGyro_bandsEnergy_1_8-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-1,8* |
| fBodyGyro_bandsEnergy_9_16-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-9,16* |
| fBodyGyro_bandsEnergy_17_24-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-17,24* |
| fBodyGyro_bandsEnergy_25_32-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-25,32* |
| fBodyGyro_bandsEnergy_33_40-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-33,40* |
| fBodyGyro_bandsEnergy_41_48-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-41,48* |
| fBodyGyro_bandsEnergy_49_56-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-49,56* |
| fBodyGyro_bandsEnergy_57_64-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-57,64* |
| fBodyGyro_bandsEnergy_1_16-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-1,16* |
| fBodyGyro_bandsEnergy_17_32-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-17,32* |
| fBodyGyro_bandsEnergy_33_48-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-33,48* |
| fBodyGyro_bandsEnergy_49_64-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-49,64* |
| fBodyGyro_bandsEnergy_1_24-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-1,24* |
| fBodyGyro_bandsEnergy_25_48-DUP3 | Double | Interval [-1, 1] | Feature *fBodyGyro-bandsEnergy()-25,48* |
| fBodyAccMag_mean | Double | Interval [-1, 1] | Feature *fBodyAccMag-mean()* |
| fBodyAccMag_std | Double | Interval [-1, 1] | Feature *fBodyAccMag-std()* |
| fBodyAccMag_mad | Double | Interval [-1, 1] | Feature *fBodyAccMag-mad()* |
| fBodyAccMag_max | Double | Interval [-1, 1] | Feature *fBodyAccMag-max()* |
| fBodyAccMag_min | Double | Interval [-1, 1] | Feature *fBodyAccMag-min()* |
| fBodyAccMag_sma | Double | Interval [-1, 1] | Feature *fBodyAccMag-sma()* |
| fBodyAccMag_energy | Double | Interval [-1, 1] | Feature *fBodyAccMag-energy()* |
| fBodyAccMag_iqr | Double | Interval [-1, 1] | Feature *fBodyAccMag-iqr()* |
| fBodyAccMag_entropy | Double | Interval [-1, 1] | Feature *fBodyAccMag-entropy()* |
| fBodyAccMag_maxInds | Double | Interval [-1, 1] | Feature *fBodyAccMag-maxInds* |
| fBodyAccMag_meanFreq | Double | Interval [-1, 1] | Feature *fBodyAccMag-meanFreq()* |
| fBodyAccMag_skewness | Double | Interval [-1, 1] | Feature *fBodyAccMag-skewness()* |
| fBodyAccMag_kurtosis | Double | Interval [-1, 1] | Feature *fBodyAccMag-kurtosis()* |
| fBodyBodyAccJerkMag_mean | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-mean()* |
| fBodyBodyAccJerkMag_std | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-std()* |
| fBodyBodyAccJerkMag_mad | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-mad()* |
| fBodyBodyAccJerkMag_max | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-max()* |
| fBodyBodyAccJerkMag_min | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-min()* |
| fBodyBodyAccJerkMag_sma | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-sma()* |
| fBodyBodyAccJerkMag_energy | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-energy()* |
| fBodyBodyAccJerkMag_iqr | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-iqr()* |
| fBodyBodyAccJerkMag_entropy | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-entropy()* |
| fBodyBodyAccJerkMag_maxInds | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-maxInds* |
| fBodyBodyAccJerkMag_meanFreq | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-meanFreq()* |
| fBodyBodyAccJerkMag_skewness | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-skewness()* |
| fBodyBodyAccJerkMag_kurtosis | Double | Interval [-1, 1] | Feature *fBodyBodyAccJerkMag-kurtosis()* |
| fBodyBodyGyroMag_mean | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-mean()* |
| fBodyBodyGyroMag_std | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-std()* |
| fBodyBodyGyroMag_mad | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-mad()* |
| fBodyBodyGyroMag_max | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-max()* |
| fBodyBodyGyroMag_min | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-min()* |
| fBodyBodyGyroMag_sma | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-sma()* |
| fBodyBodyGyroMag_energy | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-energy()* |
| fBodyBodyGyroMag_iqr | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-iqr()* |
| fBodyBodyGyroMag_entropy | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-entropy()* |
| fBodyBodyGyroMag_maxInds | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-maxInds* |
| fBodyBodyGyroMag_meanFreq | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-meanFreq()* |
| fBodyBodyGyroMag_skewness | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-skewness()* |
| fBodyBodyGyroMag_kurtosis | Double | Interval [-1, 1] | Feature *fBodyBodyGyroMag-kurtosis()* |
| fBodyBodyGyroJerkMag_mean | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-mean()* |
| fBodyBodyGyroJerkMag_std | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-std()* |
| fBodyBodyGyroJerkMag_mad | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-mad()* |
| fBodyBodyGyroJerkMag_max | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-max()* |
| fBodyBodyGyroJerkMag_min | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-min()* |
| fBodyBodyGyroJerkMag_sma | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-sma()* |
| fBodyBodyGyroJerkMag_energy | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-energy()* |
| fBodyBodyGyroJerkMag_iqr | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-iqr()* |
| fBodyBodyGyroJerkMag_entropy | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-entropy()* |
| fBodyBodyGyroJerkMag_maxInds | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-maxInds* |
| fBodyBodyGyroJerkMag_meanFreq | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-meanFreq()* |
| fBodyBodyGyroJerkMag_skewness | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-skewness()* |
| fBodyBodyGyroJerkMag_kurtosis | Double | Interval [-1, 1] | Feature *fBodyBodyGyroJerkMag-kurtosis()* |
| angletBodyAccMean_gravity | Double | Interval [-1, 1] | Feature *angle(tBodyAccMean,gravity)* |
| angletBodyAccJerkMean_gravityMean | Double | Interval [-1, 1] | Feature *angle(tBodyAccJerkMean),gravityMean)* |
| angletBodyGyroMean_gravityMean | Double | Interval [-1, 1] | Feature *angle(tBodyGyroMean,gravityMean)* |
| angletBodyGyroJerkMean_gravityMean | Double | Interval [-1, 1] | Feature *angle(tBodyGyroJerkMean,gravityMean)* |
| angleX_gravityMean | Double | Interval [-1, 1] | Feature *angle(X,gravityMean)* |
| angleY_gravityMean | Double | Interval [-1, 1] | Feature *angle(Y,gravityMean)* |
| angleZ_gravityMean | Double |Interval [-1, 1] | Feature *angle(Z,gravityMean)* |

