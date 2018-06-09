# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Response
    extend Forwardable

    attr_reader :response
    def_delegators :@response, :code, :body

    SUCCESS_CODE = 200

    def initialize(response)
      @response = response
      Neb.logger.debug(self.to_s)
    end

    def to_s
      "#{self.class}{code=#{code}, body=#{body}}"
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
