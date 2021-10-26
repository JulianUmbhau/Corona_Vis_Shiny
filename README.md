# Corona_visualization in Shiny

Visualization of corona data on country level.
Shows confirmed cases, confirmed deaths, daily rate, fatality rate and forecasting of cases and deaths for the countries chosen.
Data on corona cases and deaths comes from John Hopkins Corona Github Repo, data on country population comes from worldometers.com.

Plots are enhanced with plotly, making them interactive and making it easier to compare countries.

Dockerfile ensures that the plot can be updated by running the docker container

In order to use the repo: 
- Clone repo
- Create a shinyapps.io account
- Save account data in a rsconnect_data.rds file in data folder on local system
- build docker container
- run docker container

## Live dashboard
https://julian-johannes-umbhau-jensen.shinyapps.io/workspace/
