# Nebulas Ruby API

This is the Nebulas compatible Ruby API. Users can use it in Ruby and Rails. This ruby library also support API for our Repl console. Users can sign/send transactions and deploy/call smart contract with it. [neb.rb](https://github.com/NaixSpirit/neb.rb)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'neb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install neb

## Usage

```ruby
Neb.configure(host: 'https://testnet.nebulas.io')

client = Neb::Client.new
resp = client.get_neb_state
resp.code # => 200
resp.success? # => true
resp.result
# {
#   chain_id: 1001,
#   tail: "9a382a5b4b0be1a74ba9ca554b840ae711c055c591272e7882755c604e04a428",
#   lib: "10b3c7c219befb2bac79ec67f4cfe1c86bbdf28c8f60af4f3e1255b27477689f",
#   height: "390329",
#   protocol_version: "/neb/1.0.0",
#   synchronized: false,
#   version: "0.7.0"
# }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/neb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Neb project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/neb/blob/master/CODE_OF_CONDUCT.md).
