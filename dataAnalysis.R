#!/bin/R

# GT 4801 Open Data with R Project
# Author: Asier Garcia Ruiz

# Package Installs
# install.package(tidyverse)

# Libraries needed
library(readr)

# Import all the (clean) data from ../cleanData
# // TODO

# Access all the files in the directory
path = "~/gtech/gt4801R/cleanData/"
outFile <- ""
fileNames <- dir(path, pattern=".csv")

# Read in the first file
joinedData <- read_csv(paste(path, fileNames[1], sep=""))

# All the files have the same variables
# We save the header row in a variable (grabbed from 1st dataset)
headerRow <- head(joinedData, 1)

# Loop through all the files and join them
for (i in 2:length(fileNames)) {
  file <- read_csv(paste(path, fileNames[i], sep=""))
  joinedData <- rbind(tail(file, -1), joinedData)
}
