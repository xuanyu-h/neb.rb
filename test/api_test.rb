require "test_helper"

class APITest < Neb::TestCase

  def setup
    @client = Neb::Client.new
  end

  def test_get_neb_state
    resp = @client.api.get_neb_state
    assert resp.success?
    assert_equal 200, resp.code
    assert_equal 100, resp.result[:chain_id]
  end

  def test_node_info
    resp = @client.admin.node_info
    assert resp.success?
    assert_equal 200, resp.code
    assert_equal 100, resp.result[:chain_id]
  end
end