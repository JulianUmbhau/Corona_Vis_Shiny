FROM rocker/tidyverse

RUN apt-get -y update \
  && apt-get -y upgrade \
  && apt-get install -y libxml2-dev \
  && apt-get install -y libssl-dev \
  && apt-get install -y libcurl4-openssl-dev

RUN install2.r --error \
  rvest \
  dplyr \
  tidyr \
  usethis \
  shiny \
  rsconnect \
  pkgload \
  testthat \
  ggplot2 \
  scales \
  plotly \
  tidymodels \
  timetk \
  glmnet \
  randomForest \
  parsnip \
  recipes \
  rsample \
  modeltime \
  workflows \
  devtools \
  rstudioapi
