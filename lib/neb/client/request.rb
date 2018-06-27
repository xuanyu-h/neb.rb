# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Client
    class Request
      attr_reader :action, :url, :payload, :block

      def initialize(action, url, payload = {}, block = nil)
        @action  = action
        @url     = url
        @payload = payload
        @block   = custom_block(block)
      end

      def to_s
        "#{self.class}{action=#{action}, url=#{url}, payload=#{payload}}"
      end

      def request_args
        args = {
          method:  action,
          url:     url,
          payload: payload.deep_camelize_keys(:lower).to_json,
          headers: { content_type: :json, accept: :json },
          timeout: CONFIG[:timeout]
        }
        args.merge!(block_response: block) if block.present?
        args
      end

      def execute
        Neb.logger.debug(self.to_s)
        if block.present?
          ::RestClient::Request.execute(request_args)
        else
          ::RestClient::Request.execute(request_args, &default_block)
        end
      end

      private

      def default_block
        Proc.new { |resp, _, _| Response.new(resp) }
      end

      def custom_block(block)
        return nil if block.blank?
        Proc.new do |resp|
          resp.read_body do |chunk|
            block.call(chunk.force_encoding('utf-8'))
          end
        end
      end

    end
  end
end
