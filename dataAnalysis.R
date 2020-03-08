#!/bin/R

# GT 4801 Open Data with R Project
# Author: Asier Garcia Ruiz

# Package Installs
# install.packages("tidyverse")
# install.packages("skimr")
# install.packages("ggplot2")
# install.packages("astsa")

# Libraries needed
library(tidyverse)
library(skimr)
library(readr)
library(ggplot2)
library(astsa)

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

tibbleData <- as_tibble(data)

# Select interesting columns
interestData <- tibbleData[, c("descripcion_cliente",
                             "numero_factura",
                             "fecha_hora_factura",
                             "descripcion_producto_cliente",
                             "precio_base_producto",
                             "cantidad",
                             "numero_comensales")]

# Let's start one of out analyses
# We're going to look at the number of sales in total
# Since the data seems pretty heterogeneous we will not separate by client

salesByNum <- interestData[, c("numero_factura", 
                              "fecha_hora_factura")]
# Since there is more than one item per bill lets grab only the different ones
# We use the fact that they all should have the same establishment and purchase time
salesByNum <- distinct(salesByNum)
# Interesting fact, the number of rows got divided by 3
# Convert column into datetime objects
salesByNum$fecha_hora_factura <- as.Date(as.character(salesByNum$fecha_hora_factura,
                                                      format = "%d/%m/%Y"))
# The year parses wrong but it is all 2019 so we can just remove it
salesByNum$fecha_hora_factura <- format(salesByNum$fecha_hora_factura, format = "%Y/%m")
# Sort by date (date is in form DD/MM/YYYY)
salesByNum <- salesByNum[order(salesByNum$fecha_hora_factura),]
# See how many sales we got per day
salesPerDay <- table(salesByNum$fecha_hora_factura)
# Turn it into a Tibble for better managing
salesPerDay <- as_tibble(data.frame(salesPerDay))
colnames(salesPerDay) <- c("date", "number_of_sales")

# Now we have the tibble for the timeseries analysis
# Let's make some graphs
ggplot(salesPerDay, aes(x = date, y = number_of_sales)) + geom_point()
# Not too clear what is going on. try connecting the dots
ggplot(salesPerDay, aes(date, number_of_sales, group = 1)) + geom_line()
# Fun Fun Fun
       