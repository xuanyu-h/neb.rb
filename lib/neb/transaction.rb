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
    attr_reader :hash, :sign

    def initialize(chain_id:, from_account:, to_address:, value:, nonce:,
                   gas_price: GAS_PRICE, gas_limit: GAS_LIMIT, contract: {})
      @chain_id     = chain_id
      @from_account = from_account
      @to_address   = Address.new(to_address)
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

      if contract[:source].present?
        payload_type = PAYLOAD_DEPLOY_TYPE
        payload = {
          source_type: contract[:source_type],
          source: contract[:source],
          args: contract[:args]
        }
      elsif contract[:function].present?
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
        payload = String.new(JSON.dump(payload.deep_camelize_keys(:upper)).html_safe)
        { type: payload_type, payload: payload }
      else
        { type: payload_type }
      end
    end

    def to_proto
      raise UnsignError.new("Must sign_hash first") if sign.blank?

      tx = Corepb::Transaction.new(
        hash:      hash,
        from:      from_account.address_obj.encode(:bin_extended),
        to:        to_address.encode(:bin_extended),
        value:     Utils.zpad(Utils.int_to_big_endian(value), 16),
        nonce:     nonce,
        timestamp: timestamp,
        data:      Corepb::Data.new(data),
        chain_id:  chain_id,
        gas_price: Utils.zpad(Utils.int_to_big_endian(gas_price), 16),
        gas_limit: Utils.zpad(Utils.int_to_big_endian(gas_limit), 16),
        alg:       Secp256k1::SECP256K1,
        sign:      sign
      )

      tx.to_proto
    end

    def to_proto_str
      Utils.encode64(to_proto)
    end

    def calculate_hash
      buffer = [
        from_account.address_obj.encode(:bin_extended),
        to_address.encode(:bin_extended),
        Utils.zpad(Utils.int_to_big_endian(value), 16),
        Utils.zpad(Utils.int_to_big_endian(nonce), 8),
        Utils.zpad(Utils.int_to_big_endian(timestamp), 8),
        Corepb::Data.new(data).to_proto,
        Utils.zpad(Utils.int_to_big_endian(chain_id), 4),
        Utils.zpad(Utils.int_to_big_endian(gas_price), 16),
        Utils.zpad(Utils.int_to_big_endian(gas_limit), 16)
      ].join

      Utils.keccak256(buffer)
    end

    def sign_hash
      @hash = calculate_hash
      @sign = Secp256k1.sign(@hash, from_account.private_key)
    end

  end
end
