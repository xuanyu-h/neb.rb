# encoding: utf-8
# frozen_string_literal: true

module Neb
  module Utils
    extend self

    include Constant

    def to_json(h)
      JSON.generate(h)
    end

    def from_json(s)
      JSON.parse(s, symbolize_names: true)
    end

    def secure_compare(a, b)
      ActiveSupport::SecurityUtils.secure_compare(a, b)
    end

    # args: n, r, p, key_len
    def scrypt(secret, salt, *args)
      SCrypt::Engine.scrypt(secret, salt, *args)
    end

    def aes_encrypt(raw, bin_key, bin_iv)
      cipher = OpenSSL::Cipher::AES128.new(:ctr)
      cipher.encrypt
      cipher.key = bin_key
      cipher.iv = bin_iv

      result = cipher.update(raw)
      result += cipher.final
      result
    end

    def aes_decrypt(ciphertext, bin_key, bin_iv)
      cipher = OpenSSL::Cipher::AES128.new(:ctr)
      cipher.decrypt
      cipher.key = bin_key
      cipher.iv = bin_iv

      result = cipher.update(ciphertext)
      result += cipher.final
      result
    end

    def uuid
      SecureRandom.uuid
    end

    def encode64(str)
      Base64.strict_encode64(str)
    end

    def big_endian_to_int(s)
      RLP::Sedes.big_endian_int.deserialize(s.sub(/\A(\x00)+/, '')).force_encoding('utf-8')
    end

    def int_to_big_endian(n)
      RLP::Sedes.big_endian_int.serialize(n).force_encoding('ascii-8bit')
    end

    def bin_to_hex(bytes)
      BaseConvert.convert(bytes, 256, 16, bytes.size * 2).force_encoding('utf-8')
    end

    def hex_to_bin(hex)
      BaseConvert.convert(hex, 16, 256, hex.size / 2).force_encoding('ascii-8bit')
    end

    def random_bytes(size = 32)
      SecureRandom.random_bytes(size)
    end

    def keccak256(x)
      SHA3::Digest::SHA256.digest(x)
    end

    def keccak512(x)
      SHA3::Digest::SHA512.digest(x)
    end

    def sha256(x)
      Digest::SHA256.digest(x)
    end

    def ripemd160(x)
      Digest::RMD160.digest(x)
    end

    def hash160(x)
      ripemd160(keccak256(x))
    end

    def base58(x)
      Base58.binary_to_base58(x, :bitcoin)
    end
    alias_method :binary_to_base58, :base58

    def base58_to_binary(b)
      Base58.base58_to_binary(b, :bitcoin)
    end

    def lpad(x, symbol, l)
      return x if x.size >= l
      symbol * (l - x.size) + x
    end

    def rpad(x, symbol, l)
      return x if x.size >= l
      x + symbol * (l - x.size)
    end

    def zpad(x, l)
      lpad(x, BYTE_ZERO, l)
    end

    def mod_exp(x, y, n)
      x.to_bn.mod_exp(y, n).to_i
    end

    def mod_mul(x, y, n)
      x.to_bn.mod_mul(y, n).to_i
    end
  end
end
