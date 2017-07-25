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
    summary=model%>%map(summary),
   # rsq=summary%>%map_dbl(r.squared)
    
    
  )

model_mtcars%>%unnest(glance)
model_mtcars%>%unnest(tidy)
model_mtcars%>%unnest(model) ##does not work
factors.list=c("cyl","am","gear")


##passing dynamic variables 
model_mtcars<-list()

var.list=c("wt","hp","drat","qsec") #passing variables 
## @knitr gen_model_mtcars
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
model_mtcars  


## @knitr plotting_model_mtcars
model_mtcars$modelxy%>%unique->model.lists

Fig.bymodel<-list()
v=0;
for(model.name in model.lists){
  v=v+1
  y.name<-model.name%>%strsplit(.,"~")%>%.[[1]]%>%.[1]
  x.name<-model.name%>%strsplit(.,"~")%>%.[[1]]%>%.[2]
  Fig.bymodel[[v]]<-model_mtcars%>%filter(modelxy==model.name)%>%
    unnest(data)%>%
    ggplot(aes_string(x=x.name,y=y.name))+geom_point()
  
  
}

  cowplot::plot_grid(plotlist=Fig.bymodel,labels=c("A","B","C","D"))


