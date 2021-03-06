source("read_data.R")
library(dpcR)

#get counts in non-empty wells 
dat <- EGFR[, c("Well.row", "Well.column", "Group.name",
                "Number.of.positives.in.data.filter.1", 
                "Number.of.positives.in.data.filter.2", 
                "Number.of.positives.in.data.filter.3")]

plate_mat <- matrix(0, nrow = 8, ncol = 12)
inds <- as.matrix(dat[, c("Well.row", "Well.column")]) + 1
colnames(inds) <- c("row", "column")
plate_mat[inds] <- dat[, "Number.of.positives.in.data.filter.3"]

formul <- create_dpcr(do.call(c, lapply(1L:ncol(plate_mat), function(i) 
  plate_mat[, i])), length(plate_mat), type = "nm", adpcr = TRUE)

plot_panel(formul, 8, 12)

