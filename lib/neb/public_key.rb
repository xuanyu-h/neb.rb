# encoding: utf-8
# frozen_string_literal: true

module Neb
  class PublicKey
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    # skip the type flag, 04
    def to_s
      encode(:hex)[2..-1]
    end

    def encode(fmt)
      case fmt
      when :decimal
        value
      when :bin
        "\x04#{BaseConvert.encode(value[0], 256, 32)}#{BaseConvert.encode(value[1], 256, 32)}"
      when :bin_compressed
        "#{(2+(value[1]%2)).chr}#{BaseConvert.encode(value[0], 256, 32)}"
      when :hex
        "04#{BaseConvert.encode(value[0], 16, 64)}#{BaseConvert.encode(value[1], 16, 64)}"
      when :hex_compressed
        "0#{2+(value[1]%2)}#{BaseConvert.encode(value[0], 16, 64)}"
      else
        raise FormatError, "Invalid format!"
      end
    end

    def decode(fmt = nil)
      fmt ||= format

      case fmt
      when :decimal
        raw
      when :bin
        [BaseConvert.decode(raw[1, 32], 256), BaseConvert.decode(raw[33, 32], 256)]
      when :bin_compressed
        x = BaseConvert.decode raw[1, 32], 256
        m = x*x*x + Secp256k1::A*x + Secp256k1::B
        n = Utils.mod_exp(m, (Secp256k1::P+1)/4, Secp256k1::P)
        q = (n + raw[0].ord) % 2
        y = q == 1 ? (Secp256k1::P - n) : n
        [x, y]
      when :hex
        [BaseConvert.decode(raw[2, 64], 16), BaseConvert.decode(raw[66, 64], 16)]
      when :hex_compressed
        PublicKey.new(Utils.hex_to_bin(raw)).decode :bin_compressed
      else
        raise FormatError, "Invalid format!"
      end
    end

    def value
      @value ||= decode
    end

    def format
      return :decimal if raw.is_a?(Array)
      return :bin if raw.size == 65 && raw[0] == "\x04"
      return :hex if raw.size == 130 && raw[0, 2] == '04'
      return :bin_compressed if raw.size == 33 && "\x02\x03".include?(raw[0])
      return :hex_compressed if raw.size == 66 && %w(02 03).include?(raw[0,2])

      raise FormatError, "Pubkey is not in recognized format"
    end

    def to_address_obj
      bytes = [
        BaseConvert.encode(Constant::ADDRESS_PREFIX, 256, 1),
        BaseConvert.encode(Constant::NORMAL_TYPE, 256, 1),
        Utils.hash160(encode(:bin))
      ].join

      Address.new(bytes)
    end

    def to_address
      to_address_obj.to_s
    end

  end
end
