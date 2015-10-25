# getting_cleaning_data_project

Summary : 
The purpose of the script is to read in data from two different directories. The files are read into tables. 
The tables then get assigned headers and merged with other tables containing id information which will help 
indentifying each record uniquely. After extracing only the desired columns an average function is applied 
to produce the final result.

Description:
We first read all the features from the features.txt file. The list of features will later make up the column headers of 
the x_train and x_test files.
We then read in the activity labels from the activity_labels.txt

We then read in the data in the subject_train.txt file and the data in the y_train.txt and column bind the two togehter
which associates a given subject to an activity, and we store the result in a data frame called train_ids for later use.

We then create a column called named_activity and concatenate it to the train_ids data frame. This column 
will be used to store descriptive textual values of the activity performed. We populate it by using the 
mutate function and ifelse statement to map the numerical activity_id to the the corresponding textual value.

We then read in the x_train.txt file which contains the numerical values of all the features.
We give the resulting data frame headers based on the values of the features list file (features.txt).

We then merge the data frame containing the id's (subject_id,activity_id,activity_label) with the features data frame
thus producing a properly idenitfiable dataset for the train data only.

The same steps were repeated for the test data.

Both data from the train and the test data are then merged using rbind to produce a 10,000+ rows dataset called merged_data.

Using the data.table package, we convert the features list created to a data table which would allow us 
to extract in a quick way only those headers containing the words "mean" and "std".
Those headers are combined and new narrow dataset of only 82 columns is created. The first three columns are subject_id,
activity_id and activity_label and the rest of the 79 columns are numeical Standard deviation and Mean values.

Finally, Using the dplyr package we group by subject and activity and calculate the mean of the 
STD and MEAN values and store it in a file called "summary_by_subject_activity.txt"


