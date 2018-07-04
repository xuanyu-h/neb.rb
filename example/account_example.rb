require 'neb'

# Create a new account with random private_key
account = Neb::Account.create
account = Neb::Account.create(password: "passphrase")

puts "new account info: \n"
puts account.private_key         # => "b5e53a1582a48d243ebd478a7722d1bfea4805ff7c1da4cc7084043e8263c5a8"
puts account.public_key          # => "35a80ac8a27e2bf072ae84b2cb019e3af0c06547ad939fab1c6d12f713d26ae178d1fd6677aef3e6e94bc7cc1a39f4ca80fc2409a5ef59f97ee55dbd6efc7714"
puts account.address             # => "n1NfnKqgXBixjiDkJZDSVwqf7ps5roGwFyJ"
puts account.password = "123456" # or account.set_password("123456")
puts account.to_key              # => {:version=>4, :id=>"becde267-902e-4f23-ac01-53a4ba6edac7", :address=>"n1VYLxkZoehWEWPHxi351HgZ2R8Hfn2DGpa" ....}

account.to_key_file(file_path: "../tmp/example_keyjson.json")

# Create a new account from exist private_key
account = Neb::Account.new(private_key: account.private_key)
account = Neb::Account.new(private_key: account.private_key, password: "123456")

# Restore account from key
account = Neb::Account.from_key(key: account.to_key, password: "123456")

# Restore account from a key file
account = Neb::Account.from_key_file(key_file: "../tmp/example_keyjson.json", password: "123456")
puts "imported account: #{account.address}"
