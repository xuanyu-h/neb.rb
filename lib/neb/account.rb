# encoding: utf-8
# frozen_string_literal: true

require "ffi"
require "bitcoin"
require "sha3"

module Neb
  class Account
    ADDRESS_LENGTH = 26
    ADDRESS_PREFIX = 25
    NORMAL_TYPE    = 87
    CONTRACT_TYPE  = 88

    attr_reader :key

    class << self
      def create
        new.generate
      end
    end

    def initialize(private_key: nil)
      @key = ::OpenSSL::PKey::EC.new("secp256k1")
      set_private_key(private_key) if private_key.present?
      regenerate_public_key        if private_key.present?
    end

    # Generate new priv/pub key.
    def generate
      @key.generate_key
      self
    end

    def private_key
      return nil unless @key.private_key
      @key.private_key.to_hex.rjust(64, '0')
    end

    def public_key
      @key.public_key.to_hex.rjust(128, '0').slice(1..-1)
    end

    # Get the address corresponding to the public key.
    def address
      bytes = ['04' + public_key].pack("H*")
      Digest::RMD160.hexdigest(SHA3::Digest.digest(256, bytes))
    end

    # Set the private key to +priv+ (in hex).
    def private_key=(priv)
      set_private_key(priv)
      regenerate_public_key
    end

    private

      def set_private_key(priv)
        value = priv.to_i(16)
        @key.private_key = OpenSSL::BN.from_hex(value)
      end

      def regenerate_public_key
        return nil unless @key.private_key
        p Bitcoin::OpenSSL_EC.regenerate_key(private_key)
        set_public_key(Bitcoin::OpenSSL_EC.regenerate_key(private_key)[1])
      end

      def set_public_key(pub)
        @key.public_key = OpenSSL::PKey::EC::Point.from_hex(@key.group, pub)
      end

  end
end
