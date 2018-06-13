# encoding: utf-8
# frozen_string_literal: true

require 'digest'
require 'sha3'
require 'openssl'
require 'base58'
require 'securerandom'
require 'scrypt'

module Neb
  module Utils
    extend self

    include Constant

    # args: n, r, p, key_len
    def scrypt(secret, salt, *args)
      SCrypt::Engine.scrypt(secret, salt, *args)
    end

    def aes_encrypt(bin_raw_content, bin_key, bin_iv)
      cipher = OpenSSL::Cipher::AES128.new(:ctr)
      cipher.encrypt
      cipher.key = bin_key
      cipher.iv = bin_iv

      result = cipher.update(bin_raw_content)
      result += cipher.final
      result
    end

    def uuid
      SecureRandom.uuid
    end

    def bin_to_hex(bytes)
      BaseConvert.convert(bytes, 256, 16)
    end

    def hex_to_bin(hex)
      BaseConvert.convert(hex, 16, 256)
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
