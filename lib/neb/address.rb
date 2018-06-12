# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Address

    def initialize(bytes)
      @bytes = bytes
    end

    def to_bytes(extended = true)
      extended ? "#{@bytes}#{checksum}" : @bytes
    end

    def to_s
      Utils.base58(to_bytes)
    end

    def checksum
      Utils.keccak256(@bytes)[0,4]
    end

  end
end
