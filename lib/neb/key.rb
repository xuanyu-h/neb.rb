# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Key
    KDF = "scrypt".freeze
    CIPHER_NAME = "aes-128-ctr".freeze
    MACHASH = "sha3256".freeze

    KDF_N = 1 << 12
    KDF_R = 8
    KDF_P = 1
    DKLEN = 32

    KEY_CURRENT_VERSION = 4
    KEY_VERSION_3       = 3

    attr_accessor :address, :private_key, :password, :salt, :iv, :mac

    def initialize(address: nil, private_key: nil, password: nil, salt: nil, iv: nil)
      @address     = Address.new(address) if address
      @private_key = PrivateKey.new(private_key) if private_key
      @password    = password
      @salt        = convert_salt(salt || Utils.random_bytes(32))
      @iv          = convert_iv(iv || Utils.random_bytes(16))
    end

    def convert_salt(salt)
      if salt.length != 32 || salt.encoding != Encoding::ASCII_8BIT
        if salt.length == 64 && salt.encoding == Encoding::UTF_8
          salt = Utils.hex_to_bin(salt)
        else
          raise ArgumentError.new("salt must be 32 bytes")
        end
      end

      salt
    end

    def convert_iv(iv)
      if iv.length != 16 || iv.encoding != Encoding::ASCII_8BIT
        if iv.length == 32 && iv.encoding == Encoding::UTF_8
          iv = Utils.hex_to_bin(iv)
        else
          raise ArgumentError.new("iv must be 16 bytes")
        end
      end

      iv
    end

    def encrypt
      derived_key = Utils.scrypt(password, salt, KDF_N, KDF_R, KDF_P, DKLEN)
      cipher_bin  = Utils.aes_encrypt(private_key.encode(:bin), derived_key[0, 16], @iv)
      mac_bin     = Utils.keccak256([derived_key[16, 16], cipher_bin, iv, CIPHER_NAME].join)

      {
        version: KEY_CURRENT_VERSION,
        id: Utils.uuid,
        address: address.to_s,
        crypto: {
          ciphertext: Utils.bin_to_hex(cipher_bin),
          cipherparams: {
            iv: Utils.bin_to_hex(iv)
          },
          cipher: CIPHER_NAME,
          kdf: KDF,
          kdfparams: {
            dklen: DKLEN,
            salt: Utils.bin_to_hex(salt),
            n: KDF_N,
            r: KDF_R,
            p: KDF_P
          },
          mac: Utils.bin_to_hex(mac_bin),
          machash: MACHASH
        }
      }
    end

    def decrypt
    end


  end
end
