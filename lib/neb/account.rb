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

      def from_key(json_key, password)
        private_key = Key.decrypt(json_key, password)
        new(private_key, password)
      end

      def from_key_file(key_file, password)
        from_key(File.read(key_file), password)
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
      Utils.to_json(Key.encrypt(address, private_key, password))
    end

    def to_key_file(fdir = nil, fname = nil)
      file_dir  = fdir || Neb.root.join('tmp')
      file_name = fname || "#{address}.json"

      File.open(file_dir.join(file_name), 'w+') { |f| f << to_key }
    end
  end
end
