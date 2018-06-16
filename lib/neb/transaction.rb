# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Transaction

    MAX_GAS_PRICE = 1_000_000_000_000
    MAX_GAS       = 50_000_000_000
    GAS_PRICE     = 1_000_000
    GAS_LIMIT     = 20_000

    PAYLOAD_BINARY_TYPE = "binary".freeze
    PAYLOAD_DEPLOY_TYPE = "deploy".freeze
    PAYLOAD_CALL_TYPE   = "call".freeze

    CHAIN_ID_LIST = {
      1    => { name: "Mainnet",     url: "https://mainnet.nebulas.io" },
      1001 => { name: "Testnet",     url: "https://testnet.nebulas.io" },
      100  => { name: "Local Nodes", url: "http://127.0.0.1:8685" }
    }.freeze

    attr_reader :chain_id, :from_account, :to_address, :value, :nonce,
                :gas_price, :gas_limit, :timestamp, :data

    def initialize(chain_id:, from_account:, to_address:, value:, nonce:,
                   gas_price: GAS_PRICE, gas_limit: GAS_LIMIT, contract: {})
      @chain_id     = chain_id
      @from_account = from_account
      @to_address   = to_address
      @value        = value
      @nonce        = nonce
      @gas_price    = gas_price
      @gas_limit    = gas_limit
      @data         = parse_contract(contract)
      @timestamp    = Time.now.to_i
    end

    def parse_contract(contract)
      payload_type, payload = nil, nil
      contract.deep_symbolize_keys!

      if contract.delete(:source).present?
        payload_type = PAYLOAD_DEPLOY_TYPE
        payload = {
          source_type: contract[:source_type],
          source: contrac[:source],
          args: contract[:args]
        }
      elsif contract.delete(:function).present?
        payload_type = PAYLOAD_CALL_TYPE
        payload = {
          function: contract[:function],
          args: contract[:args]
        }
      else
        payload_type = PAYLOAD_BINARY_TYPE
        if contract.present?
          payload = {
            data: BaseConvert.decode(contract[:binary], 256)
          }
        end
      end

      if payload.present?
        payload = JSON.dump(payload.deep_camelize_keys(:upper)).html_safe
      end

      { type: payload_type, payload: payload }
    end

    def hashed

    end

  end
end
