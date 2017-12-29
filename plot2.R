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
        Global_active_power_n = as.numeric(levels(Global_active_power))[Global_active_power],
        datetime = as.POSIXct(paste(Date, Time, sep=" "), format = "%d/%m/%Y %H:%M:%S")
    )
pData <- pData[complete.cases(pData),]

# Creating the output
# ======================
# initialize the device
png(file="plot2.png")
# create the plot
plot(pData$datetime, pData$Global_active_power_n,
     type="l",
     xlab="", 
     ylab="Global Active Power (kilowatts)"
     
)
# turn off the device
dev.off()


# Cleaning up
# ===========
# reset the working directory
setwd(orig_wd)
# remove data
rm(pData, new_wd, orig_wd)
