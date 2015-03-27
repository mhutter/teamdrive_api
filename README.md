# TeamdriveApi

[![Build Status](https://travis-ci.org/mhutter/teamdrive_api.svg?branch=master)](https://travis-ci.org/mhutter/teamdrive_api)
[![Code Climate](https://codeclimate.com/github/mhutter/teamdrive_api/badges/gpa.svg)](https://codeclimate.com/github/mhutter/teamdrive_api)
[![Test Coverage](https://codeclimate.com/github/mhutter/teamdrive_api/badges/coverage.svg)](https://codeclimate.com/github/mhutter/teamdrive_api)

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

1. Fork it ( https://github.com/mhutter/teamdrive_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Trademarks

All trademarks named within this project are, without limitation, subject to the regulations of the trademark laws in each case, and as appropriate to ownership rights of the respective registered owners.
