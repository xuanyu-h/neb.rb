require 'neb'

#Neb.configure(host: 'https://testnet.nebulas.io')
Neb.configure(host: 'http://127.0.0.1:8685')  #local node

client = Neb::Client.new

#resp = client.admin.accounts
#puts resp.result
#puts resp.result[:addresses][0]

account = Neb::Account.create

tx = Neb::Transaction.new(
    chain_id: 100,
    from_account: account,
    to_address: 'n1SAeQRVn33bamxN4ehWUT7JGdxipwn8b17',
    value: 10,
    nonce: 1,
    gas_price: 1000000,
    gas_limit: 2000000
)

tx.sign_hash

resp = client.api.send_raw_transaction(data: tx.to_proto_str)
puts resp.code     # => 200
if resp.success?
  puts resp.result   # => {:txhash=>"8524384dce7e122bfd007e0ba465e597d821e22db6d563b87dfc55d703fb008c", :contract_address=>""}
else
  puts resp.error
end


resp = client.api.get_transaction_receipt(hash: "8524384dce7e122bfd007e0ba465e597d821e22db6d563b87dfc55d703fb008c")
if resp.success?
  puts resp.result[:status]   # => 0,1,2
else
  puts resp.error
end

client.api.get_account_state(address: 'n1SAeQRVn33bamxN4ehWUT7JGdxipwn8b17').result # => {:balance=>"10", :nonce=>"0", :type=>87}



#call type transaction test
Neb.configure(host: 'https://testnet.nebulas.io')

client = Neb::Client.new
key_json = '{"version":4,"id":"72dd1261-96dc-4463-ad97-dd212795e1a0","address":"n1H2Yb5Q6ZfKvs61htVSV4b1U2gr2GA9vo6","crypto":{"ciphertext":"40352b32f39392b38022c2a778cf8424ab823b2288c85a25f6097c1455837b74","cipherparams":{"iv":"0f0fb4b21e0727c16aabf339540b80f8"},"cipher":"aes-128-ctr","kdf":"scrypt","kdfparams":{"dklen":32,"salt":"405dfabee17917c4f4f7b818e387200fc83452d57b00d9ea329a5687d07aca01","n":4096,"r":8,"p":1},"mac":"59d9d7a36726ce3da1bf2d20d7469800376b0975e7110afbd578cf3401666557","machash":"sha3256"}}'
account = Neb::Account.from_key(key: key_json,password:'passphrase')

tx = Neb::Transaction.new(
    chain_id: 1001,
    from_account: account,
    to_address: 'n1oXdmwuo5jJRExnZR5rbceMEyzRsPeALgm',
    value: 10,
    nonce: 41,
    gas_price: 1000000,
    gas_limit: 2000000,
    contract:{function: 'get', args:'["nebulas"]'}
)

tx.sign_hash

resp = client.api.send_raw_transaction(data: tx.to_proto_str)
puts resp.code     # => 200
if resp.success?
  puts resp.result   # => {:txhash=>"8524384dce7e122bfd007e0ba465e597d821e22db6d563b87dfc55d703fb008c", :contract_address=>""}
else
  puts resp.error
end
