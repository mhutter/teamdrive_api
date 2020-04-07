# TeamdriveApi

[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://rubydoc.org/gems/teamdrive_api/frames)
[![Gem Version](https://badge.fury.io/rb/teamdrive_api.svg)](http://badge.fury.io/rb/teamdrive_api)
[![Build Status](https://travis-ci.org/mhutter/teamdrive_api.svg?branch=master)](https://travis-ci.org/mhutter/teamdrive_api)

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

**Note about the URI:** For Pre-3.5-Versions of TeamDrive, this is usually `https://server/pbas/td2api/api/api.htm` for the Reg Server API and `https://server/pbas/p1_as/api/api.htm` for the Host Server API. From 3.5 onward, it is usually `https://server/yvva/td2api/api/api.htm` for the Reg Server API and `https://server/yvva/api/api.htm` for the Host Server API.

```ruby
api = TeamdriveApi::Register.new('example.com/yvva/api/api.htm', 'd3b07384d113edec49eaa6238ad5ff00', '1.0.005')
# Parameters for TeamdriveApi::Register.new and TeamdriveApi::Host.new:
# - URI (will use https if no schema is provided)
# - api_checksum_salt (from your Register/Host server)
# - api_version (has no effect but is included in requests to the servers)

api.remove_user 'foobar'
#=> true

api.search_user username: '$CODE-*'
#=> {:apiversion=>"1.0.005",
#=>  :searchresult=>{:current=>"3", :maximum=>"50", :total=>"3"},
#=>  :userlist=>
#=>   {:user=>
#=>     [{:userid=>"2",
#=>       :username=>"$CODE-1002",
#=>       :email=>"user2@example.com",
#=>       :reference=>nil,
#=>       :department=>nil,
#=>       :language=>"en",
#=>       :distributor=>"CODE",
#=>       :usercreated=>"07/25/2014 15:06:41.00",
#=>       :status=>"activated"},
#=>      {:userid=>"10",
#=>       :username=>"$CODE-1010",
#=>       :email=>"user10@example.com",
#=>       :reference=>nil,
#=>       :department=>nil,
#=>       :language=>"en",
#=>       :distributor=>"CODE",
#=>       :usercreated=>"10/01/2014 09:31:49.00",
#=>       :status=>"activated"},
#=>      {:userid=>"15",
#=>       :username=>"$CODE-1015",
#=>       :email=>"user15@example.com",
#=>       :reference=>nil,
#=>       :department=>nil,
#=>       :language=>"en",
#=>       :distributor=>"CODE",
#=>       :usercreated=>"03/04/2015 13:39:09.00",
#=>       :status=>"activated"}]}}
```

For more Information see {TeamdriveApi::Register}

### Version History

See the [CHANGELOG](https://github.com/mhutter/teamdrive_api/tree/master/CHANGELOG.md)

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
