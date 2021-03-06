#loading necessary libraries
library(dplyr)
library(data.table)
library(lubridate)

#Saving the url to a variable, it is a zipped file
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
filename <- "getdata_dataset.zip"


#download zip file, down load mode binary, only if it does not already exist
if(!file.exists(filename)){
  download.file(fileURL,filename,mode='wb', method='auto')}
##
if (!file.exists(filename)){
  download.file(fileURL, filename, method="curl")
}  
if (!file.exists("household_power_consumption.txt")) { 
  unzip(filename) 
}

df <- read.table('./household_power_consumption.txt', sep = ";", header=TRUE)
memory <- 2075260*9*8 #a numeric value, double precision floating point, is stored in 8 bytes of ram
df$Date <- as.character(df$Date)
df$Time <- as.character(df$Time)
df2 <- mutate(df, DateTime = paste(df$Date,df$Time, sep=' '))

df2$Date <- as.Date(df2$Date, "%d/%m/%Y")
df3<-with(df2, df2[(Date >= "2007-02-01" & Date <= "2007-02-02"),])


df3$Global_active_power <- as.numeric(df3$Global_active_power)
df4 <- mutate(df3, GlobalActivePower = Global_active_power/1000)
df5 <- mutate(df4, DateTime = dmy_hms(DateTime))
with(df5, plot(DateTime, Global_active_power, type='l', ylab='Global Active Power (kilowatts)'))


dev.copy(png,"plot2.png", width=480, height=480)
dev.off