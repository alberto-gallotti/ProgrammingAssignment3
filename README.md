# Coursera - Getting and Cleaning Data - ProgrammingAssignment3

##The run_analysis.R script in this report works as follows:

###1. Downloads the dataset in the working directory
###2. Loads the training and test datasets
###3. Loads the activity and feature info
###4. Loads the activity and subject data for each dataset
###5. Merges test data and adds a column to indicate they are test subjects
###6. Merges train data and adds column to indicate they are train subjects
###7. Merges the two datasets (train data first)
###8. Subsets the complete dataset in order to create a second dataset containing only the columns with means and 
###       standard deviations of the measurements
###9. Insert also descriptive activity names and arrange dataset by increasing patient_id and, secondarily, by
###       increasing activity_id
###10.Creates a new dataset with averages of the values in the columns per patient, per activity
###11.Writes a file with the new dataset (average_subsetdataset_mean_std.txt)