# encoding: utf-8
# frozen_string_literal: true

require_relative "./request"
require_relative "./response"

module Neb
  class Client
    class Admin
      attr_reader :host, :api_version, :endpoint

      def initialize
        @host        = CONFIG[:host]
        @api_version = CONFIG[:api_version]
        @endpoint    = CONFIG[:admin_endpoint]
      end

      def node_info
        send_request(:get, "/nodeinfo")
      end

      def accounts
        send_request(:get, "/accounts")
      end

      def new_account(passphrase:)
        send_request(:post, "/account/new", passphrase: passphrase)
      end

      def unlock_account(address:, passphrase:, duration: '30000000000')
        params = {
          address:    address,
          passphrase: passphrase,
          duration:   duration
        }
        send_request(:post, "/account/unlock", params)
      end

      def lock_account(address:)
        send_request(:post, "/account/lock", address: address)
      end

      def send_transaction(from:, to:, value:, nonce:, gas_price: 1_000_000, gas_limit: 20_000)
        params = {
          from:      from,
          to:        to,
          value:     value.to_i,
          nonce:     nonce.to_i,
          gas_price: gas_price.to_i,
          gas_limit: gas_limit.to_i
        }
        send_request(:post, "/transaction", params)
      end

      def sign_hash(address:, hash:, alg: 1)
        send_request(:post, "/sign/hash", address: address, hash: hash, alg: alg)
      end

      def sign_transaction_with_passphrase(from:, to:, value:, nonce:, gas_price: 1_000_000, gas_limit: 20_000,
                                           type:, contract:, binary:, passphrase:)
        params = {
          transaction: {
            from:      from,
            to:        to,
            value:     value.to_i,
            nonce:     nonce.to_i,
            gas_price: gas_price.to_i,
            gas_limit: gas_limit.to_i,
            type:      type,
            contract:  contract,
            binary:    binary
          },
          passphrase:  passphrase
        }

        send_request(:post, "/transactionWithPassphrase", params)
      end

      def start_pprof(listen:)
        send_request(:post, "/pprof", listen: listen)
      end

      def get_config
        send_request(:get, "/getConfig")
      end

      private

      def send_request(action, url, payload = {})
        request_url = host + api_version + endpoint + url
        Request.new(action, request_url, payload).execute
      end
    end
  end
end
