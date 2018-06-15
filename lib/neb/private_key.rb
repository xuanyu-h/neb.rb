# encoding: utf-8
# frozen_string_literal: true

module Neb
  class PrivateKey
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def to_s
      encode(:hex)
    end

    def encode(fmt)
      return self.class.new(value).encode(fmt) unless raw.is_a?(Numeric)

      case fmt
      when :decimal
        raw
      when :bin
        BaseConvert.encode(raw, 256, 32)
      when :bin_compressed
        "#{BaseConvert.encode(raw, 256, 32)}\x01"
      when :hex
        BaseConvert.encode(raw, 16, 64)
      when :hex_compressed
        "#{BaseConvert.encode(raw, 16, 64)}01"
      else
        raise ArgumentError, "invalid format: #{fmt}"
      end
    end

    def decode(fmt = nil)
      fmt ||= format

      case fmt
      when :decimal
        raw
      when :bin
        BaseConvert.decode(raw, 256)
      when :bin_compressed
        BaseConvert.decode(raw[0, 32], 256)
      when :hex
        BaseConvert.decode(raw, 16)
      when :hex_compressed
        BaseConvert.decode(raw[0, 64], 16)
      else
        raise ArgumentError, "WIF does not represent privkey"
      end
    end

    def value
      @value ||= decode
    end

    def format
      return :decimal if raw.is_a?(Numeric)
      return :bin if raw.size == 32
      return :bin_compressed if raw.size == 33
      return :hex if raw.size == 64
      return :hex_compressed if raw.size == 66
    end

    def to_pubkey
      to_pubkey_obj.to_s
    end

    def to_pubkey_obj
      raise ValidationError, "Invalid private key" if value >= Secp256k1::N
      PublicKey.new(Secp256k1.priv_to_pub(encode(:bin)))
    end

    def to_address_obj
      PublicKey.new(to_pubkey_obj.encode(:bin)).to_address
    end

    def to_address
      to_address_obj.to_s
    end

    class << self

      def random
        new(Utils.random_bytes)
      end
    end

  end
end
