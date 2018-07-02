require "test_helper"

class APITest < Neb::TestCase

  def setup
    @client  = Neb::Client.new
    @account = Neb::Account.create
  end

  def test_get_neb_state
    resp = @client.api.get_neb_state
    assert resp.success?
    assert_equal 200, resp.code
    assert_equal 100, resp.result[:chain_id]
  end

  def test_latest_irreversible_block
    resp = @client.api.latest_irreversible_block
    assert resp.success?
    assert_equal 200, resp.code
    assert resp.result[:hash].present?
  end

  def test_get_account_state
    resp = @client.api.get_account_state(address: @account.address)
    assert resp.success?
    assert_equal 200, resp.code
    assert resp.result[:balance].present?
  end

  def test_get_dynasty
    resp = @client.api.get_dynasty(height: 1)
    assert resp.success?
    assert_equal 200, resp.code
    assert resp.result[:miners].present?
  end

  def test_get_gas_price
    resp = @client.api.latest_irreversible_block
    assert resp.success?
    assert_equal 200, resp.code
    assert resp.result[:hash].present?
  end
end
