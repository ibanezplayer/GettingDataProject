Coursera Getting and Cleaning Data Course Project
==============

**About the code**

The code is written with a lot of checks for exists. The reason is to save time loading and shaping data that has already been loaded and shaped when you run it multiple times.

**Main processes are as follows:**
 - Functions from plyr and reshape2 are used, so we check to install packages and then install if needed.
 - Download and unzip the data files if not already existing
 - Load the features data
 - Load the activity labels
 - Load the train data
 - Bind the activity labels to the train data
 - Load the train subjects
 - Bind the subjects to the train data
 - Load the test data
 - Bind the activity labels to the test data
 - Load the test subjects
 - Bind the subjects to the test data
 - Shrink the data to the required columns
 - Perform the agreegation by subject and activity
 - Write the tidydata.txt output

*The final output is stored in the working directory*