Medium SDK for Ruby
========================

[![Gem Version][gem-version-svg]][gem-version-link]
[![Build Status][build-status-svg]][build-status-link]
[![Coverage Status][coverage-status-svg]][coverage-status-link]
[![Dependency Status][dependency-status-svg]][dependency-status-link]
[![Code Climate][codeclimate-status-svg]][codeclimate-status-link]
[![Scrutinizer Code Quality][scrutinizer-status-svg]][scrutinizer-status-link]
[![Downloads][downloads-svg]][downloads-link]
[![Docs][docs-rubydoc-svg]][docs-rubydoc-link]
[![License][license-svg]][license-link]

## Description

A Ruby SDK for the [Medium.com API](https://github.com/Medium/medium-api-docs) including:

1. Auth via OAuth 2.0 with [automatic token refresh](https://github.com/grokify/faraday_middleware-oauth2_refresh) and [demo app](https://github.com/grokify/medium-sdk-ruby/tree/master/scripts/sinatra)
1. Auth via integration token with [demo app](https://github.com/grokify/medium-sdk-ruby/blob/master/scripts)
1. Get and Post APIs

## Installation

### Via Bundler

Add `medium_sdk` to Gemfile and then run `bundle`:

```sh
$ echo "gem 'medium_sdk'" >> Gemfile
$ bundle
```

### Via RubyGems

```sh
$ gem install medium_sdk
```

## Usage

### Authorization

#### Authorization Code Grant

The OAuth 2.0 authorization code grant is designed for where authorization needs to be granted by a 3rd party resource owner.

* Initializing the SDK with the `client_id` parameter will use `MediumSdk::Connection::AuthCode` to manage the connection
* Token refresh is automatically / transparently handled by `FaradayMiddleware::OAuth2Refresh`

```ruby
require 'medium_sdk'

# Initialize SDK with OAuth redirect URI
client = MediumSdk.new(
  client_id: 'my_client_id',
  client_secret: 'my_client_secret',
  redirect_uri: 'https://example.com/callback/medium'
)

# Retrieve OAuth authorize url using default redirect URL
auth_url = client.connection.authorize_uri(
  scope: 'basicProfile,publishPost',
  state: 'myState'
)
```

On your redirect page, you can exchange your authorization code for an access token using the following:

```ruby
code  = params['code'] # e.g. using Sinatra to retrieve code param in Redirect URI
client.connection.authorize_code(code)
```

You can also save and load tokens for use across SDK instances:

```ruby
# Access `OAuth2::AccessToken` object as hash including `access_token`, `refresh_token`, etc.
token_hash = client.connection.token.to_hash

# set_token() accepts a hash or OAuth2::AccessToken object
client.connection.set_token(token_hash)
```

#### Integration Token

Initializing the SDK with the `integration_token` and not the `client_id` parameter will use `MediumSdk::Connection::IntegrationToken` to manage the connection.

```ruby
require 'medium_sdk'

# Initialize SDK with integration token
client = MediumSdk.new integration_token: token

# Set integration token after initialization
client.connection.token = token
```

### API Requests

#### Convenience Methods

Convenience methods are provided which return the `data` property of the response body.

```ruby
# Getting the authenticated user’s details
data = client.me

# Listing the user’s publications
data = client.user_publications 'user_id'

# Fetching contributors for a publication
data = client.publication_contributors 'publication_id'

# Creating a user post
data = client.post, {
  title: "Hard things in software development",
  contentFormat: "html",
  content: "<p>Cache invalidation</p><p>Naming things</p>",
  tags: ["development", "design"],
  publishStatus: "draft"
}

# Creating a publication post
data = client.post, {
  title: "Hard things in software development",
  contentFormat: "html",
  content: "<p>Cache invalidation</p><p>Naming things</p>",
  tags: ["development", "design"],
  publishStatus: "draft",
  publicationId: "deadbeef"
}
```

#### Raw Methods

The SDK's Faraday client can be accessed for sending raw requests:

```ruby
response = client.connection.http.get 'me'

response = client.connection.http do |req|
  req.url 'me'
end
```

## Demos

Demos are in the `scripts` directory and use `.env` files for configuration.

### Integration Token Demo

```bash
$ cd scripts
$ cp example.env .env
$ vi .env
$ ruby me_token.rb
```

### OAuth 2.0 Demo

Execute the following and then go to the URL in your browser after launching the Sinatra app.

```bash
$ cd scripts/sinatra
$ bundle
$ cp example.env .env
$ vi .env
$ ruby app.rb
``` 

## Change Log

See [CHANGELOG.md](CHANGELOG.md)

## Links

Project Repo

* https://github.com/grokify/medium-sdk-ruby

Medium API Docs

* https://github.com/Medium/medium-api-docs

## Contributing

1. Fork it ( http://github.com/grokify/medium-sdk-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Medium SDK for Ruby is available under an MIT-style license. See [LICENSE.txt](LICENSE.txt) for details.

Medium SDK for Ruby &copy; 2016 by [John Wang](https://github.com/grokify)

 [gem-version-svg]: https://badge.fury.io/rb/medium_sdk.svg
 [gem-version-link]: http://badge.fury.io/rb/medium_sdk
 [downloads-svg]: http://ruby-gem-downloads-badge.herokuapp.com/medium_sdk
 [downloads-link]: https://rubygems.org/gems/medium_sdk
 [build-status-svg]: https://api.travis-ci.org/grokify/medium-sdk-ruby.svg?branch=master
 [build-status-link]: https://travis-ci.org/grokify/medium-sdk-ruby
 [coverage-status-svg]: https://coveralls.io/repos/grokify/medium-sdk-ruby/badge.svg?branch=master
 [coverage-status-link]: https://coveralls.io/r/grokify/medium-sdk-ruby?branch=master
 [dependency-status-svg]: https://gemnasium.com/grokify/medium-sdk-ruby.svg
 [dependency-status-link]: https://gemnasium.com/grokify/medium-sdk-ruby
 [codeclimate-status-svg]: https://codeclimate.com/github/grokify/medium-sdk-ruby/badges/gpa.svg
 [codeclimate-status-link]: https://codeclimate.com/github/grokify/medium-sdk-ruby
 [scrutinizer-status-svg]: https://scrutinizer-ci.com/g/grokify/medium-sdk-ruby/badges/quality-score.png?b=master
 [scrutinizer-status-link]: https://scrutinizer-ci.com/g/grokify/medium-sdk-ruby/?branch=master
 [docs-rubydoc-svg]: https://img.shields.io/badge/docs-rubydoc-blue.svg
 [docs-rubydoc-link]: http://www.rubydoc.info/gems/medium_sdk/
 [license-svg]: https://img.shields.io/badge/license-MIT-blue.svg
 [license-link]: https://github.com/grokify/medium-sdk-ruby/blob/master/LICENSE.txt
