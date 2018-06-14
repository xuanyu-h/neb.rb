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
      @salt        = self.class.convert_salt(salt || Utils.random_bytes(32))
      @iv          = self.class.convert_iv(iv || Utils.random_bytes(16))
    end

    def encrypt
      derived_key    = Utils.scrypt(password, salt, KDF_N, KDF_R, KDF_P, DKLEN)
      ciphertext_bin = Utils.aes_encrypt(private_key.encode(:bin), derived_key[0, 16], @iv)
      mac_bin        = Utils.keccak256([derived_key[16, 16], ciphertext_bin, iv, CIPHER_NAME].join)

      {
        version: KEY_CURRENT_VERSION,
        id: Utils.uuid,
        address: address.to_s,
        crypto: {
          ciphertext: Utils.bin_to_hex(ciphertext_bin),
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

    class << self

      def encrypt(address, private_key, password)
        new(address: address, private_key: private_key, password: password).encrypt
      end

      def decrypt(key_data, password)
        key_data = Utils.from_json(key_data) if key_data.is_a?(String)
        key_data = key_data.deep_symbolize_keys!

        raise InvalidJSONKeyError if !validate?(key_data)

        version = key_data[:version]
        address = key_data[:address]
        crypto  = key_data[:crypto]

        cipher = crypto[:cipher]
        salt   = convert_salt(crypto[:kdfparams][:salt])
        dklen  = crypto[:kdfparams][:dklen]
        kdf_n  = crypto[:kdfparams][:n]
        kdf_r  = crypto[:kdfparams][:r]
        kdf_p  = crypto[:kdfparams][:p]
        iv     = convert_iv(crypto[:cipherparams][:iv])

        derived_key    = Utils.scrypt(password, salt, kdf_n, kdf_r, kdf_p, dklen)
        ciphertext_bin = Utils.hex_to_bin(crypto[:ciphertext])

        if version == KEY_CURRENT_VERSION
          mac = Utils.keccak256([derived_key[16, 16], ciphertext_bin, iv, cipher].join)
        else
          mac = Utils.keccak256([derived_key[16, 16], ciphertext_bin].join)  # KeyVersion3
        end

        raise InvalidJSONKeyError if Utils.bin_to_hex(mac) != crypto[:mac]

        private_key = Utils.aes_decrypt(ciphertext_bin, derived_key[0, 16], iv)
        Utils.bin_to_hex(private_key)
      end

      def validate?(key_data)
        key_data = Utils.from_json(key_data) if key_data.is_a?(String)

        [:version, :id, :address, :crypto].each do |k|
          return false if !key_data.keys.include?(k)
        end

        return false if key_data[:version] != KEY_CURRENT_VERSION && key_data[:version] != KEY_VERSION_3

        [:ciphertext, :cipherparams, :cipher, :kdf, :kdfparams, :mac, :machash].each do |k|
          return false if !key_data[:crypto].keys.include?(k)
        end

        return false if !key_data[:crypto][:cipherparams].keys.include?(:iv)

        [:dklen, :salt, :n, :r, :p].each do |k|
          return false if !key_data[:crypto][:kdfparams].keys.include?(k)
        end

        true
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
    end
  end
end
