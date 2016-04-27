# Kloudless

Kloudless API Ruby client.

## Installation

Add this line to your application's Gemfile:

    gem 'kloudless'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install kloudless

## Usage

See the [Kloudless API Docs](https://developers.kloudless.com/docs) for the
official reference. You can obtain an API Key at the [Developer
Portal](https://developers.kloudless.com/).

```ruby
# Authentication using a Bearer Token obtained by authenticating a user.
Kloudless.authorize(token: "abc")

# Alternatively, use the line below for API Keys:
# Kloudless.authorize(api_key: "abc")

accounts = Kloudless::Account.list
account = accounts.first

account = Kloudless::Account.update(account_id: account.id, active: false)
Kloudless::Account.delete(account_id: account.id)
```

## Version

This gem uses [semantic versioning](http://semver.org), where a version number
looks like:

```
v major.minor.patch
```

The major version tracks the version of the Kloudless API. For example, all
versions that start with `v0.x.y` are compatible with Kloudless API `v0`.

## Release

To release this gem, look under the `script` directory. Check out
[jch/release-scripts](https://github.com/jch/release-scripts) for details.

## Contributing

[TODO.md](TODO.md) has a list of things to work on. File an issue or pull
request if you'd like to discuss or tackle any of those tasks.

1. Fork it ( https://github.com/[my-github-username]/kloudless/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new [Pull Request](https://help.github.com/send-pull-requests/)
