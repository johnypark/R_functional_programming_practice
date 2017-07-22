readme
================

R Functional Programming, inspired by [plotcon talk](https://rstudio-pubs-static.s3.amazonaws.com/237010_6d37553296a34a6c899f2660911f1b17.html)
-----------------------------------------------------------------------------------------------------------------------------------------------

This repository is to practice R Functional Programming. It will consist of series of practices. In practice 1, the use of package [purrr](https://github.com/tidyverse/purrr), [tidyr](http://tidyr.tidyverse.org/) and [broom](https://cran.r-project.org/web/packages/broom/vignettes/broom.html) will be explored, to pass functions into data frame objects. Practice 2 I will practice the use of package [data.table](https://cran.r-project.org/web/packages/data.table/vignettes/datatable-intro.html) along with package broom. data.table is underrepresented package that not only gives wide variety of applications in data wrangling, but also gives users fast data processing speed.
The true value of using purrr::map to pass functions within data.frame objects is that passing around dynamic varible is possible. I havent succeeded to do the same with data.table objects, so any help on this will be welcomed

Practice 1 starts with ...

``` r
mtcars %>% group_by(cyl)%>%nest()
```

    ## # A tibble: 3 x 2
    ##     cyl               data
    ##   <dbl>             <list>
    ## 1     6  <tibble [7 x 10]>
    ## 2     4 <tibble [11 x 10]>
    ## 3     8 <tibble [14 x 10]>

definde function trait\_model

``` r
groupby_mtcars<-mtcars %>% group_by(cyl)%>%nest()

trait_model<-function(df,x.var,y.var){
  df %$%lm(.[[y.var]]~.[[x.var]])  
}
```

And use purrr::map to - pass function trait\_model to the dataframe colum 'data' create new column 'model', - then to pass function broom::glance to the column 'model' for creating another new column 'summary'.

``` r
groupby_mtcars %<>% 
  mutate(
    
    model=data%>%map(trait_model,"wt","mpg"),
    summary=model%>%map(broom::glance)
    
    
  )
```

Now groupby\_mtcars looks like this:

``` r
groupby_mtcars %>% head
```

    ## # A tibble: 3 x 4
    ##     cyl               data    model               summary
    ##   <dbl>             <list>   <list>                <list>
    ## 1     6  <tibble [7 x 10]> <S3: lm> <data.frame [1 x 11]>
    ## 2     4 <tibble [11 x 10]> <S3: lm> <data.frame [1 x 11]>
    ## 3     8 <tibble [14 x 10]> <S3: lm> <data.frame [1 x 11]>

use of purrr:map on data.frame has particular advantage to pass dynamic variables for models for example, I want to build linear model where the response variable is mpg, with mulitple explanatory varibles:

``` r
var.list=c("wt","hp","drat","qsec") #passing variables 
```

Now, we are going to create a list instead of a data frame, or a data table, to store multiple models:

``` r
##create a list to store data
model_mtcars<-list()
```

Next, we are going to pass those variables on the list to build multiple models using function: trait\_model

``` r
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
```

Practice 2 starts with ...

``` r
mtcars %>%data.table %>%head
```

    ##     mpg cyl disp  hp drat    wt  qsec vs am gear carb
    ## 1: 21.0   6  160 110 3.90 2.620 16.46  0  1    4    4
    ## 2: 21.0   6  160 110 3.90 2.875 17.02  0  1    4    4
    ## 3: 22.8   4  108  93 3.85 2.320 18.61  1  1    4    1
    ## 4: 21.4   6  258 110 3.08 3.215 19.44  1  0    3    1
    ## 5: 18.7   8  360 175 3.15 3.440 17.02  0  0    3    2
    ## 6: 18.1   6  225 105 2.76 3.460 20.22  1  0    3    1

Including Plots
---------------

You can also embed plots, for example:

![](readme_files/figure-markdown_github-ascii_identifiers/pressure-1.png)

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
