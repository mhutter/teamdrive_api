# TeamdriveApi

Client library for the TeamDrive XML API.

## Project State

Currently only supports the RegServer API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'teamdrive_api'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install teamdrive_api

## Usage

```ruby
api = TeamdriveApi::Register.new('example.com', 'd3b07384d113edec49eaa6238ad5ff00', '1.0.005')

api.remove_user 'foobar'
#=> true
```

## Options

Options and default values:

- `:api_version` ('1.0.005')
- `:register_path` ('pbas/td2api/api/api.htm')

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/teamdrive_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Trademarks

All trademarks named within this project are, without limitation, subject to the regulations of the trademark laws in each case, and as appropriate to ownership rights of the respective registered owners.
