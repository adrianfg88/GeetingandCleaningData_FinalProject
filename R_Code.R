#Deploy needed Packages 
install.packages("dplyr") 
library(dplyr)
install.packages("tidyverse")
library(tidyverse)
install.packages("ellipsis")
library(ellipsis)

Test_X<-read.table(file.choose()) #loads test measurements
Test_Y<-read.table(file.choose()) #leads activity for tests
Test_Subject<-read.table(file.choose()) #loads people who performed the acitivity
Train_X<-read.table(file.choose()) #loads he train measurements
Train_Y<-read.table(file.choose()) #leads the activity for train
Train_Subject<-read.table(file.choose()) #loads the people which participated in the train measurements
Titles<-read.table(file.choose()) #loads the names for the data frame

Test_DataFrame<-Test_X #Test dataframe in which activity, person and measurements will be merged
Test_DataFrame <- cbind(Test_Y,Test_Subject, Test_DataFrame) #binds the activity, person and measurements

Train_DataFrame<-Train_X #Train dataframe in which activity, person and measurements will be merged
Train_DataFrame <- cbind(Train_Y,Train_Subject, Train_DataFrame) #binds the activity, person and measurements

SuperSet<- rbind(Train_DataFrame,Test_DataFrame) #creates super set data frame for merging both test and train input
colnames(SuperSet)<-c("Actividad","Persona",  sub("^[t]","",Titles$V2)) #Assigns the names to the columns and cleans them be getting rid of the t at the beginning
SuperSet$Actividad<-str_replace_all(SuperSet$Actividad, c("1"="Walking","2"="Walking-Upstairs","3"="Walking-Downstairs","4"="Sitting","5"="Standng","6"="Laying")) # Replaces all nummric activities with a string
SuperSet<-select(SuperSet , contains(c("Actividad","Persona", "mean()" ,"std()" ))) #Chooses only the columns which have mean or std information along the person and the activity
SuperSet_Summary<-SuperSet %>% group_by(Actividad,Persona) %>% summarise_all(mean) #Creates the summary driven by Activity followed by persona and then averages all variables

write.table(SuperSet_Summary,"./FinalAverage_Summaries.txt", row.names = FALSE) #creates and output text file which can be used as input for further analysis

