# encoding: utf-8
# frozen_string_literal: true

module Neb
  class Account
    attr_reader :private_key_obj, :public_key_obj, :address_obj
    attr_accessor :password

    alias_method :set_password, :password=

    def initialize(private_key, password = nil)
      @private_key_obj = PrivateKey.new(private_key)
      @public_key_obj  = @private_key_obj.to_pubkey_obj
      @address_obj     = @public_key_obj.to_address_obj
      @password        = password
    end

    class << self
      def create
        new(PrivateKey.random.to_s)
      end

      def to_key(account)
        account.to_key
      end

      def from_key(key)
      end
    end

    def private_key
      @private_key_obj.to_s
    end

    def public_key
      @public_key_obj.to_s
    end

    def address
      @address_obj.to_s
    end

    def to_key
      raise ArgumentError.new("must set_password first") if password.blank?
      Key.encrypt(address, private_key, password)
    end

    def to_file(fdir = nil, fname = nil)
      file_dir  = fdir || Neb.root.join('tmp')
      file_name = fname || "#{address}.json"

      File.open(file_dir.join(file_name), 'w+') do |f|
        f << JSON.generate(to_key)
      end
    end
  end
end
