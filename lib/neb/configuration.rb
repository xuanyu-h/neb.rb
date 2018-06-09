# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Configuration
    extend Forwardable
    def_delegators :@hash, :to_hash, :[], :[]=, :==, :fetch, :delete, :has_key?

    DEFAULTS = {
      host:        "http://localhost:8685",
      timeout:     "0",
      api_version: "v1",
      log:         "log/neb.log"
    }.freeze

    def initialize
      clear
    end

    def clear
      @hash = DEFAULTS.dup
    end

    def merge!(hash)
      hash = hash.dup
      @hash = @hash.deep_merge(hash)
    end

    def merge(hash)
      instance = self.class.new
      instance.merge!(to_hash)
      instance.merge!(hash)
      instance
    end
  end
end
