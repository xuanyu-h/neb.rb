# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Address
    attr_reader :raw

    def initialize(raw)
      @raw = raw
    end

    def value
      @value ||= decode
    end

    def to_s
      encode(:hex_extended)
    end

    def checksum
      Utils.keccak256(encode(:bin))[0, 4]
    end

    def encode(fmt)
      case fmt
      when :decimal
        raw
      when :bin
        BaseConvert.encode(value, 256, 22)
      when :bin_extended
        "#{BaseConvert.encode(value, 256, 22)}#{checksum}"
      when :hex
        Utils.binary_to_base58(BaseConvert.encode(value, 256, 22))
      when :hex_extended
        Utils.binary_to_base58("#{BaseConvert.encode(value, 256, 22)}#{checksum}")
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
      when :bin_extended
        BaseConvert.decode(raw[0, 22], 256)
      when :hex
        BaseConvert.decode(Utils.base58_to_binary(raw), 256)
      when :hex_extended
        BaseConvert.decode(Utils.base58_to_binary(raw)[0, 22], 256)
      else
        raise FormatError, "Invalid format!"
      end
    end

    def format
      return :decimal if raw.is_a?(Numeric)
      return :bin if raw.size == 22
      return :bin_extended if raw.size == 26
      return :hex if raw.size == 30
      return :hex_extended if raw.size == 35
    end

    class << self

      def is_validate?(address)
        addr = Utils.base58_to_binary(address)
        return false if addr.length != Constant::ADDRESS_LENGTH

        preifx = BaseConvert.decode(addr[0], 256)
        type   = BaseConvert.decode(addr[1], 256)

        return false if preifx != Constant::ADDRESS_PREFIX
        return false if type != Constant::NORMAL_TYPE && type != Constant::CONTRACT_TYPE

        content  = addr[0..21]
        checksum = addr[-4..-1]

        ActiveSupport::SecurityUtils.secure_compare(
          Utils.keccak256(content)[0, 4], checksum
        )
      end
    end

  end
end
