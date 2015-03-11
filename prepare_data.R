library("ggplot2", "plyr", "reshape2")

sleep <- read.csv(file="data/sleep_data-Mar10-2015.csv")

# fix sleep/wake times
sleep$Sleep.Time <- as.character(sleep$Sleep.Time)
sleep$Wake.Time <- as.character(sleep$Wake.Time)

# remove comments
sleep <- sleep[ , -5]

# fix dates
sleep$Date <- as.character(sleep$Date)
dates <- strsplit(sleep$Date, "/")

for (i in 1:length(dates)) {
  dates[[i]][3] <- paste("20", dates[[i]][3], sep="")
  sleep$Date[i] <- paste(dates[[i]][3], dates[[i]][1], dates[[i]][2], sep="-")
}
sleep$Date <- as.Date(sleep$Date, format="%Y-%m-%d")

# add weekdays
sleep$Day <- weekdays(sleep$Date - 1)
sleep$Day <- factor(sleep$Day, 
                    levels=c("Monday", "Tuesday", "Wednesday", "Thursday", 
                             "Friday", "Saturday", "Sunday"))

# add descriptions for each term
sleep$Term <- rep("", times=dim(sleep)[1])
# Summer lasted until Sept. 1st, 2013
summer2013.end <- as.Date("2013-09-01")
sleep$Term[which(sleep$Date <= summer2013.end)] <- "Summer 2013"
# First term lasted until Dec 14th, 2013 (started Sept 2nd, 2013)
# [but Frosh week was 2-7th!!]
term1.end <- as.Date("2013-12-14")
sleep$Term[which(sleep$Date <= term1.end & sleep$Date >= summer.end)] <- "1A"
# Second term lasted until April 15th, 2014 (started Jan 6th, 2014)
term2.start <- as.Date("2014-01-06")
term2.end <- as.Date("2014-04-15") 
sleep$Term[which(sleep$Date <= term2.end & sleep$Date >= term2.start)] <- "1B"

# work term 1: April 28th, 2014 - August 22nd, 2014
work1.start <- as.Date("2014-04-28")
work1.end <- as.Date("2014-08-22")
sleep$Term[which(sleep$Date >= work1.start & sleep$Date <= work1.end)] <- "Work Term 1"

# summer break 2014: August 23rd - Sept. 7th 2014
summer2014.start <- work1.end + 1
summer2014.end <- as.Date("2018-09-07")
sleep$Term[which(sleep$Date >= summer2014.start & sleep$Date <= summer2014.end)] <- "Summer 2014"

# all unnamed sections are break
sleep$Term[sleep$Term == "" & sleep$Date < term2.start] <- "Winter Break"
sleep$Term[sleep$Term == "" & sleep$Date < work1.start] <- "Spring Break"

sleep$Term <- factor(sleep$Term, c("Summer 2013", "1A", "Winter Break", "1B", 
                                   "Spring Break", "Work Term 1", "Summer 2014"))


names(sleep) <- c("date", "sleep_time", "wake_time", "hours", "day", "term")
save(sleep, file = "sleep.data.RData")