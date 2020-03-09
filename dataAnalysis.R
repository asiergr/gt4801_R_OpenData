#!/bin/R

# GT 4801 Open Data with R Project
# Author: Asier Garcia Ruiz

# Package Installs
# install.packages("tidyverse")
# install.packages("skimr")
# install.packages("ggplot2")
# install.packages("astsa")
# install.packages("lubridate")
# install.packages("plyr")
# install.packages("forecast")

# Libraries needed
library(tidyverse)
library(skimr)
library(readr)
library(ggplot2)
library(astsa)
library(lubridate)
library(plyr)

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
salesByNum$fecha_hora_factura <- dmy_hms(as.character(salesByNum$fecha_hora_factura))
# Sort by date (date is in form DD/MM/YYYY)
salesByNum <- arrange(salesByNum, fecha_hora_factura)
salesByNum$fecha_hora_factura <- format(salesByNum$fecha_hora_factura,
                                        format = "%Y/%m/%d")
# See how many sales we got per day
salesPerDay <- table(salesByNum$fecha_hora_factura)
# Turn it into a Tibble for better managing
salesPerDay <- data.frame(salesPerDay)
colnames(salesPerDay) <- c("date", "number_of_sales")
# When turning into tibble dates are not Date object anymore
salesPerDay$date <- ymd(as.character(salesPerDay$date))

# Now we have the tibble for the timeseries analysis
# Let's make some graphs
ggplot(salesPerDay, aes(x = date, y = number_of_sales)) + geom_point()
# Not too clear what is going on. try connecting the dots
ggplot(salesPerDay, aes(date, number_of_sales, group = 1)) + geom_line() + scale_x_date(date_labels = "%Y/%m/%d")
# We have some very weird shapes. Let's cut some of the data
# By inspection the biggest jump occurs on 2019-07-21 which is row 62
# modelData <- salesPerDay[63:223,]
ggplot(modelData, aes(date, number_of_sales, group = 1)) + geom_line() + scale_x_date(date_labels = "%Y/%m/%d")

# Now we do the time series analysis
# Turn it into timeseries object
ts1 <- ts(modelData$date, frequency=6)
components <- decompose(ts1)
plot(components)

train_series=ts1[1:70]
test_series=ts1[71:141]

fit_basic1<- auto.arima(train_series)
forecast_1<-forecast(fit_basic1,xreg = testREG_TS)
plot.forecast(forecast_1)
