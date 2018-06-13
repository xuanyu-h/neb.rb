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

    def initialize(account, password = nil)
      @address  = account.address_obj
      @privkey  = account.private_key_obj
      @password = account.password || password
      @salt     = Utils.random_bytes(32)
      @iv       = Utils.random_bytes(16)
    end

    def encrypt
      derived_key = Utils.scrypt(@password, @salt, KDF_N, KDF_R, KDF_P, DKLEN)
      cipher_text = Utils.aes_encrypt(@privkey.encode(:bin), derived_key[0, 16], @iv)
      mac = Utils.keccak256([derived_key[16, 16], cipher_text, @iv, CIPHER_NAME].join)

      {
        version: KEY_CURRENT_VERSION,
        id: Utils.uuid,
        address: @address.to_s,
        crypto: {
          ciphertext: Utils.bin_to_hex(cipher_text),
          cipherparams: {
            iv: Utils.bin_to_hex(@iv)
          },
          cipher: CIPHER_NAME,
          kdf: KDF,
          kdfparams: {
            dklen: DKLEN,
            salt: Utils.bin_to_hex(@salt),
            n: KDF_N,
            r: KDF_R,
            p: KDF_P
          },
          mac: Utils.bin_to_hex(mac),
          machash: MACHASH
        }
      }
    end

    def decrypt

    end


  end
end
