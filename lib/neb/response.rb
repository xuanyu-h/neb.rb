# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Response
    extend Forwardable

    attr_reader :response
    def_delegators :@response, :code, :body

    SUCCESS_CODE = 200

    def initialize(action, url, params = {})
      @action = action
      @url    = url
      @params = params
    end

    def execute
      @response = ::RestClient::Request.execute(
        method:  @action,
        url:     @url,
        payload: @params.camelize_keys(:lower).to_json,
        headers: { content_type: :json, accept: :json }
      )

      self
    end

    def result
      JSON.parse(body, symbolize_names: true)[:result] if success?
    end

    def error
      JSON.parse(body, symbolize_names: true) if !success?
    end

    def success?
      code == SUCCESS_CODE
    end
  end
end
