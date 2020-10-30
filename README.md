Text Mining Tool <img src="app/www/img/hex.png" align="right" width="120" />
============================================================================

<br>

Instructions
------------

This interface was all developed in R using mainly the shiny and rtweet
packages. The tool is online on shinyapps’ repository at the adress
<a href="https://adsoncostanzi.shinyapps.io/TextMining/" class="uri">https://adsoncostanzi.shinyapps.io/TextMining/</a>.

## Development

Open the project using RStudio.

## Deployment

After running the docker container or executing `app.R` locally, access the application on `localhost:3838`.

### Docker

Build and run the application as following:
```shell
$ docker build -t text_mining .
$ docker run \
 -e API_KEY="AAA" \
 -e API_SECRET="BBB" \
 -e ACCESS_TOKEN="CCC" \
 -e ACCESS_SECRET="XXX" \
 -e APP_NAME="YYY" \
 -p 3838:3838 \
 text_mining
```

Simplified docker deploy using docker-compose:
```shell
$ API_KEY="AAA" API_SECRET="BBB" ACCESS_TOKEN="CCC" ACCESS_SECRET="XXX" APP_NAME="YYY" docker-compose up
```

Note: in both cases, set environment variables with credentials information. Otherwise the container may exit.

### Local

Install system dependencies:
* r-base
* libssl-dev 
* libcurl4-openssl-dev

Install R packages:
* curl
* openssl
* httr
* rtweet
* lubridate
* emayili
* dplyr
* shiny
* twitteR
* qdapRegex
* tidyr
* tidytext
* shinydashboard
* shinycssloaders
* shinydashboardPlus
* shinyWidgets
* shinyhelper
* shinyjs
* stopwords
* wordcloud
* plotly
* echarts4r
* networkD3
* widyr

Create credential file as described below.

Inside `TextMining/app` folder, run `Rscript app.R`.

### Credential File Example

Once you have the Twitter API autorization you must create an R file
called `twitter_credentials.R` inside the `app/credentials` folder. The
file must have 5 objects: api\_key, api\_secret, access\_token,
access\_secret, and app\_name.

The `twitter_credentials.R` file should follow the template below:

    # set Twitter API parameters

    api_key <- "XXX"
    api_secret <- "XXX"
    access_token <- "XXX"
    access_secret <- "XXX"
    app_name <- "xxxxx"
