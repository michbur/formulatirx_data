source("read_data.R")
library(dpcR)

dat <- EGFR[, c("Group.name",
        "Number.of.positives.in.data.filter.1", 
        "Number.of.positives.in.data.filter.2", 
        "Number.of.positives.in.data.filter.3")]

colnames(dat) <- c("group", "f1", "f2", "f3")
