library(ggplot2)
library(data.table)
data <- transpose(read.csv("skew-random.csv",header=F))[1:100,]

qplot(data$V2)
