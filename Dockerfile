FROM rocker/tidyverse

RUN mkdir -p /home/rstudio/data /home/rstudio/output 

COPY . /home/rstudio/Corona_Vis_Shiny/

WORKDIR /home/rstudio/Corona_Vis_Shiny/

RUN chmod 777 -R /home/

RUN install2.r --error \
  rvest \
  dplyr \
  tidyr \
  assertthat \
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

RUN Rscript /home/rstudio/Corona_Vis_Shiny/scripts/install_packages.R
RUN /home/rstudio/Corona_Vis_Shiny/scripts/system_dependencies.sh

RUN R CMD build /home/rstudio/Corona_Vis_Shiny/
RUN R CMD INSTALL /home/rstudio/Corona_Vis_Shiny/CoronaVisualisation_0.1.0.tar.gz

CMD ["/home/rstudio/Corona_Vis_Shiny/scripts/start.sh"]
