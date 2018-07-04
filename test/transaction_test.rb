require "test_helper"

class TransactionTest < Neb::TestCase

  #
  # 1. Please Start Seed  Node: `./neb -c conf/default/config.conf`
  # 2. Please Start Miner Node: `./neb -c conf/example/miner.conf`
  #
  def setup
    @client  = Neb::Client.new

    @priv_key = '1875ee86bd2a6aabcd49aae4b4ba3bdad42e3d9893d1bb960d52839f59f51edf'
    @account  = Neb::Account.new(private_key: @priv_key)

    # https://github.com/nebulasio/go-nebulas/blob/master/conf/default/genesis.conf#LC11
    @genesis_address    = 'n1FF1nz6tarkDVwWQkMnnwFPuPKUaQTdptE'
    @genesis_passphrase = 'passphrase'

    # Check Account State
    account_resp = @client.api.get_account_state(address: @account.address)
    puts "Account State: #{account_resp.result}"
    puts

    # Check Genesis State
    genesis_resp = @client.api.get_account_state(address: @genesis_address)
    puts "Genesis State: #{genesis_resp.result}"
    puts

    @account_nonce = account_resp.result[:nonce].to_i
    @genesis_nonce = genesis_resp.result[:nonce].to_i
  end

  def test_validate_initialize_args
    assert_raises Neb::InvalidTransaction do
      Neb::Transaction.new(
        chain_id:     100,
        from_account: @account,
        to_address:   @genesis_address,
        value:        -100,
        nonce:        @account_nonce + 1
      )
    end
  end

  # Sign By Admin API
  def test_transaction_by_admin
    resp = @client.admin.sign_transaction_with_passphrase(
      from:       @genesis_address,
      to:         @account.address,
      value:      1_000_000_000_000_000_000,
      nonce:      @genesis_nonce + 1,
      passphrase: @genesis_passphrase
    )

    puts "Sign Transaction With Passphrase Response: #{resp}"
    puts

    txhash = resp.result[:txhash]

    # Get Transaction Receipt
    resp = @client.api.get_transaction_receipt(hash: txhash)
    puts "Transaction Receipt Response: #{resp}"
    puts

    assert_equal @genesis_address, resp.result[:from]
    assert_equal @account.address, resp.result[:to]
    assert_equal 1_000_000_000_000_000_000, resp.result[:value].to_i
  end

  def test_transaction_by_sign
    tx = Neb::Transaction.new(
      chain_id:     100,
      from_account: @account,
      to_address:   @genesis_address,
      value:        100,
      nonce:        @account_nonce + 1
    )

    tx.sign_hash
    puts "Sign Transaction: #{tx.to_proto_str}"

    resp = @client.api.send_raw_transaction(data: tx.to_proto_str)

    puts "Sign Transaction Response: #{resp}"
    puts

    txhash = resp.result[:txhash]

    # Get Transaction Receipt
    resp = @client.api.get_transaction_receipt(hash: txhash)
    puts "Transaction Receipt Response: #{resp}"
    puts

    assert_equal @account.address, resp.result[:from]
    assert_equal @genesis_address, resp.result[:to]
    assert_equal 100, resp.result[:value].to_i
  end
end
