##################################################################
## Purpose : to extract and tidy data from a dataset
##           and give a consise summary of partial data elements
##
## Author : Mahmoud Badreddine
## Date:  2015/10/25
##
##################################################################

    library(dplyr)
    library(data.table)
    
    #read all the features from the features.txt file. The list of features will be the column headers of the x_train
    # and x_test files.
    features_list <- read.table("./features.txt")
    activity_list <- read.table("./activity_labels.txt")
    
    #Assign table headers to the first two colums of the activity table
    names(activity_list) <- c("activity_id","activity_label")
    
    
    #Read in all the id's of the subject_train.txt file.
    tr_subject_id <- read.table("./train/subject_train.txt")
    #Read in all the id's of the activity file.
    tr_activity_id <- read.table("./train/y_train.txt")
    
    #column bind the subject id's and the activity id's in a table which when merged associates a subject to an activity
    # and store in data frame called train_ids
    train_ids <- cbind(tr_subject_id,tr_activity_id)
    
    #Create a new column which will hold descriptive textual value of the activity performed.
    named_activity <- c("")
    
    #Concatenate the named activity column (which is empty at this point) to the first two columns of id's of subject and activity respectively.
    train_ids <- cbind(train_ids,named_activity)
    
    #Assign table headers to the first three columns 
    names(train_ids) <- c("subject_id","activity_id","activity_label")
    
    #Populate the activity_label column with values based on the activity list. 1 => Walking, 2 => Walking upstairs....etc.
    train_ids <- mutate(train_ids, activity_label = ifelse(activity_id == 1, "WALKING",
                                                           ifelse(activity_id == 2, "WALKING_UPSTAIRS",
                                                                  ifelse(activity_id == 3, "WALKING_DOWNSTAIRS",
                                                                         ifelse(activity_id == 4, "SITTING",
                                                                                ifelse(activity_id == 5, "STANDING",
                                                                                       ifelse(activity_id == 6, "LAYING","")))))))
    
    #read in the x_train.txt file into the x_train data frame
    x_train <- read.table("./train/x_train.txt")
    
    #Assign table headers of the x_train data frame using the rows of the second column of the features list created above.
    names(x_train) <- features_list[,2]
    
    #merge using column bind, all the columns of the train_ids data frame created above with the features data frame x_train created above.
    train_dataset <- cbind(train_ids,x_train)
    
    #View(train_dataset)
    
    
    #do the same thing for the files under the test directory and prefix files with tst to distinguish them from the files
    #in the train directory
    tst_subject_id <- read.table("./test/subject_test.txt")
    tst_activity_id <- read.table("./test/y_test.txt")
    tst_ids <- cbind(tst_subject_id,tst_activity_id)
    tst_ids <- cbind(tst_ids,named_activity)
    names(tst_ids) <- c("subject_id","activity_id","activity_label")
    tst_ids <- mutate(tst_ids, activity_label = ifelse(activity_id == 1, "WALKING",
                                                           ifelse(activity_id == 2, "WALKING_UPSTAIRS",
                                                                  ifelse(activity_id == 3, "WALKING_DOWNSTAIRS",
                                                                         ifelse(activity_id == 4, "SITTING",
                                                                                ifelse(activity_id == 5, "STANDING",
                                                                                       ifelse(activity_id == 6, "LAYING","")))))))
    
    x_test <- read.table("./test/X_test.txt")
    names(x_test) <- features_list[,2]
    test_dataset <- cbind(tst_ids,x_test)
    
    
    #
    #Merge both train and test data using row bind to produce one dataset and store it in a data frame called merged_dataset
    merged_dataset <- rbind(train_dataset,test_dataset)
    
    #Convert the features list to a datatable to be ablve to use certain queries on it.
    features_dt <- data.table(features_list)
    
    
    #extract the headers with the word std and mean from the features list and store them in a data frames std_headers and mean_headers respectively.
    mean_headers <- features_dt[V2 %like% "mean"]
    std_headers <- features_dt[V2 %like% "std"]
    
    #Combine both std and mean headers in a single dataframe called headers
    headers <- rbind(mean_headers,std_headers)
    
    #create a new headers list which will make up only the numerical value of the final data frame which excludes all the ID's values 
    # and store it in a right_headers_list.
    right_headers_list <- as.vector(headers[,V2])
    
    #creat a headers list made up of only the id columns information called left headers list.
    left_headers_list <- c("subject_id","activity_id","activity_label")
    
    #combine both as character vector called all_headers
    all_headers <- c(left_headers_list,right_headers_list)
    
    #extract part of the dataset based on the headers created in the previous step.
    partial_data <- merged_dataset[,all_headers]
    
    #Using dplyr tools apply group_by on the partial_data data frame to group by both subject_id 
    #and activity_id then using summarize_each apply the function mean to produce the average fore each column based
    #on that grouping.
    summary_by_subject_activity <- partial_data %>%
      group_by(subject_id,activity_id,activity_label) %>%
      summarize_each(funs(mean))
    
    #View the summary
    View(summary_by_subject_activity)
    
    #write it as a text file which will be uploaded and submitted for gradin as per the requirements of the project.
    summary_by_sbject_activity.txt <- write.table(summary_by_subject_activity,file="./summary_by_subject_activity.txt",row.name = FALSE)  
    
    
    
