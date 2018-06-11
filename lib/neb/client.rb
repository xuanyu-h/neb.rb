# encoding: utf-8
# frozen_string_literal: true

require_relative "./client/admin"
require_relative "./client/api"

module Neb
  class Client
    attr_reader :api, :admin

    def initialize(config = {})
      Neb.configure(config) unless Neb.configured?

      @api   = API.new
      @admin = Admin.new
    end
  end
end

