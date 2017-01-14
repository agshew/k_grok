#!/usr/bin/env Rscript

argv <- commandArgs(TRUE)

usage <- function() {
	print("Usage: plot* <data>+")
	quit()
}

if (length(argv) < 1) {
	usage()
}

argv <- commandArgs(TRUE)
n <- length(argv)

columns <- c("Count", "Time")

if (n >= 1) {
  d1 <- read.table(argv[1], header=F, col.names=columns)
  d1$type = "before"
  d1$op = "silly"
  xmin <- min(d1$Time)
  xmax <- max(d1$Time)
  x50th <- round(quantile(d1$Time, c(0.50)), digits=3)
  x90th <- round(quantile(d1$Time, c(0.90)), digits=3)
  x99th <- round(quantile(d1$Time, c(0.99)), digits=3)
  x999th <- round(quantile(d1$Time, c(0.999)), digits=3)
  d <- d1
  c1 <- d1
}

cat(paste("experiment", "xmin", "x50th", "x90th", "x99th", "x999th", "xmax", sep='\t'), '\n')
cat(paste("before    ", xmin, x50th, x90th, x99th, x999th, xmax, sep='\t'), '\n')

if (n >= 2) {
  d2 <- read.table(argv[2], header=F, col.names=columns)
  d2$type = "after"
  d2$op = "silly"
  xmin <- min(xmin, d2$Time)
  xmax <- max(xmax, d2$Time)
  x50th <- round(quantile(d2$Time, c(0.50)), digits=3)
  x90th <- round(quantile(d2$Time, c(0.90)), digits=3)
  x99th <- round(quantile(d2$Time, c(0.99)), digits=3)
  x999th <- round(max(x999th, quantile(d2$Time, c(0.999)), na.rm=TRUE), digits=3)
  d <- rbind(d1, d2)
  c2 <- d2
}

cat(paste("after     ", xmin, x50th, x90th, x99th, x999th, xmax, sep='\t'), '\n')

library(ggplot2)

png(file="silly-cdf.png", height=800, width=800, pointsize=12)

xlabel <- expression(paste("Log of Latency (jiffies)"))
p <- ggplot(d, aes(Time, colour=type))
p + stat_ecdf(size=2) +
    ylab("Empirical CDF")
    #scale_x_log10(xlabel, limits=c(xmin, x999th))

dev.off()

png(file="silly-pdf.png", height=800, width=800, pointsize=12)

xlabel <- expression(paste("Log of Op Latency (jiffies)"))
p <- ggplot(d, aes(Time, fill=factor(type)))
p + stat_density(size=2) +
    scale_fill_discrete(name = "Operation Type") +
    ylab("Empirical Density")
    #scale_x_log10(xlabel, limits=c(xmin, x999th))

dev.off()
