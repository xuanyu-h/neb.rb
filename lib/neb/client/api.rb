# encoding: utf-8
# frozen_string_literal: true

require_relative "./request"
require_relative "./response"

module Neb
  class Client
    class API
      attr_reader :host, :api_version, :endpoint

      def initialize
        @host        = CONFIG[:host]
        @api_version = CONFIG[:api_version]
        @endpoint    = CONFIG[:api_endpoint]
      end

      def get_neb_state
        send_request(:get, "/nebstate")
      end

      def latest_irreversible_block
        send_request(:get, "/lib")
      end

      def get_account_state(address = '', height = 0)
        send_request(:post, "/accountstate", address: address, height: height)
      end

      def call(from, to, value, nonce, gas_price, gas_limit, contract = nil)
        params = {
          from:      from,
          to:        to,
          value:     value.to_i,
          nonce:     nonce.to_i,
          gas_price: gas_price.to_i,
          gas_limit: gas_limit.to_i,
          contract:  contract
        }

        send_request(:post, "/call", params)
      end

      # TODO: with bytes
      def send_raw_transaction(data)
        send_request(:post, "/rawtransaction", data: data)
      end

      def get_block_by_hash(hash, is_full = true)
        send_request(:post, "/getBlockByHash", hash: hash, full_fill_transaction: is_full)
      end

      def get_block_by_height(height, is_full = true)
        send_request(:post, "/getBlockByHeight", height: height, full_fill_transaction: is_full)
      end

      def get_transaction_receipt(hash)
        send_request(:post, "/getTransactionReceipt", hash: hash)
      end

      def get_transaction_by_contract(address)
        send_request(:post, "/getTransactionByContract", address: address)
      end

      def subscribe(topics = [])
        send_request(:post, "/subscribe", topics: topics)
      end

      def get_gas_price
        send_request(:get, "/getGasPrice")
      end
      alias_method :gas_price, :get_gas_price

      def estimate_gas(from, to, value, nonce, gas_price, gas_limit, contract = nil, binary = nil)
        params = {
          from:      from,
          to:        to,
          value:     value.to_i,
          nonce:     nonce.to_i,
          gas_price: gas_price.to_i,
          gas_limit: gas_limit.to_i,
          contract:  contract,
          binary:    binary
        }

        send_request(:post, "/estimateGas", params)
      end

      def get_events_by_hash(hash)
        send_request(:post, "/getEventsByHash", hash: hash)
      end

      def get_dynasty(height)
        send_request(:post, "/dynasty", height: height)
      end

      private

      def send_request(action, url, payload = {})
        request_url = host + api_version + endpoint + url
        Request.new(action, request_url, payload).execute
      end
    end
  end
end
