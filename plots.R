# load libraries
library(dplyr)
library(lubridate)

dataPath <- "./specdata/household_power_consumption_data/household_power_consumption.txt"

# import data
data <- read.table(dataPath, header = TRUE, sep=";", na.strings = "?")
# subset data by parsing Dates and selecting only those with dates 2007-02-01 and 2007-02-02
subset_data <- data %>%
  mutate(Date = dmy(Date)) %>%
  filter(Date == "2007-02-01" | Date == "2007-02-02")

# plot 1
png("plot1.png")
hist(subset_data$Global_active_power, 
     main= "Global Active Power", 
     xlab="Global Active Power (kilowatts)",
     col = "red")
dev.off()

### create a datetime variable
datetime <- ymd_hms(paste0(subset_data$Date, subset_data$Time, sep=" "))

# plot 2
png("plot2.png")
plot(datetime, 
     subset_data$Global_active_power, 
     type = "l", 
     xlab = "", 
     ylab = "Global Active Power (kilowatts)")
dev.off()

# plot 3
png("plot3.png")
plot(datetime, 
     subset_data$Sub_metering_1, 
     type = "l", 
     xlab = "", 
     ylab = "Energy sub metering")
lines(datetime, subset_data$Sub_metering_2, col = "red")
lines(datetime, subset_data$Sub_metering_3, col = "blue")
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1, 
       lwd = 1)
dev.off()

# plot 4
png("plot4.png")
### create 2x2 matrix for plot
### | a | b |
### | c | d |
par(mfrow = c(2,2))
# plot a
plot(datetime, 
     subset_data$Global_active_power, 
     type = "l", 
     xlab = "", 
     ylab = "Global Active Power (kilowatts)")

# plot b
plot(datetime, subset_data$Voltage, type = "l", xlab = "datetime", ylab = "Voltage")

# plot c
plot(datetime, 
     subset_data$Sub_metering_1, 
     type = "l", 
     xlab = "", 
     ylab = "Energy sub metering")
lines(datetime, subset_data$Sub_metering_2, col = "red")
lines(datetime, subset_data$Sub_metering_3, col = "blue")
legend("topright", 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = c("black", "red", "blue"),
       lty = 1, 
       lwd = 1)

# plot d
plot(datetime, 
     subset_data$Global_reactive_power, 
     type = "l", 
     xlab = "datetime", 
     ylab = "Global Reactive Power")
dev.off()