library(haven)

setwd("~/Box Sync/Being LGBT in XXU Project")
dataset = read_sav("0506.sav", encoding = "latin1")

write.csv(dataset, "0506.csv")
