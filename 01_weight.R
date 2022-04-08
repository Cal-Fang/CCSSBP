# Set up the enivronment
library(anesrake)
library(weights)
library(readr)
setwd("~/Box Sync/CCSSBP Project")

# cite: https://www.r-bloggers.com/2018/12/survey-raking-an-illustration/

# STEP 1
# Read in the weight sheets and create the target list
rm(list = ls())
sgeo1_w <- read.csv("data/sgeo1.csv")
sgeo1 <- sgeo1_w[,3]
names(sgeo1) <- sgeo1_w[,1]

stype_w <- read.csv("data/stype.csv")
stype <- stype_w[,3]
names(stype) <- stype_w[,1]

sex_w <- read.csv("data/sex.csv")
sex <- sex_w$sexr
names(sex) <- sex_w$sex

syear_w <- read.csv("data/syear.csv")
syear <- syear_w[,3]
names(syear) <- syear_w[,1]

target <- list(sgeo1, stype, sex, syear)
names(target) <- c("sgeo1", "stype", "sex", "syear")

# STEP 2
# Read in the dataset
gp <- read_rds("data/gp.rds")
# Match the data type with the required type
# Also filter the syear variable since we only have the four year data
gp <- as.data.frame(gp) %>% 
  filter(syear %in% c(2019, 2018, 2017, 2016))

gp$sgeo1 <- as.factor(gp$sgeo1)
gp$stype <- as.factor(gp$stype)
gp$sex <- as.factor(gp$sex)
gp$syear <- as.factor(gp$syear)

names(target$sgeo1) <- levels(gp$sgeo1)
names(target$stype) <- levels(gp$stype)
names(target$sex) <- levels(gp$sex)
names(target$syear) <- levels(gp$syear)

# Raking
raking <- anesrake(target,
                   gp,
                   gp$index,
                   cap = 100000,                      # Maximum allowed weight per iteration
                   choosemethod = "total",       # How are parameters compared for selection?
                   type = "pctlim",              # What selection criterion is used?
                   pctlim = 1e-5               # Threshold for selection
                   )

gp$weight2 <- raking$weightvec

# Update gp dataset
saveRDS(gp, file="data/gp.rds")
