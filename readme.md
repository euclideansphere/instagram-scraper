# Instagram top 10 post fetcher

This script will fetch the top 10 instagram posts for your account. You will need to obtain an oauth token to interface with Instagram's api. They have recently deprecated / removed the ability to query for other (yes, public) account data. Instagram (Facebook) seems to be migrating to their graph api targeted at business insight and marketing analytics.


## obtaining a temporary oauth token

1. register developer account
1. click manage clients
1. register a new client
1. fill fields, set `redirect_uri` to something you control (i.e. http://localhost)
1. save `client_id`, `redirect_uri`, and `client_secret` for later
1. http GET `https://instagram.com/oauth/authorize/?client_id=$client_id&redirect_uri=$redirect_url&response_type=code` to get a temp 1 time use code to get an oauth token
1. copy code from url, will be part of form body when posting to get the oauth token
1. do this in shell or via http client with `POST` with form body abilities 
```bash
curl -F 'client_id=your_client_id' \
-F 'client_secret=your_client_secret' \
-F 'grant_type=authorization_code' \
-F 'redirect_uri=your_redirect_uri' \
-F 'code=your_code' https://api.instagram.com/oauth/access_token
```
1. result will contain oauth token

## Time spent: 

* 2 hours figuring out how to get an oauth token
* 2 hours re-learning ruby
** base language constructs and syntax
** network interfacing, http,
** enumerable & array syntax
* ~0.5 hours logicking through behavior

## TODO:

1. make this more composable as a module
1. configurable parameters
		- output file name
		- how many posts
		- how long to go back
1. scripted oauth token setup?
1. what if there aren't 10 posts in the past 7 days? pagination?
1. use the new graph api to get public posts?

