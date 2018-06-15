# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Transaction

    MAX_GAS_PRICE = 1_000_000_000_000
    MAX_GAS       = 50_000_000_000
    GAS_PRICE     = 1_000_000

    CHAIN_ID_MAP = {
      1    => { name: "Mainnet",     url: "https://mainnet.nebulas.io" },
      1001 => { name: "Testnet",     url: "https://testnet.nebulas.io" },
      100  => { name: "Local Nodes", url: "http://127.0.0.1:8685" }
    }.freeze

    attr_reader :chain_id, :from_account, :to_address, :value, :nonce,
                :gas_price, :gas_limit, :contract

    def initialize(chain_id:, from_account:, to_address:, value:, nonce:, gas_price: )

    end

  end
end
