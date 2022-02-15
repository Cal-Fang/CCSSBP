library(haven)
library(tidyverse)
setwd("~/Box Sync/CCSSBP Project")
# dataset = read_sav("0506.sav", encoding = "latin1")
# 
# write.csv(dataset, "0506.csv")

# STEP 1
# Read in the general population survey
gp <- read.csv("SRH Project/2020_NCSS-SRH_Database_20200228_CQF/9.2020NCSS-SRH_200228cleaned_220208outCQF.csv")

# Export the variable names and relabel them in excel
# It's just easier
varlist <- as_data_frame(colnames(gp))
write.csv(varlist, "varlist.csv", fileEncoding = "UTF-8")
??write_csv
