#!/bin/R

# GT 4801 Open Data with R Project
# Author: Asier Garcia Ruiz

# Package Installs
# install.package(tidyverse)
# install.package(skimr)
# install.package(ggplot2)

# Libraries needed
library(skimr)
library(readr)
library(ggplot2)

# Import all the (clean) data from ../cleanData
# // TODO

## NEXT FEW STEPS ONLY HAVE TO BE DONE ONCE, THATS WHY THEY'RE COMMENTED OUT
# Access all the files in the directory
path = "~/gtech/gt4801R/cleanData/"
fileNames <- dir(path, pattern=".csv")

# Read in the first file
joinedData <- read.csv(paste(path, fileNames[1], sep=""))

# All the files have the same variables
# We save the header row in a variable (grabbed from 1st dataset)
headerRow <- head(joinedData, 1)
# Chop off header row of the dataset
joinedData <- tail(joinedData, -1)

# Loop through all the files and join them
for (i in 2:length(fileNames)) {
  file <- read.csv(paste(path, fileNames[i], sep=""))
  joinedData <- rbind(tail(file, -1), joinedData)}

joinedData <- rbind(headerRow, joinedData)
write.csv(joinedData, "./../cleanData/joinedData.csv", row.names=FALSE)
# Now we have a big (1GB!) Dataset with all the data. We will simply call this one from now on

## END OF ONE-TIME SEGMENT

## ANALYSIS

data <- read.csv("./../cleanData/joinedData.csv", header=TRUE)

summary(data)
