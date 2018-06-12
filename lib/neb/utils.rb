# encoding: utf-8
# frozen_string_literal: true

require 'digest'
require 'sha3'
require 'openssl'
require 'base58'

module Neb
  module Utils
    extend self

    include Constant

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

    def lpad(x, symbol, l)
      return x if x.size >= l
      symbol * (l - x.size) + x
    end

    def rpad(x, symbol, l)
      return x if x.size >= l
      x + symbol * (l - x.size)
    end

    def zpad(x, l)
      lpad x, BYTE_ZERO, l
    end

    def mod_exp(x, y, n)
      x.to_bn.mod_exp(y, n).to_i
    end

    def mod_mul(x, y, n)
      x.to_bn.mod_mul(y, n).to_i
    end
  end
end
