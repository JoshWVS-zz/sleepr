setwd("E:/Users/Josh/Documents/R/sleep_analysis")
library("ggplot2", "plyr", "reshape2")

sleep <- read.csv(file="sleep_data-Jul24.csv")

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
summer.end <- as.Date("2013-09-01")
sleep$Term[which(sleep$Date <= summer.end)] <- "Summer"
# First term lasted until Dec 14th, 2013 (started Sept 2nd, 2013) [but Frosh week was 2-7th!!]
term1.end <- as.Date("2013-12-14")
sleep$Term[which(sleep$Date <= term1.end & sleep$Date >= summer.end)] <- "Term1"
# Second term lasted until April 15th, 2014 (started Jan 6th, 2014)
term2.start <- as.Date("2014-01-06")
term2.end <- as.Date("2014-04-15") 
sleep$Term[which(sleep$Date <= term2.end & sleep$Date >= term2.start)] <- "Term2"

# work started April 28th, 2014
sleep$Term[which(sleep$Date >= as.Date("2014-04-28"))] <- "Work"

# all unnamed sections are break
sleep$Term[sleep$Term == "" & sleep$Date < term2.start] <- "XmasBreak"
sleep$Term[sleep$Term == ""] <- "SpringBreak"

sleep$Term <- factor(sleep$Term, c("Summer", "Term1", "XmasBreak", "Term2", "SpringBreak", "Work"))

ggplot(sleep, aes(x=Date, y=Hours, colour=Term)) + geom_point() + geom_smooth()

# average hours per term
avg.hours <- tapply(sleep$Hours, list(sleep$Day, sleep$Term), mean)
avg.hours.melt <- melt(avg.hours, value.name="Hours", varnames=c("Day", "Term"))
avg.hours.melt <- data.frame(avg.hours.melt)

ggplot(avg.hours.melt, aes(x=Day, y=Hours, fill=Day)) + geom_bar(stat="identity") +
  facet_wrap(~Term) + scale_fill_brewer(palette="Set3")
