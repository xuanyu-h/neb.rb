# encoding: utf-8
# frozen_string_literal: true

module Neb
  module Secp256k1

    # Elliptic curve parameters
    P  = 2**256 - 2**32 - 977
    N  = 115792089237316195423570985008687907852837564279074904382605163141518161494337
    A  = 0
    B  = 7
    Gx = 55066263022277343669578718895168534326250603453777594175500187360389116729240
    Gy = 32670510020758816978083085130507043184471273380659243275938904335757337482424
    G  = [Gx, Gy].freeze

    SECP256K1 = 1;

    class InvalidPrivateKey < StandardError; end

    class << self

      def sign(msg, priv)
        priv = PrivateKey.new(priv)
        privkey = ::Secp256k1::PrivateKey.new(privkey: priv.encode(:bin), raw: true)
        signature = privkey.ecdsa_recoverable_serialize(
          privkey.ecdsa_sign_recoverable(msg, raw: true)
        )

        # v = signature[1]
        # r = Utils.bin_to_hex(signature[0][0,32])
        # s = Utils.bin_to_hex(signature[0][32,32])
        # puts v, r, s

        signature[0] << signature[1]
      end

      def priv_to_pub(priv)
        priv = PrivateKey.new(priv)
        privkey = ::Secp256k1::PrivateKey.new(privkey: priv.encode(:bin), raw: true)
        pubkey = privkey.pubkey
        PublicKey.new(pubkey.serialize).encode(priv.format)
      end
    end
  end
end
