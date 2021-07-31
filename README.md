# Corona_visualization in Shiny

Visualization of corona data on country level.
Shows confirmed cases, confirmed deaths, daily rate, fatality rate and forecasting of cases and deaths for the countries chosen.
Data on corona cases and deaths comes from John Hopkins Corona Github Repo, data on country population comes from worldometers.com.

Plots are enhanced with plotly, making them interactive and making it easier to compare countries.

Dockerfile ensures that the plot can be updated by running the docker container

To use: 
- Clone repo
- Create a shinyapps.io account
- Save account data in a rsconnect_data.rds file in data folder on local system
- build docker container
- run docker container

## TBD create file with shiny login data separate from github repo - copy over file to container through docker run command
- ensure azure access to file - store file in registry?

## Dockerfile
- install package bioconductor to newest version

TODO: Make map visualization, leaflet - look at john hopkins
TODO: Hospitalizations?
TODO: daily change in cases - histogram?

TODO: Forecasting - tidymodels xgboost?
TODO: - training on database side, prediction on database side or server side? - send model and prediction funciton to server https://www.tidymodels.org/start/case-study/

TODO: refactoring - put all data in one dataframe with new column names etc 

TODO: downsize dockerimage - too many API requests in docker container
