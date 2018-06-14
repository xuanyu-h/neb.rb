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
      def create(password = nil)
        new(PrivateKey.random.to_s, password)
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
      Key.encrypt(address, private_key, password)
    end

    def to_key_file(file_path = nil)
      file_path = Neb.root.join('tmp', "#{address}.json") if file_path.blank?
      File.open(file_path, 'w+') { |f| f << Utils.to_json(to_key) }
    end
  end
end
