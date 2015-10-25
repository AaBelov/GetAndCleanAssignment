#This is the explaination of what the analysis script does

First of all the script merges test and training sets into one dataset.
Theese parts can be found in X_test.txt and X_train.txt files. 
Then test and training activity labels and subjects are merged togehter in the same way.

The next step is applying column names so that we can select required ones later.
Several labels are used more than one time but column names should be unique.
make.unique function will do the trick.
Names for activity and subjects dataframes are also added.

Now when columns have unique names we can use dplyr::select function and finally merge all parts in one dataset.

Having the complete dataset created we can replace activity codes with activity labels.
They are stored in activity_labels.txt file.

After that we should slightly correct column names.
Lets assume that *thisFormatAsTheMostAppropriate*.
Column names can be changed with sub and gsub functions.

Then the resulting values and dataset are computed with summarize_each function and written in the result.txt file.