Text Mining Tool <img src="app/www/img/hex.png" align="right" width="120" />
============================================================================

<br>

Instructions
------------

This interface was all developed in R using mainly the shiny and rtweet
packages. The tool is online on shinyapps’ repository at the adress
<a href="https://adsoncostanzi.shinyapps.io/TextMining/" class="uri">https://adsoncostanzi.shinyapps.io/TextMining/</a>.

PS: To run this app localy it is necessary to have Twitter autorization
(access\_token, access\_secret, api\_key, api\_secret). If you do not
have this autorization yet use the comand `rtweet::vignette("auth")` and
follow the instructions.

Once you have the Twitter API autorization you must create an R file
called `twitter_credentials.R` inside the `app/credentials` folder. The
file must have 5 objects: api\_key, api\_secret, access\_token,
access\_secret, and app\_name.

### Credential File Example

The `twitter_credentials.R` file should follow the template below:

    # set Twitter API parameters

    api_key <- "XXX"
    api_secret <- "XXX"
    access_token <- "XXX"
    access_secret <- "XXX"
    app_name <- "xxxxx"
