library(anesrake)
library(weights)
library(readr)
setwd("~/Box Sync/CCSSBP Project")

# STEP 1
# Read in the weight sheets and create the target list
sgeo1_w <- read.csv("data/sgeo1.csv")
sgeo1 <- sgeo1_w[,3]
names(sgeo1) <- sgeo1_w[,1]

stype_w <- read.csv("data/stype.csv")
stype <- stype_w[,3]
names(stype) <- stype_w[,1]

gender_w <- read.csv("data/gender.csv")
gender <- gender_w$genderr
names(gender) <- gender_w$gender

syear_w <- read.csv("data/syear.csv")
syear <- syear_w[,3]
names(syear) <- syear_w[,1]

target <- list(sgeo1, stype, gender, syear)
names(target) <- c("sgeo1", "stype", "gender", "syear")

# STEP 2
# Match the data type with the required type
gp_describe <- as.data.frame(gp_describe)

gp_describe$sgeo1 <- as.factor(gp_describe$sgeo1)
gp_describe$stype <- as.factor(gp_describe$stype)
gp_describe$gender <- as.factor(gp_describe$gender)
gp_describe$syear <- as.factor(gp_describe$syear)

names(target$sgeo1) <- levels(gp_describe$sgeo1)
names(target$stype) <- levels(gp_describe$stype)
names(target$gender) <- levels(gp_describe$gender)
names(target$syear) <- levels(gp_describe$syear)

# Raking
raking <- anesrake(target,
                   gp_describe,
                   gp_describe$index,
                   cap = 100000,                      # Maximum allowed weight per iteration
                   choosemethod = "total",       # How are parameters compared for selection?
                   type = "pctlim",              # What selection criterion is used?
                   pctlim = 1e-5               # Threshold for selection
                   )


