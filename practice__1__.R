"->"<-function(a,b)b<-a
source("required.packages.R")
groupby_mtcars

trait_model<-function(df){
  lm(mpg~wt,data=df)  
}

"mpg"
"wt"
groupby_mtcars<-mtcars %>% group_by(cyl)%>%nest()

trait_model<-function(df,x.var,y.var){
  df %$%loess(.[[y.var]]~.[[x.var]])  
}


model_mtcars<-groupby_mtcars %>% 
  mutate(
    
    model=data%>%map(trait_model,"wt","mpg")
    
    
    
  )

model_mtcars<-mtcars %>% group_by(cat)%>% nest() %>%
  mutate(
    
    model=data%>%map(trait_model,"wt","mpg") %>%map(summary)
    
    
    
  )

model_mtcars 


mtcars[[""]]