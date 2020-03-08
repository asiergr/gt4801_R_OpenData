#!/bin/R

# GT 4801 Open Data with R Project
# Author: Asier Garcia Ruiz

# Package Installs
# install.package(tidyverse)
# install.package(skimr)
# install.package(ggplot2)

# Libraries needed
library(tidyverse)
library(skimr)
library(readr)
library(ggplot2)

# Import all the (clean) data from ../cleanData
# // TODO

## NEXT FEW STEPS ONLY HAVE TO BE DONE ONCE, THATS WHY THEY'RE COMMENTED OUT
# Access all the files in the directory
path = "~/gtech/gt4801R/data/"
fileNames <- dir(path, pattern=".csv")

# Read in the first file
joinedData <- read.csv(paste(path, fileNames[1], sep=""), header=TRUE, sep=";")

# All the files have the same variables
# Loop through all the files and join them
for (i in 2:length(fileNames)) {
  file <- read.csv(paste(path, fileNames[i], sep=""), header=TRUE, sep=";")
  joinedData <- rbind(file, joinedData)}

write.csv(joinedData, "./../cleanData/joinedData.csv", row.names=FALSE)
# Now we have a big (1GB!) Dataset with all the data. We will simply call this one from now on

## END OF ONE-TIME SEGMENT

## ANALYSIS

data <- read.csv("./../cleanData/joinedData.csv", header=TRUE)

# Let's look at some summaries
summary(data)
skim(data)
unique(data)

# First column is indexing so we can delete
cleanData$X <- NULL
# Second column is always the same so we can delete too
cleanData$X0 <- NULL

# Select interesting columns
timeAnalysis <- data[, c()]

