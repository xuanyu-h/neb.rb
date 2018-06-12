# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Account
    attr_reader :private_key_obj, :public_key_obj, :address_obj

    def initialize(private_key)
      @private_key_obj = PrivateKey.new(private_key)
      @public_key_obj  = @private_key_obj.to_pubkey_obj
      @address_obj     = @public_key_obj.to_address_obj
    end

    class << self
      def create
        new(PrivateKey.random.to_s)
      end
    end

    def private_key
      @private_key_obj.to_s
    end

    def public_key
      @public_key_obj.to_s
    end

    def address
      @address_obj.to_s
    end

    # TODO: uncompleted
    def to_key(password)
    end

  end
end
