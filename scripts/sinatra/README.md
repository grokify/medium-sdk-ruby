# Medium SDK for Ruby OAuth 2.0 Demo using Sinatra

Use this Sinatra demo to try out OAuth 2.0 with Medium.

When you edit the `.env` file ensure your client id, client secret, and redirect URI is entered.

For testing purposes, your redirect URI can be localhost since this is redirected by the browser. [Ngrok](https://ngrok.com/) can also be used.

```bash
$ cd scripts/sinatra
$ bundle
$ cp example.env .env
$ vi .env
$ ruby app.rb
``` 
