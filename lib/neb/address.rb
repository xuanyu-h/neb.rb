# encoding: utf-8
# frozen_string_literal: true

require 'active_support/security_utils'

module Neb
  class Address
    attr_reader :bytes

    def initialize(bytes)
      @bytes = bytes
    end

    def to_bytes(extended = true)
      extended ? "#{bytes}#{checksum}" : bytes
    end

    def to_s
      Utils.base58(to_bytes)
    end

    def checksum
      Utils.keccak256(bytes)[0, 4]
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
