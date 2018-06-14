# encoding: utf-8
# frozen_string_literal: true

require "logger"
require "pathname"
require "digest"
require "sha3"
require "openssl"
require "base58"
require "securerandom"
require "scrypt"
require "active_support/all"
require "json"
require "forwardable"
require "rest-client"
require "secp256k1"
require "google/protobuf"

require "neb/version"
require "neb/exceptions"
require "neb/constant"
require "neb/utils"
require "neb/core_ext"
require "neb/configuration"
require "neb/base_convert"
require "neb/client"
require "neb/secp256k1"
require "neb/private_key"
require "neb/public_key"
require "neb/address"
require "neb/account"
require "neb/key"
require "neb/transaction"
require "neb/proto/transaction_pb"

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

  def root
    Pathname.new(File.expand_path('../..', __FILE__))
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
