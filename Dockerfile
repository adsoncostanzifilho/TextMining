FROM r-base:4.0.3

WORKDIR /app

# Install packages and dependencies
RUN apt-get update && apt-get install libssl-dev libcurl4-openssl-dev -y \
 && R -e 'install.packages(c("curl", "openssl", "httr", "rtweet", "lubridate", "emayili", "dplyr", "shiny", "twitteR", "qdapRegex", "tidyr","tidytext","shinydashboard", "shinycssloaders","shinydashboardPlus","shinyWidgets","shinyhelper","shinyjs","stopwords","wordcloud","plotly","echarts4r","networkD3", "widyr"))'

# Copy files
COPY app /app

EXPOSE 3838

ENTRYPOINT "/app/entrypoint.sh"