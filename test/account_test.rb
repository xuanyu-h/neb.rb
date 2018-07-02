require "test_helper"

class NebTest < Neb::TestCase

  def setup
    @account  = Neb::Account.create
    @password = '123456'
  end

  def test_create_account_with_random_private_key
    assert_equal 64,  @account.private_key.size
    assert_equal 128, @account.public_key.size
    assert_equal 35,  @account.address.size
  end

  def test_create_account_from_exist_private_key
    another_account = Neb::Account.new(private_key: @account.private_key)

    assert_equal @account.private_key, another_account.private_key
    assert_equal @account.public_key,  another_account.public_key
    assert_equal @account.address,     another_account.address
  end

  def test_create_account_from_key_file
    @account.set_password(@password)

    key_file = @account.to_key_file
    another_account = Neb::Account.from_key_file(key_file: key_file, password: @password)
    assert_equal @account.private_key, another_account.private_key
  end
end
