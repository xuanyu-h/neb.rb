require 'neb'

#Neb.configure(host: 'https://testnet.nebulas.io')
Neb.configure(host: 'http://127.0.0.1:8685')  #local node
client = Neb::Client.new

resp = client.api.get_neb_state
puts resp.code     # => 200
puts resp.success? # => true
puts resp.result   # =>  {:chain_id=>100, :tail=>"xxxx", :lib=>"xxxx", :height=>"1085", :protocol_version=>"/neb/1.0.0", :synchronized=>false, :version=>"1.0.1"}

client.api.subscribe(
  topics: ["chain.pendingTransaction"],
  on_download_progress: ->(c) { puts c }
)

resp = client.admin.accounts
resp.code     # => 200
resp.success? # => true
resp.result   # => {:addresses=>["n1FF1nz6tarkDVwWQkMnnwFPuPKUaQTdptE", "n1FNj5aZhKFeFJ8cQ26Lvsr84NDvNSVRu67"]}
