#practice using data table 
library(data.table)
library(broom)
library(magrittr)
library(tidyverse)

mtcars%<>%data.table
mtcars%>%head
mtcars[,glance(lm(mpg~wt)),by=cyl] ##same as model_mtcars %>%unnest(glance)
mtcars[,tidy(lm(mpg~wt)),by=cyl]
mtcars[,tidy(lm("mpg"~"wt")),by=cyl] ##however cannot pass dynamic varibales 1
mtcars[,tidy(lm([["mpg"]]~[["wt"]])),by=cyl] ##however cannot pass dynamic varibales 2
mtcars[,mean(mpg),by=cyl] ##still lots of potential in data table 


dy_lm<-function(data,xvar,yvar,...) data%$%lm(.[[yvar]]~.[[xvar]],...)

mtcars[,augment(loess(mpg~wt)),by=cyl]
mtcars[,augment(loess(mpg~wt))]
