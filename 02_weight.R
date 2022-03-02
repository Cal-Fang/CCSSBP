library(anesrake)
library(weights)
library(readr)
setwd("~/Box Sync/CCSSBP Project")

# cite: https://www.r-bloggers.com/2018/12/survey-raking-an-illustration/

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
# Read in the dataset
gp_clean <- read_rds("data/gp_clean.rds")
# Match the data type with the required type
gp_clean <- as.data.frame(gp_clean)

gp_clean$sgeo1 <- as.factor(gp_clean$sgeo1)
gp_clean$stype <- as.factor(gp_clean$stype)
gp_clean$gender <- as.factor(gp_clean$gender)
gp_clean$syear <- as.factor(gp_clean$syear)

names(target$sgeo1) <- levels(gp_clean$sgeo1)
names(target$stype) <- levels(gp_clean$stype)
names(target$gender) <- levels(gp_clean$gender)
names(target$syear) <- levels(gp_clean$syear)

# Raking
raking <- anesrake(target,
                   gp_clean,
                   gp_clean$index,
                   cap = 100000,                      # Maximum allowed weight per iteration
                   choosemethod = "total",       # How are parameters compared for selection?
                   type = "pctlim",              # What selection criterion is used?
                   pctlim = 1e-5               # Threshold for selection
                   )

gp_clean$weight2 <- raking$weightvec

# Save data
saveRDS(gp_clean, file="data/gp_clean.rds")