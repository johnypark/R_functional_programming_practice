#practice using data table 
library(data.table)
library(broom)
library(magrittr)
library(tidyverse)

mtcars%<>%data.table
mtcars%>%head
mtcars[,glance(lm(mpg~wt)),by=cyl]