require "test_helper"

class AdminTest < Neb::TestCase

  def setup
    @client = Neb::Client.new
  end

  def test_node_info
    resp = @client.admin.node_info
    assert resp.success?
    assert_equal 200, resp.code
    assert_equal 100, resp.result[:chain_id]
  end

  def test_accounts
    resp = @client.admin.accounts
    assert resp.success?
    assert_equal 200, resp.code
    assert resp.result[:addresses]
  end

  def test_new_account
    resp = @client.admin.new_account(passphrase: '123456')
    assert resp.success?
    assert_equal 200, resp.code
    assert resp.result[:address]
  end

  def test_unlock_and_lock_account
    address = @client.admin.new_account(passphrase: '123456').result[:address]

    resp = @client.admin.unlock_account(address: address, passphrase: '123456')
    assert resp.success?
    assert_equal 200, resp.code
    assert resp.result

    resp = @client.admin.lock_account(address: address)
    assert resp.success?
    assert_equal 200, resp.code
    assert resp.result
  end

  def test_get_config
    resp = @client.admin.get_config
    assert resp.success?
    assert_equal 200, resp.code
    assert resp.result[:config].present?
  end
end
