# encoding: utf-8
# frozen_string_literal: true

require "logger"

require "neb/version"
require "neb/core_ext"
require "neb/configuration"
require "neb/utils"
require "neb/client"
require "neb/account"

module Neb
  extend self
  CONFIG = Configuration.new

  attr_reader :configured, :logger
  alias_method :configured?, :configured

  def configure(config = {})
    CONFIG.merge!(config)
    setup_general_logger!
    @configured = true
  end

  def clear!
    CONFIG.clear
    @logger = nil
    @configured = false
  end

  private

  def setup_general_logger!
    if [:info, :debug, :error, :warn].all?{ |meth| CONFIG[:log].respond_to?(meth) }
      @logger = CONFIG[:log]
    else
      @logger = ::Logger.new(CONFIG[:log])
      @logger.formatter = ::Logger::Formatter.new
    end
  end
end
