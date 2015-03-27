source("read_data.R")
library(dpcR)

#get counts in non-empty wells 
dat <- EGFR[EGFR[, "Group.name"] != "Empty", c("Group.name",
                "Number.of.positives.in.data.filter.1", 
                "Number.of.positives.in.data.filter.2", 
                "Number.of.positives.in.data.filter.3")]

colnames(dat) <- c("group", "f1", "f2", "f3")


lambdas <- t(apply(dat[, -1]/496, 1, dpcR:::fl))

#cumulative probability of having partition with 0 or 1 template molecules
cum_prob <- t(apply(lambdas, 1, function(column)
  sapply(column, function(lambda) sum(dpois(c(0, 1), lambda = lambda)))))

#wells that have on average less than one partition with more than one template molecule
low_lambda_ind <- which(cum_prob > 1 - 1/496, , arr.ind = TRUE)
#partitions table
#2nd column - observed partitions with 0 template
#3rd column - observed partitions with 1 template
#4rd column - expected partitions with 0 template
#5th column - expected partitions with 1 template
partab <- cbind(lambdas[low_lambda_ind],
                496 - dat[, -1][low_lambda_ind], 
                dat[, -1][low_lambda_ind],
                round(ppois(0, lambdas[low_lambda_ind]) * 496, 0),
                round((ppois(1, lambdas[low_lambda_ind]) - 
                         ppois(0, lambdas[low_lambda_ind])) * 496, 0))
colnames(partab) <- c("lambda", "O0", "O1", "E0", "E1")

apply(partab[, -1], 1, function(row) chisq.test(x = row[1L:2], y = row[3L:4],
                                                simulate.p.value = TRUE)[["p.value"]])
