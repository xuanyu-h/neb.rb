# encoding: utf-8
# frozen_string_literal: true

module Neb
  module Constant

    BYTE_EMPTY = "".freeze
    BYTE_ZERO  = "\x00".freeze
    BYTE_ONE   = "\x01".freeze

    TT32   = 2**32
    TT40   = 2**40
    TT160  = 2**160
    TT256  = 2**256
    TT64M1 = 2**64 - 1

    UINT_MAX = 2**256 - 1
    UINT_MIN = 0
    INT_MAX  = 2**255 - 1
    INT_MIN  = -2**255

    HASH_ZERO = ("\x00"*32).freeze

    PUBKEY_ZERO      = ("\x00"*32).freeze
    PRIVKEY_ZERO     = ("\x00"*32).freeze
    PRIVKEY_ZERO_HEX = ('0'*64).freeze

    CONTRACT_CODE_SIZE_LIMIT = 0x6000

    ADDRESS_LENGTH = 26
    ADDRESS_PREFIX = 25
    NORMAL_TYPE    = 87
    CONTRACT_TYPE  = 88
  end
end
