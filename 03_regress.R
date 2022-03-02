setwd("~/Box Sync/CCSSBP Project")
rm(list = ls())
library(tidyverse)

# Reshape the factor level
gp_clean$slevel <- factor(gp_clean$slevel,
                          levels=c("bachelor1", "bachelor2", "bachelor3", "bachelor4",
                                   "associate1", "associate2", "associate3"))
gp_clean$sbpen_b <- as.factor(gp_clean$sbpen_b)

# Whether or not had penetrative sex 
glm1 <- glm(sbpen_b ~ slevel + sgeo1 + gender + age, gp_clean, weights=weight2, family = "binomial")

# Sex Partner Amount
lm1 <- lm(sbpen_b ~ slevel + sgeo1 + gender + age, gp_clean, weights=weight2)

# Masturbation 
