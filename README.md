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

## Installation

### Via Bundler

Add 'medium_sdk' to Gemfile and then run `bundle`:

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

Using the default authorization URL:

```ruby
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

#### Integration Token

```ruby
require 'medium_sdk'

client = MediumSdk.new integration_token: token
```

### API Requests

#### Users

##### Getting the authenticated user’s details

```ruby
data = client.me
```

#### Publications

##### Listing the user’s publications

```ruby
data = client.user_publications 'user_id'
```

##### Fetching contributors for a publication

```ruby
data = client.publication_contributors 'publication_id'
```

#### Posts

##### Creating a post

```ruby
post = {
  title: "Hard things in software development",
  contentFormat: "html",
  content: "<p>Cache invalidation</p><p>Naming things</p>",
  tags: ["development", "design"],
  publishStatus: "draft"
}

data = client.post post
```

##### Creating a post under a publication

Creating a post under a publication uses the same method call with the addtion of the `publicationId` parameter.

```ruby
post = {
  title: "Hard things in software development",
  contentFormat: "html",
  content: "<p>Cache invalidation</p><p>Naming things</p>",
  tags: ["development", "design"],
  publishStatus: "draft",
  publicationId: "deadbeef"
}

data = client.post post
```

### Change Log

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

Medium SDK for Ruby &copy; 2016 by John Wang

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
