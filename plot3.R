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
                datetime = as.POSIXct(paste(Date, Time, sep=" "), format = "%d/%m/%Y %H:%M:%S")
)
pData <- pData[complete.cases(pData),]

# Creating the output
# ======================
# initialize the device
png(file="plot3.png")
# initialize the plot
plot(pData$datetime, pData$Sub_metering_1,
     type="n",
     xlab="", 
     ylab="Energy sub metering"
     
)
# add data
points(pData$datetime, pData$Sub_metering_1, col="black", type="l")
points(pData$datetime, pData$Sub_metering_2, col="red", type="l")
points(pData$datetime, pData$Sub_metering_3, col="blue", type="l")
# set the legend
legend("topright", 
       lty = "solid",
       col = c("black", "red", "blue"), 
       legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3")
       )

# turn off the device
dev.off()


# Cleaning up
# ===========
# reset the working directory
setwd(orig_wd)
# remove data
rm(pData, new_wd, orig_wd)
