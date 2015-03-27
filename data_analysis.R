source("read_data.R")
library(dpcR)

dat <- EGFR[, c("Group.name",
                "Number.of.positives.in.data.filter.1", 
                "Number.of.positives.in.data.filter.2", 
                "Number.of.positives.in.data.filter.3")]

colnames(dat) <- c("group", "f1", "f2", "f3")

lambdas <- t(apply(dat[, -1]/496, 1, dpcR:::fl))

#cumulative probability of having partition with 0 or 1 template molecules
cum_prob <- t(apply(lambdas, 1, function(column)
  sapply(column, function(lambda) sum(dpois(c(0, 1), lambda = lambda)))))

#cumulative probability of non-empty wells
cum_prob[dat[, "group"] != "Empty", ]
