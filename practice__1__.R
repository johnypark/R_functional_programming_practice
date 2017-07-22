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
  df %$%lm(.[[y.var]]~.[[x.var]])  
}


model_mtcars<-groupby_mtcars %>% 
  mutate(
    
    model=data%>%map(trait_model,"wt","mpg"),
    glance=model%>%map(broom::glance),
    tidy   = map(model, broom::tidy)
    
    
  )

model_mtcars%>%unnest(glance)
model_mtcars%>%unnest(tidy)
model_mtcars%>%unnest(model) ##does not work




model_mtcars<-mtcars %>% group_by(cat)%>% nest() %>%
  mutate(
    
    model=data%>%map(trait_model,"wt","mpg") %>%map(summary)
    
    
    
  )

model_mtcars 


mtcars[[""]]