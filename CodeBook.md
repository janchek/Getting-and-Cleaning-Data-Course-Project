Input

  (*included in HAR USD dataset)

features.txt: There is 561 features calculated from raw signal data. Reduced version contain 79 features related to mean and std.

activity_labels.txt: Decription of activity codes.

train/X_train.txt, test/X_test.txt: Each row contains 561 calculated features per observation. Values are normalized and bounded within [-1,1].

train/y_train.txt, test/y_test.txt: Each row contains code that represent activity related to observation. Values range from 1 to 6 (description in activity_labels.txt)

train/subject_train.txt, test/subject_test.txt: Each row contains person id related to observation (there was 30 different persons). Id is only information about person.

Transformations:

Step 1. Loading and binding variables from train and test set into one dataset that contain all variables about all observation. In source data, observations are separated into two datasets and separate files, activities ('train/y_train.txt', 'test/y_test.txt'), persons ('train/subject_train.txt', 'test/subject_test.txt') and calculated features ('train/X_train.txt', 'test/X_test.txt').

Step 2. Extracting mean and std related measurements from original dataset (in original dataset there is 561 features, in reduced version 79).

Step 3. Changing numeric codes for activities with their descriptive names (see activity_labels.txt)

Step 4. Altering names of feature variables into more readable format. Non character are removed and names are lowercased.

Step 5. Generating output summary dataset which contain average value for each combination of activity and subject.

Output:

uci_har_dataset.txt: Each row contain average values of reduced features set (79 variables) for each combination of activity and person variables. Original values are normalized and bounded within [-1,1].

NOTE: Dataset is represented in wide shape. Each of 79 calculated features is considered separate variables representing one atomic observation (with fixed variables subject and activity).
