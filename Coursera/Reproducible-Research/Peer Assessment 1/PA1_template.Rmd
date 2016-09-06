---
title: "Reproducible Research: Peer Assessment 1"
output: html_document
keep_md: true
author: "Benny96"
---

This markdown template will contain the answer to the PA_1 exercise.

## Loading and preprocessing the data

0- Load the required packages for the analysis (previous installation of them is expected):

```{r libraries,echo=TRUE}
library(data.table); library(xtable); library(timeDate)
```

1- Read the CSV file downloaded via the Assignment Statement:

```{r zipextraction,echo=TRUE}
file <- "activity.zip"
unzip(file, exdir=".")
data <- read.csv("./activity.csv", header = TRUE)
```

2- Check the first 6 rows of the data:

```{r check,echo=TRUE}
head(data)
```

## What is mean total number of steps taken per day?

0- Obtain the total number of steps taken per day. ```aggregate()``` will create subsets of the data, considering the amount of steps taken
per day.

```{r subsetdate,echo=TRUE}
stepsDay <- aggregate(steps~date,data,sum)
head(stepsDay)
```

1- Make a histogram of the total number of steps taken each day.

```{r histogram,echo=TRUE}
hist(stepsDay$steps, col = "orange", xlab = "Steps", main = "Total number of Steps taken each Day")
```

2- Calculate and report the **mean** and **median** total number of steps taken per day

```{r avgmediancalc0, echo=TRUE}
mean0 <- mean(stepsDay$steps)
mean0
median0 <- median(stepsDay$steps)
median0
```

## What is the average daily activity pattern?

0- Subset the total number of steps by 5-min intervals to obtain the average from it.

```{r subsetinterval,echo=TRUE}
stepsInterval <- aggregate(steps~interval,data,mean)
head(stepsInterval)
```

1- Make a time series plot (i.e. ```type = "l"```) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)

```{r timeseries,echo=TRUE}
with(stepsInterval, plot(interval, steps , type="l", main="Average number of steps taken in 5-min interval" , col = "green")) 
```

2- Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

```{r max,echo=TRUE}
max <- max(stepsInterval$steps)
max
```

## Imputing missing values

1- Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)

```{r sumNAs, echo=TRUE}
colSums(is.na(data))
```

2- Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.

2.1. Create a new column "avgSteps" which contains the average steps in each interval.

```{r columncreation, echo=TRUE}
data$avgSteps <- stepsInterval$steps
head(data)
```

2.2. Fill in the missing data.

```{r fillingdata, echo=TRUE}
data$steps[is.na(data$steps)] <- data$avgSteps
head(data)
```

3.1. Create a new dataset that is equal to the original dataset but with the missing data filled in.

```{r newdataset, echo=TRUE}
newdata <- data
head(newdata)
```

3.2. Subset the new modified data set to obtain the total number of steps per day.

```{r subsetmodified,echo=TRUE}
moddata <- aggregate(steps~date, newdata, sum)
head(moddata)
```

4.1. Make a histogram of the total number of steps taken each day.

```{r histo2, echo=TRUE}
hist(moddata$steps, col = "blue", xlab = "Steps"
     , main = "Total number of Steps taken each Day (missing data filled in)")
```

4.2. Calculate and report the **mean** and **median** total number of steps taken per day.

```{r avgmediancalc1, echo=TRUE}
mean1 <- mean(moddata$steps)
mean1
median1 <- median(moddata$steps)
median1
```

4.3. Calculate the differences of the **mean** and **median** between the first and second part.

```{r difference, echo=TRUE}
mean1 - mean0
median1 - median0
```

## Are there differences in activity patterns between weekdays and weekends?

1- Create a new factor variable in the dataset with two levels -- "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

*Note*: Here I decided to use the ```isWeekday()``` function from the timeDate package.

1.1. Add a new column, adding a flag checking whether the date is a weekday or weekend.

```{r columnaddition, echo=TRUE}
newdata$Weekday <- isWeekday(newdata$date)
head(newdata)
```

1.2. Make the respective calculations for each level.

Weekday:

```{r weekdaycalc, echo = TRUE}
weekday <- subset(newdata, newdata$Weekday == "TRUE")
weekdayMean <- aggregate(steps ~ interval, data = weekday, mean)
head(weekdayMean)
```

Weekend:

```{r weekendcalc, echo = TRUE}
weekend <- subset(newdata, newdata$Weekday == "FALSE")
weekendMean <- aggregate(steps ~ interval, data = weekend, mean)
head(weekendMean)
```

2- Make a panel plot containing a time series plot (i.e. ```type = "l"```) of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). 

```{r plotting, echo=TRUE}
layout(matrix(c(1,1,2,2), 2, 2, byrow = TRUE))
plot(weekdayMean$interval, weekdayMean$steps, xlab = "interval", ylab = "Number of steps", main ="Weekday", col ="black", type="l") 

plot(weekendMean$interval, weekendMean$steps, xlab = "interval", ylab = "Number of steps", main ="Weekend", col ="blue", type="l")
```

**Conclusion:**

So, as we can see, the most remarkable difference between Weekdays and Weekends appear in the afternoon's intervals. At that time, the amount of steps done is slightly higher (watch out the y-axis units!) than the measures obtained in weekdays. 