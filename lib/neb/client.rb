# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Client
    include API

    def initialize(config = {})
      Neb.configure(config) unless Neb.configured?
    end

  end
end

