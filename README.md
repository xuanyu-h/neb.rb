# Nebulas Ruby API

This is the Nebulas compatible Ruby API. Users can use it in Ruby and Rails. This ruby library also support API for our Repl console. Users can sign/send transactions and deploy/call smart contract with it. [neb.rb](https://github.com/NaixSpirit/neb.rb)

## Install Secp256k1

https://github.com/cryptape/ruby-bitcoin-secp256k1

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
# The client API
resp = client.api.get_neb_state
resp.code     # => 200
resp.success? # => true
resp.result   # =>  {:chain_id=>100, :tail=>"xxxx", :lib=>"xxxx", :height=>"1085", :protocol_version=>"/neb/1.0.0", :synchronized=>false, :version=>"1.0.1"}

# The Admin API
resp = client.admin.accounts
resp.code     # => 200
resp.success? # => true
resp.result   # => {:addresses=>["n1FF1nz6tarkDVwWQkMnnwFPuPKUaQTdptE", "n1FNj5aZhKFeFJ8cQ26Lvsr84NDvNSVRu67"]}

# Create a new account with random private_key
account = Neb::Account.create
account = Neb::Account.create(YOUR_PASSOWRD)

account.private_key         # => "b5e53a1582a48d243ebd478a7722d1bfea4805ff7c1da4cc7084043e8263c5a8"
account.public_key          # => "35a80ac8a27e2bf072ae84b2cb019e3af0c06547ad939fab1c6d12f713d26ae178d1fd6677aef3e6e94bc7cc1a39f4ca80fc2409a5ef59f97ee55dbd6efc7714"
account.address             # => "n1NfnKqgXBixjiDkJZDSVwqf7ps5roGwFyJ"
account.password = "123456" # or account.set_password("123456")
account.to_key              # => {:version=>4, :id=>"becde267-902e-4f23-ac01-53a4ba6edac7", :address=>"n1VYLxkZoehWEWPHxi351HgZ2R8Hfn2DGpa" ....}
account.to_key_file("/tmp/mykey.json")

# Create a new account from exist private_key
account = Neb::Account.new(YOUR_PRIVATE_KEY)
account = Neb::Account.new(YOUR_PRIVATE_KEY, YOUR_PASSOWRD)

# Restore account from key
account = Neb::Account.from_key(YOUR_KEY, YOUR_PASSOWRD)

# Restore account from a key file
account = Neb::Account.from_key_file(YOUR_KEY_FILE, YOUR_PASSOWRD)
```

# Documentation

## API list

[Ruby Client API list](https://github.com/NaixSpirit/neb.rb/blob/master/lib/neb/client/api.rb)
[Ruby Admin API list](https://github.com/NaixSpirit/neb.rb/blob/master/lib/neb/client/admin.rb)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/NaixSpirit/neb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Neb project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/NaixSpirit/neb.rb/blob/master/CODE_OF_CONDUCT.md).
