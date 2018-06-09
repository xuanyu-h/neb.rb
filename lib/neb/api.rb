# encoding: utf-8
# frozen_string_literal: true

module Neb
  module API
    def api_end_point
      @api_end_point ||= "#{CONFIG[:host]}/#{CONFIG[:api_version]}/user"
    end

    def send_request(action, url, payload = {})
      Request.new(action, api_end_point + url, payload).execute
    end

    def get_neb_state
      send_request(:get, "/nebstate")
    end

    def latest_irreversible_block
      send_request(:get, "/lib")
    end

    def get_account_state(address: '', height: 0)
      send_request(:post, "/accountstate", address: address, height: height)
    end

    def call(from: '', to: '', value: 0, nonce: 0, gas_price: 0, gas_limit: 0, contract: {})
      send_request(:post, "/call", from: from, to: to, value: value, nonce: nonce,
                                   gas_price: gas_price, gas_limit: gas_limit,
                                   contract: contract)
    end

    def send_raw_transaction(data: '')
      send_request(:post, "/rawtransaction", data: data)
    end

    def get_block_by_hash(hash: '', full_transaction: true)
      send_request(:post, "/getBlockByHash", hash: hash, full_fill_transaction: full_transaction)
    end

    def get_block_by_height(height: 1, full_transaction: true)
      send_request(:post, "/getBlockByHeight", height: height, full_fill_transaction: full_transaction)
    end

    def get_transaction_receipt(hash: '')
      send_request(:post, "/getTransactionReceipt", hash: hash)
    end

    def get_transaction_by_contract(address: '')
      send_request(:post, "/getTransactionByContract", address: address)
    end

    def subscribe(topics: [])
      send_request(:post, "/subscribe", topics: topics)
    end

    def get_gas_price
      send_request(:get, "/getGasPrice")
    end
    alias_method :gas_price, :get_gas_price

    def estimate_gas(from: '', to: '', value: 0, nonce: 0, gas_price: 0, gas_limit: 0, contract: {}, binary: '')
      send_request(:post, "/estimateGas", from: from, to: to, value: value, nonce: nonce,
                                          gas_price: gas_price, gas_limit: gas_limit,
                                          contract: contract, binary: binary)
    end

    def get_events_by_hash(hash: '')
      send_request(:post, "/getEventsByHash", hash: hash)
    end

    def get_dynasty(height: 1)
      send_request(:post, "/dynasty", height: height)
    end
  end
end
