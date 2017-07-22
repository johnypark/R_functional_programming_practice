readme
================

R Functional Programming
------------------------

This repository is to practice R Functional Programming. It will consist of series of practices. In practice 1, the use of package tidyr and broom will be explored, to pass functions, to tidy dataset using data frame. Practice 2 I will practice the use of package data.table along with package broom. data.table is underrepresented package that not only gives wide variety of applications in data wrangling, but also gives users fast data processing speed.

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

And the final product is...

``` r
groupby_mtcars<-mtcars %>% group_by(cyl)%>%nest()

trait_model<-function(df,x.var,y.var){
  df %$%loess(.[[y.var]]~.[[x.var]])  
}

groupby_mtcars %>% 
  mutate(
    
    model=data%>%map(trait_model,"wt","mpg")
    
    
    
  )
```

    ## # A tibble: 3 x 3
    ##     cyl               data       model
    ##   <dbl>             <list>      <list>
    ## 1     6  <tibble [7 x 10]> <S3: loess>
    ## 2     4 <tibble [11 x 10]> <S3: loess>
    ## 3     8 <tibble [14 x 10]> <S3: loess>

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
