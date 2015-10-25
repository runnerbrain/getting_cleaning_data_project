    library(dplyr)
    library(data.table)
    
    #read all the features from the features.txt file. The list of features will be the column headers of the x_train
    # and x_test files.
    features_list <- read.table("./features.txt")
    activity_list <- read.table("./activity_labels.txt")
    names(activity_list) <- c("activity_id","activity_label")
    
    
    #Read in all the id's of the subject_train.txt file.
    tr_subject_id <- read.table("./train/subject_train.txt")
    #Read in all the id's of the activity file.
    tr_activity_id <- read.table("./train/y_train.txt")
    
    #column bind the subject id's and the activity id's in a table which will when merged shows a cerain subject doing
    # a certain activity
    train_ids <- cbind(tr_subject_id,tr_activity_id)
    named_activity <- c("")
    train_ids <- cbind(train_ids,named_activity)
    
    
    #Give names to the id's
    names(train_ids) <- c("subject_id","activity_id","activity_label")
    train_ids <- mutate(train_ids, activity_label = ifelse(activity_id == 1, "WALKING",
                                                           ifelse(activity_id == 2, "WALKING_UPSTAIRS",
                                                                  ifelse(activity_id == 3, "WALKING_DOWNSTAIRS",
                                                                         ifelse(activity_id == 4, "SITTING",
                                                                                ifelse(activity_id == 5, "STANDING",
                                                                                       ifelse(activity_id == 6, "LAYING","")))))))
    
    #read in the x_train.txt file into the x_train data frame
    x_train <- read.table("./train/x_train.txt")
    
    #set the names of the x_train data frame created above to the rows of the features list data frame created in step ??? above
    names(x_train) <- features_list[,2]
    
    #merge using column bind the id's of the subject and the correpsonding id's with the features data frame.
    train_dataset <- cbind(train_ids,x_train)
    #View(train_dataset)
    
    
    #do the same thing for the test files.
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
    
    #row bind both train data frame and test data frames.
    merged_dataset <- rbind(train_dataset,test_dataset)
    
    #extract the headers with the word std and mean from the features list and store them into a vector
    features_dt <- data.table(features_list)
    
    mean_headers <- features_dt[V2 %like% "mean"]
    std_headers <- features_dt[V2 %like% "std"]
    
    headers <- rbind(mean_headers,std_headers)
    right_headers_list <- as.vector(headers[,V2])
    left_headers_list <- c("subject_id","activity_id","activity_label")
    all_headers <- c(left_headers_list,right_headers_list)
    partial_data <- merged_dataset[,all_headers]
    partial_data_r <- merged_dataset[,right_headers_list]
    summary_by_subject_activity <- partial_data %>%
      group_by(subject_id,activity_id,activity_label) %>%
      summarize_each(funs(mean))
    
    View(summary_by_subject_activity)
    summary_by_sbject_activity.txt <- write.table(summary_by_subject_activity,file="./summary_by_subject_activity.txt",row.name = FALSE)  
    
    
    
