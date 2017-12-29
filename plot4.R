# Getting the data
# =================
# create a temporary folder and move the working directory
orig_wd <- getwd()
new_wd <- "workfolder"
new_wd <- paste(orig_wd,new_wd, sep = "/")
if(!dir.exists(new_wd))
    dir.create(new_wd)
setwd(new_wd)
if(!file.exists("household_power_consumption.txt")) {
    # download the data file and unzip it
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","dataset.zip")
    unzip("dataset.zip")    # dir: "./"
}

# Reading data into R
# ======================
library(dplyr)
pData <- read.csv("household_power_consumption.txt", header = T, sep = ";") %>% 
    mutate(dateconv = as.Date(Date,format="%d/%m/%Y")) %>%
    filter(dateconv >= "2007-02-01" & dateconv <= "2007-02-02")
pData <- mutate(pData,
                Sub_metering_1 = as.numeric(levels(Sub_metering_1))[Sub_metering_1],
                Sub_metering_2 = as.numeric(levels(Sub_metering_2))[Sub_metering_2],
                Voltage = as.numeric(levels(Voltage))[Voltage],
                Global_reactive_power = as.numeric(levels(Global_reactive_power))[Global_reactive_power],
                Global_active_power = as.numeric(levels(Global_active_power))[Global_active_power],
                datetime = as.POSIXct(paste(Date, Time, sep=" "), format = "%d/%m/%Y %H:%M:%S")
)
pData <- pData[complete.cases(pData),]

# Creating the output
# ======================
# change locale temporary to English
loc <- Sys.getlocale("LC_TIME")
Sys.setlocale("LC_TIME","C")
# initialize the device
png(file="plot4.png")
# set the rows, columns and the placing order
par(mfrow=c(2,2))
# plot(1,1): plot of active power
plot(pData$datetime, pData$Global_active_power,
     type="l",
     xlab="", 
     ylab="Global Active Power (kilowatts)"
     
)
# plot(1,2): plot of voltage
plot(pData$datetime, pData$Voltage,
     type="l",
     xlab="datetime", 
     ylab="Voltage"
     
)
# plot(2,1): plot of sub meterings
plot(pData$datetime, pData$Sub_metering_1,
     type="n",
     xlab="", 
     ylab="Energy sub metering"
     
)
points(pData$datetime, pData$Sub_metering_1, col="black", type="l")
points(pData$datetime, pData$Sub_metering_2, col="red", type="l")
points(pData$datetime, pData$Sub_metering_3, col="blue", type="l")
legend("topright", 
       lty = "solid",
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       bty = "n"
)
# plot(2,2): plot of reactive power
plot(pData$datetime, pData$Global_reactive_power,
     type="l",
     xlab="datetime",
     ylab = "Global_reactive_power"
)
# turn off the device
dev.off()


# Cleaning up
# ===========
# reset locale
Sys.setlocale("LC_TIME",loc)
# reset the working directory
setwd(orig_wd)
# remove data
rm(pData, new_wd, orig_wd,loc)
