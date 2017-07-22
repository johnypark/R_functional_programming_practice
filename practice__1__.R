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
factors.list=c("cyl","am","gear")


##passing dynamic variables 
model_mtcars<-list()

var.list=c("wt","hp","drat","qsec") #passing variables 

groupby_mtcars<-mtcars %>% group_by(cyl)%>%nest()
for (v in var.list){
  
  model_mtcars[[v]]<-groupby_mtcars %>% 
  mutate(
    
    model=data%>%map(trait_model,v,"mpg"),
    glance=model%>%map(broom::glance),
    tidy   = map(model, broom::tidy)
    
    
  )
  model_mtcars[[v]]$modelxy<-sprintf("mpg~%s",v)
}

model_mtcars<-do.call("rbind",model_mtcars)
  
  

  

