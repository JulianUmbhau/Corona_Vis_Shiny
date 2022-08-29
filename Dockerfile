FROM umbhau/corona_vis_shiny:1.0

RUN mkdir -p /home/rstudio/data /home/rstudio/output 

COPY . /home/rstudio/Corona_Vis_Shiny/

WORKDIR /home/rstudio/Corona_Vis_Shiny/

RUN chmod 777 -R /home/

RUN Rscript /home/rstudio/Corona_Vis_Shiny/scripts/install_packages.R

RUN R CMD build /home/rstudio/Corona_Vis_Shiny/
RUN R CMD INSTALL /home/rstudio/Corona_Vis_Shiny/CoronaVisualisation_0.1.0.tar.gz

#CMD ["/home/rstudio/Corona_Vis_Shiny/scripts/start.sh"]

ENTRYPOINT ["tail", "-f", "/dev/null"]